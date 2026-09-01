# SPDX-License-Identifier: MIT
class_name IntentContract
extends RefCounted

# Public client-side intent envelope only. This file does not implement transport
# and does not prove compatibility with the private canonical Zig server.

const MAX_TEXT_BYTES := 512
const MAX_TARGET_ID_BYTES := 128
const MAX_SESSION_TOKEN_BYTES := 4096
const MAX_MOVE_COMPONENT := 1.0

const ALLOWED_KINDS := {
	"session": true,
	"move": true,
	"interact": true,
	"talk": true,
}

const FORBIDDEN_AUTHORITY_KEYS := {
	"damage": true,
	"heal": true,
	"currency": true,
	"gold": true,
	"inventory": true,
	"item_grant": true,
	"permission": true,
	"role": true,
	"teleport": true,
	"server_position": true,
	"quest_reward": true,
}

static func validate(intent: Dictionary) -> Dictionary:
	if not intent.has("kind") or not (intent["kind"] is String):
		return _reject("missing_or_invalid_kind")

	var kind := String(intent["kind"])
	if not ALLOWED_KINDS.has(kind):
		return _reject("unsupported_kind")

	if _contains_forbidden_authority(intent):
		return _reject("client_authority_field_forbidden")

	match kind:
		"session":
			return _validate_session(intent)
		"move":
			return _validate_move(intent)
		"interact":
			return _validate_interact(intent)
		"talk":
			return _validate_talk(intent)
		_:
			return _reject("unsupported_kind")

static func _validate_session(intent: Dictionary) -> Dictionary:
	var action := intent.get("action", "")
	if not (action is String) or action not in ["hello", "authenticate", "resume"]:
		return _reject("invalid_session_action")

	var token := intent.get("token", "")
	if action != "hello":
		if not (token is String) or token.is_empty() or token.to_utf8_buffer().size() > MAX_SESSION_TOKEN_BYTES:
			return _reject("invalid_session_token")

	return _accept({"kind": "session", "action": action, "token": token})

static func _validate_move(intent: Dictionary) -> Dictionary:
	var x := intent.get("x", null)
	var y := intent.get("y", null)
	if not _is_finite_number(x) or not _is_finite_number(y):
		return _reject("invalid_move_vector")

	var vx := clampf(float(x), -MAX_MOVE_COMPONENT, MAX_MOVE_COMPONENT)
	var vy := clampf(float(y), -MAX_MOVE_COMPONENT, MAX_MOVE_COMPONENT)
	return _accept({"kind": "move", "x": vx, "y": vy})

static func _validate_interact(intent: Dictionary) -> Dictionary:
	var target_id := intent.get("target_id", "")
	if not _valid_bounded_string(target_id, MAX_TARGET_ID_BYTES):
		return _reject("invalid_target_id")
	return _accept({"kind": "interact", "target_id": target_id})

static func _validate_talk(intent: Dictionary) -> Dictionary:
	var text := intent.get("text", "")
	if not _valid_bounded_string(text, MAX_TEXT_BYTES):
		return _reject("invalid_text")

	var target_id := intent.get("target_id", "")
	if not target_id.is_empty() and not _valid_bounded_string(target_id, MAX_TARGET_ID_BYTES):
		return _reject("invalid_target_id")

	return _accept({"kind": "talk", "text": text, "target_id": target_id})

static func _contains_forbidden_authority(value: Variant) -> bool:
	if value is Dictionary:
		for key in value.keys():
			if FORBIDDEN_AUTHORITY_KEYS.has(String(key)):
				return true
			if _contains_forbidden_authority(value[key]):
				return true
	elif value is Array:
		for child in value:
			if _contains_forbidden_authority(child):
				return true
	return false

static func _valid_bounded_string(value: Variant, max_bytes: int) -> bool:
	return value is String and not value.is_empty() and value.to_utf8_buffer().size() <= max_bytes

static func _is_finite_number(value: Variant) -> bool:
	if not (value is int or value is float):
		return false
	return is_finite(float(value))

static func _accept(sanitized: Dictionary) -> Dictionary:
	return {"ok": true, "sanitized": sanitized}

static func _reject(reason: String) -> Dictionary:
	return {"ok": false, "reason": reason}
