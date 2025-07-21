class_name SFX extends Node

## SFX Manager - Static class for playing sound effects
## GDScript version of the C# SFX class

static var _players: Array[AudioStreamPlayer] = []
static var _container: Node
static var _initialized: bool = false

## Static constructor equivalent - initializes the SFX system
static func _static_init() -> void:
	if _initialized:
		return
		
	var scene_tree = Engine.get_main_loop() as SceneTree
	var current_scene = scene_tree.current_scene
	if not current_scene:
		current_scene = scene_tree.root
	
	_container = Node.new()
	_container.name = "SFX Players"
	current_scene.add_child(_container)
	
	# Initialize 8 AudioStreamPlayer instances
	for i in range(8):
		var player = AudioStreamPlayer.new()
		player.name = "SFX Player " + str(i)
		_container.add_child(player)
		_players.append(player)
	
	_initialized = true

## Play an audio stream using an available player
static func play(audio: AudioStream) -> void:
	_static_init()
	
	var player = _get_idle_player()
	player.stream = audio
	player.play()
	
	# Uncomment for debugging
	# print("[SFX] Playing ", audio.resource_path, " by ", player.name)

## Get an idle player or create a new one if all are busy
static func _get_idle_player() -> AudioStreamPlayer:
	# Look for an idle player
	for player in _players:
		if not player.playing:
			return player
	
	# Create a new player if none are available
	var new_player = AudioStreamPlayer.new()
	new_player.name = "SFX Player " + str(_players.size())
	_container.add_child(new_player)
	_players.append(new_player)
	return new_player 