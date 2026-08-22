# Public Extraction Design

Status: `decision` for the extraction method; the Godot/OpenXR shell remains
unpublished. This page is the allowlist and license audit requested by the
roadmap. Accepting it does not publish runtime code and does not claim
server, headset, or production compatibility.

## Decision

Future starter files MUST be original, isolated, and created inside this
repository. Existing Ultimate Odycer client or server files MUST NOT be
copied, renamed, or vendored.

The extraction unit is one file. A directory, scene tree, or Git history is
not an allowlist.

## Source boundary

| Source | Allowed use | Forbidden use |
|---|---|---|
| This repository's documentation | continue and refine | treat docs as a runnable client |
| [ultimate-odycer-docs](https://github.com/zedarvates/ultimate-odycer-docs) public contracts | consume published authority rules and `network-intent-v1` as documentation | invent opcodes or live endpoints |
| [ultod-json-template-registry](https://github.com/zedarvates/ultod-json-template-registry) | pin reviewed snapshots by version and SHA-256 | auto-download at runtime or treat templates as grants |
| Existing Ultimate Odycer Godot client | none | copy, rewrite-in-place, or "clean up" proprietary scenes |
| Zig server, WebAdmin, production configs | none | protocol dumps, binaries, credentials, billing |
| Third-party Godot/OpenXR samples | only permissively licensed, file-audited, attributed originals | unaudited assets, brands, or unknown licenses |

## File-level allowlist for the future original shell

These paths are the only ones a later original shell MAY add. They do not
exist yet. Creating them requires a separate contribution that still passes
[PUBLICATION-CHECKLIST.md](PUBLICATION-CHECKLIST.md).

| Planned path | Purpose | License | Authority |
|---|---|---|---|
| `project.godot` | original Godot project metadata | MIT, this repository | none |
| `scenes/bootstrap.tscn` | engine, platform, and quality checks | MIT, original | none |
| `scenes/player_presentation.tscn` | local presentation of a server entity | MIT, original | presentation only |
| `scenes/npc_presentation.tscn` | interaction prompt presentation | MIT, original | presentation only |
| `scenes/zone_stub.tscn` | synthetic local geometry, no production map | MIT, original | no world grants |
| `scenes/ui_stub.tscn` | HUD / VR panel stub | MIT, original | no economy or inventory truth |
| `input/openxr_capability_check.gd` | OpenXR availability checks | MIT, original | fail closed if runtime missing |
| `input/comfort_locomotion_stub.gd` | comfort-oriented local motion example | MIT, original | discarded if a future server rejects it |
| `net/intent_contract.md` | maps public `network-intent-v1` families to client methods | MIT, documentation | no live socket |
| `content/pinned_templates.md` | records pinned registry versions and SHA-256 | MIT, documentation | templates never grant gold, items, or speed |
| `tests/synthetic_fixtures/` | names like `player_demo_01`, never live ids | MIT, original | synthetic only |

Anything not listed is denied until a new audited row is added.

## Denied classes

- any path from an existing Ultimate Odycer client checkout;
- `.pck`, exported binaries, or prebuilt Godot templates from the private game;
- protocol captures, TLS materials, realm URLs, or player identifiers;
- WebAdmin, billing, moderation, or commercial configuration;
- unaudited GLB/PNG/audio, brand marks, or third-party packs;
- a network client before [SERVER-COMPATIBILITY.md](SERVER-COMPATIBILITY.md)
  leaves the blocked state.

## License audit

- Future original starter files: MIT, as declared in [LICENSE](../LICENSE).
- Documentation already in this repository: remains documentation, not a
  game asset grant.
- JSON registry snapshots: Apache-2.0 in their own repository; pin and
  attribute, do not relicense.
- Godot and OpenXR runtimes: stay outside this repository; document the
  exact versions when a shell is published.
- Ultimate Odycer name, proprietary server, hosted services, and commercial
  components: no license is granted here.

A file without an identified owner and license is denied.

## Acceptance of this gate

This extraction design is accepted when:

1. the allowlist above is reviewed;
2. every planned file has an owner and license;
3. denied classes remain excluded;
4. no proprietary path is listed as "to be cleaned later".

Acceptance still leaves the next gate waiting: an original isolated
Godot/OpenXR shell, created from this allowlist, with no proprietary code.

## Non-claims

This document does not prove that a Godot project exists, that OpenXR runs,
that a headset is supported, or that a server will accept a client. Missing
evidence stays unsupported.
