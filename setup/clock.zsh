# --- clocks ---
# time_now: print the current time once in big figlet letters
has figlet /opt/homebrew/bin/figlet && \
    alias time_now='figlet "$(date +%H:%M:%S)"'
# show_clock: full-screen clock, centered, with seconds, cyan (q to quit)
has tty-clock /opt/homebrew/bin/tty-clock && \
    alias show_clock='tty-clock -c -s -C 6'
