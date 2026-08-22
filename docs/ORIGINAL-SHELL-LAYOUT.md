# Original Shell Layout

Status: planned layout for an original starter. These files are not in the
repository. A matching folder name in a private client is not permission to
copy it here.

```text
ultod-client-godot-vr-mmorpg-template/
  project.godot                      # unpublished original metadata
  scenes/
    bootstrap.tscn                   # platform and quality checks
    player_presentation.tscn         # local view of an authoritative entity
    npc_presentation.tscn            # talk/interact prompts only
    zone_stub.tscn                   # synthetic geometry
    ui_stub.tscn                     # HUD / VR panels
  input/
    openxr_capability_check.gd       # fail closed without a runtime
    comfort_locomotion_stub.gd       # local comfort only
  net/
    intent_contract.md               # documentation map to network-intent-v1
  content/
    pinned_templates.md              # version + SHA-256 only
  tests/
    synthetic_fixtures/              # player_demo_* / npc_demo_*
```

Local physics and OpenXR poses may keep a headset comfortable. They must not
award loot, apply damage, change inventory, or accept a speed hack.

No `net/*.gd` socket implementation is allowed while server compatibility is
blocked. See [SERVER-COMPATIBILITY.md](SERVER-COMPATIBILITY.md) and the public
[network-intent-v1](https://github.com/zedarvates/ultimate-odycer-docs/blob/main/schemas/network-intent-v1.schema.json)
fixture.
