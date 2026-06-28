"""Runtime path helpers for local and frozen ALA launches."""

from __future__ import annotations

import os
import sys
from pathlib import Path


def get_app_root() -> str:
    if getattr(sys, "frozen", False):
        return str(Path(sys.executable).resolve().parent)
    return str(Path(__file__).resolve().parents[1])


def get_default_data_dir() -> str:
    base = os.environ.get("ALA_DATA_DIR") or os.environ.get("ODYSSEUS_DATA_DIR")
    if base:
        return base
    return str(Path.home() / ".ala" / "data")
