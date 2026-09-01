# Synthetic transport fixture — VR starter

Status: **PREPARED / CI-GUARDED — runtime proof pending**.

The VR starter carries the same deterministic, socket-free transport fixture as the Classic client so the shared network intent/state-machine boundary can be exercised before canonical Zig interoperability is available.

## Proof level

Maximum output: `SYNTHETIC_FIXTURE_ONLY`.

The fixture runs with XR explicitly disabled and therefore does **not** prove:

- OpenXR initialization;
- headset/controller tracking or input;
- VR pose/grab/release networking;
- canonical Zig compatibility;
- TCP/WebSocket/ENet framing or endpoints;
- production authentication, TLS, persistence, economy, combat, permissions, or anti-cheat behavior.

## Components

- `net/intent_contract.gd` — shared bounded base intents only;
- `net/transport_adapter.gd` — abstract transport lifecycle;
- `net/synthetic_transport.gd` — deterministic local test authority, no socket;
- `tests/synthetic_transport_fixture.gd` — offline/auth/movement/authority-field/drop/resume assertions;
- `tools/validate_godot_4_7_2_headless.py` — exact Godot 4.7.2 engine/import/bootstrap proof with XR off;
- `tools/validate_synthetic_transport.py` — Godot 4.7.2 XR-off synthetic runner and JSON receipt writer;
- `tools/run_p0_local_proof.py` — fail-closed one-command orchestrator using the same exact Godot binary for both gates.

VR-specific pose, grab and release intents remain behind a separate reviewed gate. The legacy VR network implementation remains `LEGACY_QUARANTINED` and is not used by this fixture.

## One-command local proof

With an exact Godot 4.7.2-stable binary:

```bash
python tools/run_p0_local_proof.py --godot /path/to/godot
```

The orchestrator first performs the XR-off engine/import/bootstrap proof. It stops at the first failure. Only after that succeeds does it execute the synthetic transport fixture with the **same** Godot binary.

Receipts are written below `.evidence/`, which is ignored by Git. They must retain:

- `proof_level=SYNTHETIC_FIXTURE_ONLY` for the synthetic receipt;
- `xr_mode=off`;
- `openxr_runtime_proven=false`;
- `headset_runtime_proven=false`;
- `canonical_zig_compatibility_proven=false`.

Promotion of any of those false fields requires its own named executable proof.

## Licensing boundary

This fixture is original MIT starter code. It contains no private Zig implementation, historical private VR transport, production endpoint, private asset/lore, or commercial configuration. Private Ultimate Odycer server/game implementation remains proprietary/commercial, all rights reserved unless explicitly licensed otherwise.
