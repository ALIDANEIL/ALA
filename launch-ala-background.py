"""Launch ALA in the background without showing a CMD window.

The script prefers the packaged `dist/ALA/ALA.exe` if it exists. Otherwise it
falls back to the local `launcher.py` entrypoint and uses
`subprocess.CREATE_NO_WINDOW` on Windows so the child process starts hidden.

Usage:
  pythonw launch-ala-background.py
  python launch-ala-background.py
"""

from __future__ import annotations

import os
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent
TEMP_DIR = Path(os.environ.get("TEMP", str(ROOT / "logs")))
LOG_DIR = TEMP_DIR / "ALA"
LOG_DIR.mkdir(parents=True, exist_ok=True)
LOG_FILE = LOG_DIR / "background-launch.log"


def _pick_command() -> tuple[list[str], Path]:
    packaged = ROOT / "dist" / "ALA" / "ALA.exe"
    if packaged.exists():
        return [str(packaged)], packaged.parent

    interpreter = Path(sys.executable)
    pythonw = interpreter.with_name("pythonw.exe")
    if pythonw.exists():
        interpreter = pythonw
    return [str(interpreter), str(ROOT / "launcher.py")], ROOT


def main() -> int:
    cmd, cwd = _pick_command()
    creationflags = getattr(subprocess, "CREATE_NO_WINDOW", 0)

    with LOG_FILE.open("a", encoding="utf-8") as log:
        log.write(f"Launching: {' '.join(cmd)}\n")
        proc = subprocess.Popen(
            cmd,
            cwd=str(cwd),
            stdin=subprocess.DEVNULL,
            stdout=log,
            stderr=subprocess.STDOUT,
            creationflags=creationflags,
            close_fds=False,
        )
        log.write(f"PID: {proc.pid}\n")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
