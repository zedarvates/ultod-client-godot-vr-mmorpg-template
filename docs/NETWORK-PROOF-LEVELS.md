# Network and VR proof levels

This public Godot VR starter separates documentation, synthetic client evidence, engine/OpenXR evidence, and real interoperability with the private canonical Ultimate Odycer Zig server.

## Network levels

| Level | Meaning | May claim Zig compatibility? |
|---|---|---|
| `DOCUMENTED` | Intent/authority rules are documented only. | No |
| `SYNTHETIC_FIXTURE_ONLY` | A public isolated fixture exercises VR/client semantics without the private server. | No |
| `PINNED_SERVER_AVAILABLE` | Exact private Zig revision, toolchain, build mode and protocol revision are recorded. | No, not until exercised |
| `REAL_SERVER_E2E` | Exact Godot/OpenXR/client and Zig revisions pass the canonical scenario. | Yes, only for the tested scope |
| `ADVERSARIAL_E2E` | Malformed/replay/pose/authority-abuse cases also pass against the pinned server. | Yes, with tested security scope named |
| `RELEASE_PROVEN` | Exact release revisions repeat the required engine, VR, network and release gates. | Yes, for those exact revisions |

## Engine / XR evidence is independent

A successful headless Godot load is not headset evidence. Track separately:

- `ENGINE_DOCUMENTED`: repository metadata only;
- `ENGINE_LOAD_PROVEN`: exact Godot binary loads the project;
- `OPENXR_INIT_PROVEN`: named OpenXR runtime initializes with the exact client revision;
- `HEADSET_RUNTIME_PROVEN`: named headset/controller/runtime executes the required VR scenario;
- `NETWORK_PROVEN`: exact client/server revisions pass the network gate.

No one proof implies another.

## Fake-green rule

`FAKE-GREEN` includes presenting a desktop scene load as headset validation, presenting synthetic pose data as live OpenXR proof, presenting a mock server as Zig interoperability, or changing `project.godot` from 4.3 to 4.7.2 without actually loading the project using Godot 4.7.2.

## Current VR status

- Godot declaration: `4.3`.
- Target engine baseline: `4.7.2-stable`, not yet proven.
- OpenXR: enabled in project configuration, runtime/headset proof not established here.
- Network: `DOCUMENTED` / Zig compatibility `NOT_PROVEN`.
- Historical VR networking: `LEGACY_QUARANTINED`; old Zig assumptions must not be copied into the new starter.

## Licensing boundary

This public starter remains governed by its explicit repository license. Historical/private Ultimate Odycer server/game implementation, production configuration, private assets/lore and commercial components remain proprietary/commercial, all rights reserved unless their own explicit license states otherwise. Public fixtures must not copy private implementation code merely to make tests pass.
