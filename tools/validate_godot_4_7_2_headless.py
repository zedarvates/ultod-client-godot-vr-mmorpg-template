#!/usr/bin/env python3
# SPDX-License-Identifier: MIT
"""Local engine proof for the Godot VR starter using XR explicitly disabled.

This proves only that the project imports and boots headlessly on Godot 4.7.2.
It does NOT prove OpenXR initialization, headset/controller behavior, or Zig
server compatibility. Those are separate evidence gates.
"""

from __future__ import annotations

import argparse
import json
import os
import platform
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

TARGET_PREFIX = "4.7.2.stable"


def run_step(name: str, command: list[str], cwd: Path, timeout: int) -> dict[str, Any]:
    started = datetime.now(timezone.utc)
    try:
        process = subprocess.run(
            command,
            cwd=cwd,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            timeout=timeout,
            check=False,
        )
        return {
            "name": name,
            "command": command,
            "returncode": process.returncode,
            "stdout": process.stdout[-12000:],
            "stderr": process.stderr[-12000:],
            "started_at": started.isoformat(),
            "finished_at": datetime.now(timezone.utc).isoformat(),
        }
    except subprocess.TimeoutExpired as exc:
        return {
            "name": name,
            "command": command,
            "returncode": None,
            "timed_out": True,
            "stdout": (exc.stdout or "")[-12000:] if isinstance(exc.stdout, str) else "",
            "stderr": (exc.stderr or "")[-12000:] if isinstance(exc.stderr, str) else "",
            "started_at": started.isoformat(),
            "finished_at": datetime.now(timezone.utc).isoformat(),
        }


def finish(report: dict[str, Any], evidence_path: str | None, code: int) -> int:
    rendered = json.dumps(report, indent=2, ensure_ascii=False)
    print(rendered)
    if evidence_path:
        target = Path(evidence_path).resolve()
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(rendered + "\n", encoding="utf-8")
        print(f"Evidence written to {target}", file=sys.stderr)
    return code


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--godot",
        default=os.environ.get("GODOT_BIN", "godot"),
        help="Godot editor binary path (default: GODOT_BIN or godot on PATH)",
    )
    parser.add_argument(
        "--project",
        default=str(Path(__file__).resolve().parents[1]),
        help="Project directory containing project.godot",
    )
    parser.add_argument("--timeout", type=int, default=120, help="Timeout per Godot step in seconds")
    parser.add_argument("--evidence", help="Optional JSON evidence output path")
    args = parser.parse_args()

    project = Path(args.project).resolve()
    if not (project / "project.godot").is_file():
        print(f"ERROR: project.godot not found under {project}", file=sys.stderr)
        return 2
    if args.timeout < 5 or args.timeout > 900:
        print("ERROR: --timeout must be between 5 and 900 seconds", file=sys.stderr)
        return 2

    report: dict[str, Any] = {
        "schema": "uo.godot-vr-engine-proof/v1",
        "proof_scope": "ENGINE_LOAD_AND_HEADLESS_BOOT_XR_OFF_ONLY",
        "target": "4.7.2-stable",
        "project": str(project),
        "platform": platform.platform(),
        "created_at": datetime.now(timezone.utc).isoformat(),
        "xr_mode": "off",
        "openxr_runtime_proven": False,
        "headset_runtime_proven": False,
        "network_compatibility_proven": False,
        "steps": [],
    }

    version = run_step("version", [args.godot, "--version"], project, args.timeout)
    report["steps"].append(version)
    version_text = (version.get("stdout", "") + version.get("stderr", "")).strip()
    report["detected_version"] = version_text
    if version.get("returncode") != 0 or not version_text.startswith(TARGET_PREFIX):
        report["passed"] = False
        report["failure"] = f"Expected Godot {TARGET_PREFIX}*, got {version_text!r}"
        return finish(report, args.evidence, 1)

    import_step = run_step(
        "headless_import_xr_off",
        [args.godot, "--headless", "--xr-mode", "off", "--path", str(project), "--import"],
        project,
        args.timeout,
    )
    report["steps"].append(import_step)
    if import_step.get("returncode") != 0:
        report["passed"] = False
        report["failure"] = "Headless project import with XR disabled failed"
        return finish(report, args.evidence, 1)

    boot_step = run_step(
        "headless_boot_xr_off",
        [args.godot, "--headless", "--xr-mode", "off", "--path", str(project), "--quit-after", "3"],
        project,
        args.timeout,
    )
    report["steps"].append(boot_step)
    report["passed"] = boot_step.get("returncode") == 0
    if not report["passed"]:
        report["failure"] = "Headless bootstrap with XR disabled failed"

    return finish(report, args.evidence, 0 if report["passed"] else 1)


if __name__ == "__main__":
    raise SystemExit(main())
