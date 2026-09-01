# Network intent contract — public Godot clients

This document defines the public client-side intent boundary shared by the Godot Classic and Godot VR starters.

## Proof scope

`net/intent_contract.gd` is **transport-independent client validation only**.

It does not:
- open a socket;
- encode the private canonical Zig wire protocol;
- prove authentication, shard handoff or reconnect;
- prove server-side authorization;
- prove compatibility with any `zig-server-v2` revision.

Current proof status remains `NOT_PROVEN` for live Zig interoperability.

## Allowed base intent families

- `session`: `hello`, `authenticate`, `resume` envelope only;
- `move`: normalized client movement intent only;
- `interact`: bounded target identifier;
- `talk`: bounded text plus optional target identifier.

VR-specific pose/grab/release intents are intentionally not added yet. They require a separately reviewed reach/pose authority contract so historical legacy networking assumptions are not reintroduced.

## Forbidden client authority

The public client contract rejects authority-like fields including damage/healing, currency/gold, inventory/item grants, permissions/roles, teleport, server position and quest rewards.

This list is defense-in-depth, not a substitute for Zig validation. The server must independently reject unauthorized fields/actions.

## Promotion rule

A future transport adapter may consume the sanitized intent returned by this contract. It must remain a separate layer. No transport implementation may change `zig_compatibility`, OpenXR proof or network proof level to true until exact server/runtime evidence exists.

## Licensing boundary

This public contract is MIT with the starter. Private/historical Zig framing, auth internals, gameplay implementation, production configuration and commercial content remain proprietary/commercial, all rights reserved unless explicitly licensed otherwise.
