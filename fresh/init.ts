// Copy "/full/path:line" (or "/full/path:start-end" for a multi-line
// selection) to the clipboard, with symlinks resolved. Bound to Ctrl+Alt+L
// in config.json; also in the command palette as "Copy Path + Line Range".
registerHandler("copy_file_ref", async () => {
  const buf = editor.getActiveBufferId();
  const cur = editor.getPrimaryCursor();
  const path = editor.getBufferPath(buf);
  if (!cur || !path) return editor.setStatus("no file to reference");

  // Offsets are bytes, so count newlines in buffer text instead of slicing.
  const sel = cur.selection ?? { start: cur.position, end: cur.position };
  const before = await editor.getBufferText(buf, 0, sel.start);
  // Drop a trailing newline so a whole-line selection doesn't count the next line.
  const inside = (await editor.getBufferText(buf, sel.start, sel.end)).replace(/\n$/, "");
  const start = before.split("\n").length;
  const end = start + inside.split("\n").length - 1;

  const real = await editor.runOnTarget("realpath", [path]);
  const file = real.code === 0 ? real.stdout.trim() : path;
  editor.setClipboard(start === end ? `${file}:${start}` : `${file}:${start}-${end}`);
  editor.setStatus("reference copied");
});
editor.registerCommand("Copy Path + Line Range", "Copy file:line to the clipboard", "copy_file_ref");

// Vi mode: block cursor in normal/visual, thin bar only in insert.
// ponytail: Fresh applies editor.cursor_style only at startup (setSetting
// doesn't redraw it), so send the terminal's cursor-shape code (DECSCUSR)
// to /dev/tty ourselves. Drop this if Fresh or vi_mode learns per-mode cursors.
editor.on("input_mode_changed", ({ mode }) => {
  const block = mode !== null && mode.startsWith("vi-") && mode !== "vi-insert";
  editor.spawnHostProcess("sh", ["-c", `printf '\\033[${block ? 2 : 6} q' > /dev/tty`]);
});
