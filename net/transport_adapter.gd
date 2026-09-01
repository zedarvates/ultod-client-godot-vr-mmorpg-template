# SPDX-License-Identifier: MIT
class_name TransportAdapter
extends RefCounted

# Abstract public transport lifecycle. No endpoint, socket, framing, opcode or
# historical/private Zig implementation belongs in this file.

signal state_changed(previous: int, current: int)
signal authoritative_event_received(event: Dictionary)
signal transport_error(code: String)

enum State {
	DISCONNECTED,
	CONNECTING,
	AUTHENTICATING,
	ONLINE,
	CLOSING,
	FAILED,
}

var _state: State = State.DISCONNECTED

func state() -> State:
	return _state

func is_online() -> bool:
	return _state == State.ONLINE

func begin(_configuration: Dictionary = {}) -> Dictionary:
	return _unsupported("transport_not_implemented")

func authenticate(_session_intent: Dictionary) -> Dictionary:
	return _unsupported("transport_not_implemented")

func send_intent(intent: Dictionary) -> Dictionary:
	var validated := IntentContract.validate(intent)
	if not validated.get("ok", false):
		return validated
	if not is_online():
		return {"ok": false, "reason": "transport_not_online"}
	return _unsupported("transport_not_implemented")

func close() -> void:
	_set_state(State.DISCONNECTED)

func _set_state(next_state: State) -> void:
	if _state == next_state:
		return
	var previous := _state
	_state = next_state
	state_changed.emit(previous, _state)

func _emit_authoritative_event(event: Dictionary) -> void:
	authoritative_event_received.emit(event)

func _fail(code: String) -> Dictionary:
	_set_state(State.FAILED)
	transport_error.emit(code)
	return {"ok": false, "reason": code}

func _unsupported(reason: String) -> Dictionary:
	return {"ok": false, "reason": reason}
