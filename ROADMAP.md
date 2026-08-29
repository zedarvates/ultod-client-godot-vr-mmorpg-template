# Roadmap

| Gate | State | Exit condition |
|---|---|---|
| Documentation foundation | complete | Scope, security and publication boundaries are public |
| Zig server alignment | blocked / tracked | `ultimate-odycer-feedback#5` must pin the canonical private Zig revision; legacy VR assumptions remain quarantined |
| Public extraction design | complete | File-level allowlist and license audit are documented in [docs/PUBLIC-EXTRACTION-DESIGN.md](docs/PUBLIC-EXTRACTION-DESIGN.md) |
| Minimal Godot/OpenXR shell | complete | Original isolated presentation shell created from allowlist (project.godot, scenes, input) |
| Canonical connectivity fixture | waiting / tracked | `ultimate-odycer-feedback#7` ports the same authoritative fixture proven first by Three.js |
| VR authority/anti-cheat fixture | waiting / tracked | Pose, reach, velocity, grab/release and impossible-movement cases remain intent-only and server validated under `#7`/`#8` |
| Paranoid protocol security | waiting / tracked | `ultimate-odycer-feedback#8` supplies negative fixtures, fuzzing, anti-replay and anti-duplication gates |
| Headset validation | waiting | Named Godot/OpenXR runtime/device evidence is recorded after canonical network alignment |
| Crash-safe persistence evidence | server-side / tracked | `ultimate-odycer-feedback#9` proves persistence/restore independently from the VR presentation layer |
| Template release | waiting | Fresh clone, license, secrets and documentation gates pass |

## P0 interoperability program

The old VR network assumptions are legacy evidence only and must not be copied into the new client. The execution sequence is:

1. `ultimate-odycer-feedback#5` — pin server revision, framing and version negotiation.
2. `ultimate-odycer-feedback#6` — establish the canonical Zig ↔ Three.js proof fixture.
3. `ultimate-odycer-feedback#7` — build the Godot/OpenXR adapter against the same contract and prove auth, handoff, movement, reconnect and VR intents.
4. `ultimate-odycer-feedback#8` — prove forged poses/actions, malformed frames, replay and abuse remain fail-closed.
5. Headset evidence is recorded only after the protocol fixture passes.

## License boundary

This public Godot/OpenXR starter contains only material explicitly released under its public license and compatible dependencies. Canonical/private Ultimate Odycer server code, proprietary gameplay implementation, production configuration, private assets/lore and commercial components are not part of this repository and remain proprietary/commercial, all rights reserved unless explicitly licensed otherwise. Access to a private repository does not authorize copying or redistribution. Public integration should be independently implemented from approved public contracts and synthetic fixtures; any extraction proposal requires file-level provenance and license review.

No waiting gate implies implementation or compatibility.
