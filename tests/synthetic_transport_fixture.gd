# SPDX-License-Identifier: MIT
extends SceneTree

var _failures: Array[String] = []
var _assertions := 0

func _expect(condition: bool, message: String) -> void:
	_assertions += 1
	if not condition:
		_failures.append(message)

func _init() -> void:
	var events: Array[Dictionary] = []
	var transport := SyntheticTransport.new()
	transport.authoritative_event_received.connect(func(event: Dictionary) -> void: events.append(event))

	_expect(transport.proof_level() == "SYNTHETIC_FIXTURE_ONLY", "proof level must stay synthetic")
	_expect(not transport.is_online(), "new transport must start offline")

	var premature := transport.send_intent({"kind": "move", "x": 1.0, "y": 0.0})
	_expect(premature.get("reason") == "transport_not_online", "offline movement must fail closed")

	var started := transport.begin()
	_expect(started.get("ok", false), "synthetic fixture must start")
	_expect(transport.state() == TransportAdapter.State.AUTHENTICATING, "begin must stop at authentication gate")

	var hello_auth := transport.authenticate({"kind": "session", "action": "hello"})
	_expect(hello_auth.get("reason") == "invalid_synthetic_auth_intent", "hello must not authenticate a session")

	var auth := transport.authenticate({"kind": "session", "action": "authenticate", "token": "synthetic_demo_token"})
	_expect(auth.get("ok", false), "bounded synthetic authentication must succeed")
	_expect(transport.is_online(), "accepted authentication must enter online state")
	_expect(events.size() == 1 and events[0].get("kind") == "session", "session acceptance must arrive as fixture event")

	var forbidden := transport.send_intent({
		"kind": "talk",
		"text": "hello",
		"metadata": {"gold": 999},
	})
	_expect(forbidden.get("reason") == "client_authority_field_forbidden", "nested client authority must be rejected")

	var malformed := transport.send_intent({"kind": "move", "x": "fast", "y": 0.0})
	_expect(malformed.get("reason") == "invalid_move_vector", "malformed movement must be rejected")

	var moved := transport.send_intent({"kind": "move", "x": 2.0, "y": -2.0})
	_expect(moved.get("ok", false), "valid movement intent must be accepted by synthetic authority")
	var snapshot := transport.fixture_snapshot()
	var position: Dictionary = snapshot["position"]
	_expect(is_equal_approx(float(position["x"]), 0.25), "movement x must use sanitized/clamped intent")
	_expect(is_equal_approx(float(position["y"]), -0.25), "movement y must use sanitized/clamped intent")
	_expect(events.back().get("kind") == "authoritative_transform", "movement must yield fixture authoritative transform")

	var dropped := transport.simulate_drop()
	_expect(dropped.get("reason") == "synthetic_connection_dropped", "fixture drop must fail explicitly")
	_expect(transport.state() == TransportAdapter.State.FAILED, "drop must enter failed state")
	var after_drop := transport.send_intent({"kind": "move", "x": 0.0, "y": 1.0})
	_expect(after_drop.get("reason") == "transport_not_online", "post-drop intent must fail closed")

	var restarting := transport.begin({"fixture_id": "godot-loopback-v1"})
	_expect(restarting.get("ok", false), "failed fixture must allow deterministic reconnect")
	var resumed := transport.authenticate({"kind": "session", "action": "resume", "token": "synthetic_resume_token"})
	_expect(resumed.get("ok", false), "synthetic resume must return online")
	var resumed_position: Dictionary = transport.fixture_snapshot()["position"]
	_expect(is_equal_approx(float(resumed_position["x"]), 0.25), "resume must preserve fixture authoritative position")
	_expect(is_equal_approx(float(resumed_position["y"]), -0.25), "resume must preserve fixture authoritative position")

	transport.close()
	_expect(transport.state() == TransportAdapter.State.DISCONNECTED, "close must return to disconnected")

	var report := {
		"schema": "uo.godot-synthetic-transport-proof/v1",
		"proof_level": "SYNTHETIC_FIXTURE_ONLY",
		"canonical_zig_compatibility_proven": false,
		"openxr_runtime_proven": false,
		"headset_runtime_proven": false,
		"assertions": _assertions,
		"passed": _failures.is_empty(),
		"failures": _failures,
	}
	print(JSON.stringify(report))
	quit(0 if _failures.is_empty() else 1)
