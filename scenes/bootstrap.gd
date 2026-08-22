# SPDX-License-Identifier: MIT
# Bootstrap controller for isolated VR presentation shell.
extends Node3D

@onready var status_label: Label3D = $StatusLabel

func _ready() -> void:
	var xr_result = OpenXRCapabilityCheck.initialize_openxr_interface()
	var msg = "UltOd VR Client Shell (v0.1.0)
" + str(xr_result.get("details", ""))
	print(msg)
	if status_label:
		status_label.text = msg
