#!/usr/bin/env python3
"""
Gera um relatório simples do sistema em formato JSON.
Compatível com Windows, Linux e macOS usando apenas bibliotecas standard.
"""

from __future__ import annotations

import json
import os
import platform
import shutil
import socket
from datetime import datetime
from pathlib import Path


def get_disk_info() -> dict[str, float]:
    usage = shutil.disk_usage(Path.home())
    return {
        "total_gb": round(usage.total / (1024 ** 3), 2),
        "used_gb": round(usage.used / (1024 ** 3), 2),
        "free_gb": round(usage.free / (1024 ** 3), 2),
    }


def build_report() -> dict:
    return {
        "timestamp": datetime.now().isoformat(),
        "hostname": socket.gethostname(),
        "user": os.getenv("USERNAME") or os.getenv("USER"),
        "platform": platform.platform(),
        "system": platform.system(),
        "release": platform.release(),
        "version": platform.version(),
        "machine": platform.machine(),
        "processor": platform.processor(),
        "python_version": platform.python_version(),
        "home_directory": str(Path.home()),
        "disk_home": get_disk_info(),
    }


def main() -> None:
    output_dir = Path(__file__).resolve().parent.parent / "output"
    output_dir.mkdir(parents=True, exist_ok=True)

    filename = output_dir / f"pc_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
    report = build_report()

    with filename.open("w", encoding="utf-8") as fh:
        json.dump(report, fh, indent=2, ensure_ascii=False)

    print(f"Relatório criado em: {filename}")


if __name__ == "__main__":
    main()
