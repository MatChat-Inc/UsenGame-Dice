@tool
extends EditorPlugin

const BLENDER_LINUX_PATH: String = "/usr/bin/blender"
const BLENDER_MACOS_PATH: String = "/opt/homebrew/bin/blender"

func _enter_tree() -> void:
	# Detect if running from CLI (headless/export/script mode)
	var args := OS.get_cmdline_args()
	print("Command line arguments: ", args)
	if not "--export-release" in args: return  # Skip if running normal editor session
	
	var settings: EditorSettings = EditorInterface.get_editor_settings()

	# Read Blender path from environment variable
	var blender_path := OS.get_environment("BLENDER_PATH")
	if not blender_path.is_empty():
		settings.set_setting("filesystem/import/blender/blender_path", blender_path)
		print("Blender path set from environment variable: ", blender_path)
		return
	else: print("Environment variable BLENDER_PATH not set, using default paths.")
	
	# Set default Blender path based on OS
	if OS.get_name() == "Linux":
		settings.set_setting("filesystem/import/blender/blender_path", BLENDER_LINUX_PATH)
	if OS.get_name() == "macOS":
		settings.set_setting("filesystem/import/blender/blender_path", BLENDER_MACOS_PATH)
		
	print("Blender path set to: ", settings.get_setting("filesystem/import/blender/blender_path"))


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
