# Server Compatibility Gate

## Current decision

**Blocked.** The known VR client branch is tied to an older Zig server version. Its code and assumptions must not be copied into this repository.

## Required evidence before a network layer

- Canonical Zig server version and responsible owner
- Authentication and realm-handoff contract
- Message identifiers, framing, serialization and version negotiation
- Server-authoritative rules for identity, movement, combat and inventory
- Transport security and certificate expectations
- Synthetic loopback fixture with no production endpoint or credential
- Explicit list of deprecated messages and client assumptions
- Compatibility matrix naming the Godot, OpenXR and server versions tested

## Fail-closed rule

Missing, ambiguous or outdated evidence means unsupported, not compatible. An isolated desktop execution does not prove production or VR interoperability.
