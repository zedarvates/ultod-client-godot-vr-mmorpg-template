# SPDX-License-Identifier: MIT
# Comfort-oriented locomotion stub for VR presentation.
# Note: Client-side movement is presentation-only and subject to authoritative server reconciliation.
extends Node
class_name ComfortLocomotionStub

enum LocomotionMode {
	SNAP_TURN,
	SMOOTH_TURN,
	TELEPORT,
	SMOOTH_LOCOMOTION
}

@export var mode: LocomotionMode = LocomotionMode.SNAP_TURN
@export var snap_turn_angle_deg: float = 45.0
@export var max_presentation_speed_m_s: float = 3.5

signal presentation_movement_requested(delta_position: Vector3, new_yaw: float)

func handle_turn_input(turn_axis: float, origin_node: Node3D) -> void:
	if not origin_node:
		return
	if mode == LocomotionMode.SNAP_TURN:
		if abs(turn_axis) > 0.7:
			var direction = 1.0 if turn_axis < 0 else -1.0
			origin_node.rotate_y(deg_to_rad(snap_turn_angle_deg * direction))
	elif mode == LocomotionMode.SMOOTH_TURN:
		origin_node.rotate_y(deg_to_rad(-turn_axis * 90.0 * get_process_delta_time()))

func compute_locomotion_step(move_input: Vector2, head_transform: Transform3D, delta: float) -> Vector3:
	if move_input.length_squared() < 0.01:
		return Vector3.ZERO
	var forward = -head_transform.basis.z
	var right = head_transform.basis.x
	forward.y = 0.0
	right.y = 0.0
	forward = forward.normalized()
	right = right.normalized()
	
	var wish_dir = (forward * move_input.y + right * move_input.x).normalized()
	var step = wish_dir * max_presentation_speed_m_s * delta
	return step
