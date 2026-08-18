# UltOd Client Godot VR MMORPG Template

Documentation-only foundation for a future open Godot VR MMORPG client starter.

> **Status:** Code publication blocked. The known VR branch is associated with an older, currently unaligned Zig server version. Existing Ultimate Odycer client or server code must not be imported without a file-level public extraction audit.

## Current repository contents

- Public scope and exclusion rules
- Compatibility gates and roadmap
- MIT license for future original starter material

There is no Godot project, gameplay implementation, network client, asset, server binary, protocol dump, production endpoint or player data in this repository.

## Intended outcome

- OpenXR project setup and capability detection
- VR locomotion and comfort options
- Head and hand pose abstraction
- Server-authoritative login, realm handoff and movement boundaries
- Desktop fallback clearly separated from VR proof

See [SCOPE.md](SCOPE.md), [ROADMAP.md](ROADMAP.md), [server compatibility](docs/SERVER-COMPATIBILITY.md), the [publication checklist](docs/PUBLICATION-CHECKLIST.md), the [JSON registry contract](docs/JSON-TEMPLATE-REGISTRY.md), the [architecture decisions](docs/ARCHITECTURE-DECISIONS.md), the [versioning policy](docs/VERSIONING.md), and [support boundaries](SUPPORT.md).

## Non-claims

Repository creation does not prove server compatibility, production readiness, gameplay completeness, asset rights, platform or headset support, networking security or performance.

## Résumé français

Ce dépôt reste exclusivement documentaire. Aucun code du client VR ou du serveur Zig historique ne doit être copié avant validation du protocole canonique, des droits de publication et des règles d'autorité serveur.

## License boundary

Future original starter material is intended to be MIT licensed. The license does not grant rights to Ultimate Odycer game content, proprietary server code, hosted infrastructure, commercial services or third-party assets.
