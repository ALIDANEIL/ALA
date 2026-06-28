"""Minimal setup wizard bridge used by the frozen launcher."""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path


class SetupWizard:
    def run(self) -> bool:
        root = Path(__file__).resolve().parents[1]
        setup_py = root / "setup.py"
        if not setup_py.exists():
            return True
        proc = subprocess.run([sys.executable, str(setup_py)], cwd=str(root))
        return proc.returncode == 0
