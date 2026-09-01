#!/usr/bin/env python3
# SPDX-License-Identifier: MIT
"""Execute the deterministic VR-client transport fixture with Godot 4.7.2.

The fixture runs headlessly with XR disabled. It proves neither OpenXR/headset
runtime nor compatibility with the private canonical Zig server.
"""

from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

TARGET_PREFIX = "4.7.2.stable"
PROOF_LEVEL = "SYNTHETIC_FIXTURE_ONLY"


def run(command: list[str], cwd: Path, timeout: int) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        command,
        cwd=cwd,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        timeout=timeout,
        check=False,
    )


def find_fixture_report(output: str) -> dict[str, Any] | None:
    for line in reversed(output.splitlines()):
        line = line.strip()
        if not line.startswith("{"):
            continue
        try:
            value = json.loads(line)
        except json.JSONDecodeError:
            continue
        if value.get("schema") == "uo.godot-synthetic-transport-proof/v1":
            return value
    return None


def finish(report: dict[str, Any], evidence: str | None, code: int) -> int:
    rendered = json.dumps(report, indent=2, ensure_ascii=False)
    print(rendered)
    if evidence:
        target = Path(evidence).resolve()
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(rendered + "\n", encoding="utf-8")
        print(f"Evidence written to {target}", file=sys.stderr)
    return code


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--godot", default=os.environ.get("GODOT_BIN", "godot"))
    parser.add_argument("--project", default=str(Path(__file__).resolve().parents[1]))
    parser.add_argument("--timeout", type=int, default=120)
    parser.add_argument("--evidence", default=".evidence/godot-vr-synthetic-transport.json")
    args = parser.parse_args()

    project = Path(args.project).resolve()
    fixture = project / "tests" / "synthetic_transport_fixture.gd"
    if not (project / "project.godot").is_file() or not fixture.is_file():
        print("ERROR: project or synthetic fixture is missing", file=sys.stderr)
        return 2
    if args.timeout < 5 or args.timeout > 900:
        print("ERROR: --timeout must be between 5 and 900 seconds", file=sys.stderr)
        return 2

    report: dict[str, Any] = {
        "schema": "uo.godot-vr-synthetic-transport-run/v1",
        "proof_level": PROOF_LEVEL,
        "canonical_zig_compatibility_proven": False,
        "openxr_runtime_proven": False,
        "headset_runtime_proven": False,
        "xr_mode": "off",
        "created_at": datetime.now(timezone.utc).isoformat(),
        "target_engine": "4.7.2-stable",
    }

    try:
        version = run([args.godot, "--version"], project, args.timeout)
    except (OSError, subprocess.TimeoutExpired) as exc:
        report["passed"] = False
        report["failure"] = f"Godot version check failed: {exc}"
        return finish(report, args.evidence, 1)

    version_text = (version.stdout + version.stderr).strip()
    report["detected_version"] = version_text
    if version.returncode != 0 or not version_text.startswith(TARGET_PREFIX):
        report["passed"] = False
        report["failure"] = f"Expected Godot {TARGET_PREFIX}*, got {version_text!r}"
        return finish(report, args.evidence, 1)

    try:
        process = run(
            [
                args.godot,
                "--headless",
                "--xr-mode",
                "off",
                "--path",
                str(project),
                "--script",
                "res://tests/synthetic_transport_fixture.gd",
            ],
            project,
            args.timeout,
        )
    except (OSError, subprocess.TimeoutExpired) as exc:
        report["passed"] = False
        report["failure"] = f"Synthetic fixture execution failed: {exc}"
        return finish(report, args.evidence, 1)

    report["returncode"] = process.returncode
    report["stdout"] = process.stdout[-12000:]
    report["stderr"] = process.stderr[-12000:]
    fixture_report = find_fixture_report(process.stdout + "\n" + process.stderr)
    report["fixture"] = fixture_report

    passed = (
        process.returncode == 0
        and fixture_report is not None
        and fixture_report.get("passed") is True
        and fixture_report.get("proof_level") == PROOF_LEVEL
        and fixture_report.get("canonical_zig_compatibility_proven") is False
        and fixture_report.get("openxr_runtime_proven") is False
        and fixture_report.get("headset_runtime_proven") is False
    )
    report["passed"] = passed
    if not passed:
        report["failure"] = "Fixture did not return a valid synthetic-only XR-off success receipt"

    return finish(report, args.evidence, 0 if passed else 1)


if __name__ == "__main__":
    raise SystemExit(main())
