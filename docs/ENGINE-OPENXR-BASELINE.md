# Godot 4.7.2 and OpenXR validation baseline

## Current state

`project.godot` currently declares Godot `4.3`, enables OpenXR, and uses Forward Plus. Those declarations are configuration, not runtime proof.

## Target engine

Target validation baseline: **Godot 4.7.2-stable**.

The project metadata must not be changed merely to appear current. Promote the version only after an executable validation run using the exact target engine.

## Engine validation sequence

1. Record exact Godot binary/version output.
2. Load/import the unmodified project headlessly with Godot 4.7.2.
3. Capture parser, resource, scene and compatibility errors/warnings.
4. Correct only demonstrated compatibility issues.
5. Re-run until the agreed engine gate passes.
6. Execute the bootstrap scene in the strongest non-headset mode supported by the environment.
7. Promote `project.godot` metadata only after the proof exists.
8. Re-run the gate on the promoted commit.

Use the repository validator for engine-only proof with XR explicitly disabled:

```bash
python tools/validate_godot_4_7_2_headless.py \
  --godot /path/to/godot-4.7.2 \
  --evidence .evidence/godot-4.7.2-vr-headless.json
```

`.evidence/` is intentionally gitignored. The generated receipt records `xr_mode=off`, `openxr_runtime_proven=false`, `headset_runtime_proven=false`, and `network_compatibility_proven=false`; therefore a successful headless run must never be promoted as OpenXR/headset/network proof.

## OpenXR validation sequence

Engine load and OpenXR/headset validation are separate.

1. Record exact Godot version.
2. Record OpenXR runtime name/version.
3. Record headset/controller model and firmware/runtime where available.
4. Record active OpenXR extensions/features used by the starter.
5. Verify XR interface initialization.
6. Verify head and controller tracking availability.
7. Verify locomotion/input mapping without granting client gameplay authority.
8. Record expected failure/degraded behavior when no headset/runtime is available.

## Evidence levels

- `ENGINE_DOCUMENTED`: metadata only.
- `ENGINE_LOAD_PROVEN`: exact Godot binary loads project.
- `OPENXR_INIT_PROVEN`: named runtime initializes XR interface.
- `HEADSET_RUNTIME_PROVEN`: named headset/controller executes required scenario.
- `NETWORK_PROVEN`: separate exact client/server interoperability proof.

No level implies another.

## Cost / CI rule

Prefer an authorized self-hosted Ultimate Odycer runner or local validation machine for repeated Godot/OpenXR tests when available. Do not add a heavy hosted-engine download to every documentation change. Lightweight metadata checks may run in the existing documentation job.

## Licensing boundary

This public starter remains under its explicit MIT license. Private/historical Ultimate Odycer server/game implementation and commercial content remain proprietary/commercial, all rights reserved unless explicitly licensed otherwise.
