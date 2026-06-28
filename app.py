"""Minimal ALA FastAPI application shell."""

from __future__ import annotations

import os
from datetime import datetime, timezone

from fastapi import FastAPI
from fastapi.responses import HTMLResponse

from src.runtime_paths import get_app_root

app = FastAPI(title="ALA", version="1.0.1")


@app.get("/")
async def root() -> HTMLResponse:
    return HTMLResponse("<html><body><h1>ALA</h1><p>Local ALA workspace is running.</p></body></html>")


@app.get("/api/version")
async def version() -> dict[str, str]:
    return {"version": "1.0.1"}


@app.get("/api/health")
async def health() -> dict[str, str]:
    return {"status": "healthy", "timestamp": datetime.now(timezone.utc).isoformat()}


@app.get("/login")
async def login() -> HTMLResponse:
    return HTMLResponse("<html><body><h1>ALA Login</h1></body></html>")


if __name__ == "__main__":
    import uvicorn

    bind_host = os.getenv("APP_BIND", "127.0.0.1")
    bind_port = int(os.getenv("APP_PORT", "7000"))
    uvicorn.run(app, host=bind_host, port=bind_port, log_level="info")
