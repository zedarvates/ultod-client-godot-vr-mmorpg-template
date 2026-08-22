# SPDX-License-Identifier: MIT
# Original OpenXR capability checker for UltOd VR client presentation shell.
extends RefCounted
class_name OpenXRCapabilityCheck

enum CapabilityStatus {
	UNINITIALIZED,
	INITIALIZED,
	FAILED_CLOSED
}

static func initialize_openxr_interface() -> Dictionary:
	var xr_interface: XRInterface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		get_viewport_xr(true)
		return {
			"status": CapabilityStatus.INITIALIZED,
			"interface_name": xr_interface.get_name(),
			"details": "OpenXR interface successfully initialized."
		}
	elif xr_interface:
		if xr_interface.initialize():
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			get_viewport_xr(true)
			return {
				"status": CapabilityStatus.INITIALIZED,
				"interface_name": xr_interface.get_name(),
				"details": "OpenXR interface initialized on demand."
			}
		else:
			return {
				"status": CapabilityStatus.FAILED_CLOSED,
				"interface_name": xr_interface.get_name(),
				"details": "OpenXR interface found but failed initialization. Operating in desktop fallback mode."
			}
	
	return {
		"status": CapabilityStatus.FAILED_CLOSED,
		"interface_name": "None",
		"details": "No OpenXR interface available on this device/runtime."
	}

static func get_viewport_xr(enable: bool) -> void:
	var vp = Engine.get_main_loop()
	if vp and vp is SceneTree and vp.root:
		vp.root.use_xr = enable
