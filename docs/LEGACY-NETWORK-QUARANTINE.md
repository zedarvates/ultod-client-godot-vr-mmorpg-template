# Legacy VR networking quarantine

## Purpose

The historical Ultimate Odycer VR client was coupled to an older Zig server. Its transport, framing, authentication, message identifiers and authority assumptions are therefore **not a compatibility source** for the current public Godot VR starter.

Default classification: `LEGACY_QUARANTINED`.

## Prohibited shortcuts

Do not copy historical networking code into this repository merely because it compiles or appears similar. In particular, do not reuse without review:

- endpoint addresses or port numbers;
- message/opcode identifiers;
- framing and byte ordering assumptions;
- authentication/session token formats;
- realm handoff semantics;
- movement acknowledgement/reconciliation rules;
- reconnect/resume behavior;
- client-side authority assumptions;
- production certificates, keys, secrets, private hostnames or deployment configuration.

## Allowed reuse path

A historical item may be considered only when all of the following are recorded:

1. **Provenance** — exact source repository/path/revision or local historical source identifier.
2. **License boundary** — explicit permission to reuse it in the destination repository; private/commercial code is not automatically eligible for a public MIT repository.
3. **Semantic comparison** — comparison against `network-intent-v1` and the pinned canonical Zig baseline, not against memory or old documentation.
4. **Security review** — confirm the item cannot reintroduce client authority, stale auth, replay, unsafe framing or secret material.
5. **Independent test** — behavior is verified by a current fixture or real-server test.
6. **Classification** — the extracted item is recorded as `LEGACY_REVIEWED` with evidence.

If any item is missing, status remains `LEGACY_QUARANTINED` and it is not reused.

## Inventory template

| Historical item | Source + revision | Intended reuse | License reviewed | Semantics reviewed | Security reviewed | Current test | Status |
|---|---|---|---|---|---|---|---|
| _none approved_ | — | — | — | — | — | — | `LEGACY_QUARANTINED` |

## Canonical replacement path

New VR networking must be derived from:

1. public `network-intent-v1` semantics;
2. exact pinned private canonical Zig server revision;
3. current version negotiation/framing/authentication contract;
4. server-authoritative VR-specific validation rules;
5. synthetic fixture evidence followed by real-server evidence.

## VR-specific server authority

The headset/client may report measured or intended state, but it cannot make authoritative gameplay mutations. The server validates or constrains:

- locomotion and body displacement;
- HMD/controller velocity and acceleration envelopes;
- maximum plausible reach and interaction distance;
- world grab/release ownership and outcome;
- combat hit/damage results;
- item/inventory/economy changes;
- permissions and protected interactions;
- replay/order/rate of pose and action sequences.

Tracking noise and genuine headset/runtime discontinuities must be handled with explicit tolerances and recovery states rather than blindly banning or trusting the client.

## Licensing boundary

The public Godot VR starter remains under its explicit MIT license. Historical/private Ultimate Odycer server/game code is proprietary/commercial, all rights reserved unless explicitly licensed otherwise. Private code, secrets, configuration, assets or lore must not cross into this public repository without an explicit reviewed license/publication decision.
