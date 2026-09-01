# SPDX-License-Identifier: MIT
class_name SyntheticTransport
extends TransportAdapter

# Deterministic test authority for local proof only. This adapter never opens a
# socket and never encodes or claims compatibility with the private Zig server.

const PROOF_LEVEL := "SYNTHETIC_FIXTURE_ONLY"
const FIXTURE_ID := "godot-loopback-v1"
const FIXED_MOVE_STEP := 0.25
const WORLD_LIMIT := 16.0

var _server_seq := 0
var _position := Vector2.ZERO
var _fixture_session_active := false

func proof_level() -> String:
	return PROOF_LEVEL

func begin(configuration: Dictionary = {}) -> Dictionary:
	var previous_state := state()
	if previous_state not in [State.DISCONNECTED, State.FAILED]:
		return {"ok": false, "reason": "invalid_transport_state"}

	for key in configuration.keys():
		if String(key) != "fixture_id":
			return {"ok": false, "reason": "synthetic_configuration_field_forbidden"}
	var requested_fixture := String(configuration.get("fixture_id", FIXTURE_ID))
	if requested_fixture != FIXTURE_ID:
		return {"ok": false, "reason": "unknown_synthetic_fixture"}

	if previous_state == State.DISCONNECTED:
		_position = Vector2.ZERO
		_server_seq = 0
	_fixture_session_active = false
	_set_state(State.CONNECTING)
	_set_state(State.AUTHENTICATING)
	return {"ok": true, "proof_level": PROOF_LEVEL, "fixture_id": FIXTURE_ID}

func authenticate(session_intent: Dictionary) -> Dictionary:
	if state() != State.AUTHENTICATING:
		return {"ok": false, "reason": "transport_not_authenticating"}

	var validated := IntentContract.validate(session_intent)
	if not validated.get("ok", false):
		return validated
	var sanitized: Dictionary = validated["sanitized"]
	if sanitized.get("kind") != "session" or sanitized.get("action") not in ["authenticate", "resume"]:
		return {"ok": false, "reason": "invalid_synthetic_auth_intent"}

	_fixture_session_active = true
	_server_seq += 1
	_set_state(State.ONLINE)
	var event := {
		"source": "synthetic_fixture",
		"kind": "session",
		"status": "accepted",
		"action": sanitized["action"],
		"server_seq": _server_seq,
	}
	_emit_authoritative_event(event)
	return {"ok": true, "proof_level": PROOF_LEVEL, "server_seq": _server_seq}

func send_intent(intent: Dictionary) -> Dictionary:
	var validated := IntentContract.validate(intent)
	if not validated.get("ok", false):
		return validated
	if not is_online() or not _fixture_session_active:
		return {"ok": false, "reason": "transport_not_online"}

	var sanitized: Dictionary = validated["sanitized"]
	var kind := String(sanitized.get("kind", ""))
	if kind == "session":
		return {"ok": false, "reason": "session_intent_not_allowed_online"}

	_server_seq += 1
	var event: Dictionary
	match kind:
		"move":
			_position.x = clampf(_position.x + float(sanitized["x"]) * FIXED_MOVE_STEP, -WORLD_LIMIT, WORLD_LIMIT)
			_position.y = clampf(_position.y + float(sanitized["y"]) * FIXED_MOVE_STEP, -WORLD_LIMIT, WORLD_LIMIT)
			event = {
				"source": "synthetic_fixture",
				"kind": "authoritative_transform",
				"server_seq": _server_seq,
				"position": {"x": _position.x, "y": _position.y},
			}
		"interact":
			event = {
				"source": "synthetic_fixture",
				"kind": "interaction_result",
				"server_seq": _server_seq,
				"target_id": sanitized["target_id"],
				"accepted": true,
			}
		"talk":
			event = {
				"source": "synthetic_fixture",
				"kind": "talk_result",
				"server_seq": _server_seq,
				"target_id": sanitized["target_id"],
				"text_bytes": String(sanitized["text"]).to_utf8_buffer().size(),
				"accepted": true,
			}
		_:
			return {"ok": false, "reason": "unsupported_synthetic_intent"}

	_emit_authoritative_event(event)
	return {"ok": true, "proof_level": PROOF_LEVEL, "server_seq": _server_seq}

func simulate_drop() -> Dictionary:
	if not is_online():
		return {"ok": false, "reason": "transport_not_online"}
	_fixture_session_active = false
	return _fail("synthetic_connection_dropped")

func fixture_snapshot() -> Dictionary:
	return {
		"proof_level": PROOF_LEVEL,
		"state": state(),
		"server_seq": _server_seq,
		"position": {"x": _position.x, "y": _position.y},
	}

func close() -> void:
	_fixture_session_active = false
	_set_state(State.DISCONNECTED)
