// Sets "Automatically hide and show the menu bar" from the connected displays:
// "Always" with an external display, "In Full Screen Only" without one.
//
// Watches display hardware through IOKit, because AppKit's event loop leaks at
// startup and a plain run loop gets no CoreGraphics display events.
//
// The objects created in main live until the process exits. Each IOKit service
// from an iterator is released. No other call returns an object to release.
// CoreFoundation: https://developer.apple.com/documentation/corefoundation
// CoreGraphics: https://developer.apple.com/documentation/coregraphics
// IOKit: https://developer.apple.com/documentation/iokit
#include <CoreFoundation/CoreFoundation.h>
#include <CoreGraphics/CoreGraphics.h>
#include <IOKit/IOKitLib.h>
#include <stdbool.h>
#include <stdio.h>

#define MAX_DISPLAYS 32
#define HIDE_KEY CFSTR("_HIHideMenuBar")
#define FULLSCREEN_KEY CFSTR("AppleMenuBarVisibleInFullscreen")
// ponytail: this class exists only on Apple Silicon; Intel Macs need a different class.
#define DISPLAY_SERVICE_CLASS "DCPAVServiceProxy"
// The display list can be out of date when IOKit reports a change. It was correct after 2 seconds.
#define SETTLE_SECONDS 2.0
// The timer is rearmed on each display event, so it stays idle until then.
#define IDLE_TIMER_SECONDS (365.0 * 24.0 * 60.0 * 60.0)
#define ARRAY_COUNT(array) (sizeof(array) / sizeof((array)[0]))

static const char *const SERVICE_EVENTS[] = {kIOFirstMatchNotification, kIOTerminatedNotification};

static CFRunLoopTimerRef settle_timer;

static bool has_pref_value(CFStringRef key, bool pref) {
    Boolean valid = false;
    Boolean value = CFPreferencesGetAppBooleanValue(key, kCFPreferencesAnyApplication, &valid);
    return valid && (bool)value == pref;
}

static void write_pref(CFStringRef key, bool value) {
    CFPreferencesSetValue(key, value ? kCFBooleanTrue : kCFBooleanFalse, kCFPreferencesAnyApplication,
                          kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
}

// hide=true is "Always", hide=false is "In Full Screen Only".
static void set_hide(bool hide) {
    CFPreferencesAppSynchronize(kCFPreferencesAnyApplication);
    if (has_pref_value(HIDE_KEY, hide) && has_pref_value(FULLSCREEN_KEY, false)) return;

    write_pref(HIDE_KEY, hide);
    write_pref(FULLSCREEN_KEY, false);
    CFPreferencesSynchronize(kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(),
                                         CFSTR("AppleInterfaceMenuBarHidingChangedNotification"),
                                         NULL, NULL, true);
}

static void sync_menu_bar(void) {
    CGDirectDisplayID ids[MAX_DISPLAYS];
    uint32_t count = 0;
    if (CGGetOnlineDisplayList(MAX_DISPLAYS, ids, &count) != kCGErrorSuccess) return;

    bool external = false;
    for (uint32_t i = 0; i < count; i++) external |= !CGDisplayIsBuiltin(ids[i]);
    set_hide(external);
}

static void on_settled(CFRunLoopTimerRef timer, void *info) {
    (void)timer;
    (void)info;
    sync_menu_bar();
}

// IOKit sends no more notifications until the iterator is emptied.
static void drain(io_iterator_t iterator) {
    io_object_t service;
    while ((service = IOIteratorNext(iterator))) IOObjectRelease(service);
}

static void on_display_service(void *context, io_iterator_t iterator) {
    (void)context;
    drain(iterator);
    CFRunLoopTimerSetNextFireDate(settle_timer, CFAbsoluteTimeGetCurrent() + SETTLE_SECONDS);
}

int main(void) {
    IONotificationPortRef port = IONotificationPortCreate(kIOMainPortDefault);
    if (!port) {
        fprintf(stderr, "menu-bar-sync: cannot create IOKit notification port\n");
        return 1;
    }
    CFRunLoopAddSource(CFRunLoopGetCurrent(), IONotificationPortGetRunLoopSource(port), kCFRunLoopDefaultMode);

    settle_timer = CFRunLoopTimerCreate(NULL, CFAbsoluteTimeGetCurrent() + IDLE_TIMER_SECONDS, IDLE_TIMER_SECONDS, 0, 0,
                                        on_settled, NULL);
    CFRunLoopAddTimer(CFRunLoopGetCurrent(), settle_timer, kCFRunLoopDefaultMode);

    for (size_t i = 0; i < ARRAY_COUNT(SERVICE_EVENTS); i++) {
        io_iterator_t iterator;
        kern_return_t result = IOServiceAddMatchingNotification(port, SERVICE_EVENTS[i], IOServiceMatching(DISPLAY_SERVICE_CLASS),
                                                                on_display_service, NULL, &iterator);
        if (result != KERN_SUCCESS) {
            fprintf(stderr, "menu-bar-sync: cannot watch displays (kern_return_t %d)\n", result);
            return 1;
        }
        drain(iterator);
    }

    sync_menu_bar();
    CFRunLoopRun();
    return 0;
}
