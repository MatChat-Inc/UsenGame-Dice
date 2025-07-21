extends Node

signal scene_changed(scene_name: String)
signal language_changed

@export var entry_scene: PackedScene
@export var drink_selection_scene: PackedScene
@export var dice_game_scene: PackedScene
@export var result_scene: PackedScene

var current_scene: Node

var selected_drink: String = ""

func _ready():
	# Set initial scene
	_show_entry_scene()

func _show_entry_scene():
	_switch_scene(entry_scene)
	var entry = current_scene
	entry.start_game.connect(_on_start_game)
	entry.show_rules.connect(_on_show_rules)

func _show_drink_selection_scene():
	_switch_scene(drink_selection_scene)
	var drink_selection = current_scene
	drink_selection.drink_selected.connect(_on_drink_selected)
	drink_selection.back_to_menu.connect(_on_back_to_menu)
	# Update UI text
	if drink_selection.has_method("_update_ui_text"):
		drink_selection._update_ui_text()

func _show_dice_game_scene():
	_switch_scene(dice_game_scene)
	var dice_game = current_scene
	dice_game.dice_rolled.connect(_on_dice_rolled)
	dice_game.back_to_drink_selection.connect(_on_back_to_drink_selection)
	# Update UI text
	if dice_game.has_method("_update_ui_text"):
		dice_game._update_ui_text()

func _show_result_scene(dice1_result: int, dice2_result: int):
	_switch_scene(result_scene)
	var result = current_scene
	result.set_result(dice1_result, dice2_result, selected_drink)
	result.retry_game.connect(_on_retry_game)
	result.back_to_menu.connect(_on_back_to_menu)
	# Update UI text
	if result.has_method("_update_ui_text"):
		result._update_ui_text()

func _switch_scene(new_scene: PackedScene):
	if current_scene:
		current_scene.queue_free()
	
	current_scene = new_scene.instantiate()
	add_child(current_scene)
	scene_changed.emit(new_scene.resource_path.get_file().get_basename())

func _on_start_game():
	_show_drink_selection_scene()

func _on_drink_selected(drink_name: String):
	selected_drink = drink_name
	_show_dice_game_scene()

func _on_dice_rolled(dice1_result: int, dice2_result: int):
	_show_result_scene(dice1_result, dice2_result)

func _on_retry_game():
	_show_drink_selection_scene()

func _on_back_to_menu():
	_show_entry_scene()

func _on_back_to_drink_selection():
	_show_drink_selection_scene()

func _on_show_rules():
	# Show rules popup
	_show_rules_popup()

func _show_rules_popup():
	var popup = AcceptDialog.new()
	popup.title = tr("RULES_TITLE")
	popup.dialog_text = tr("RULES_TEXT")
	popup.ok_button_text = tr("OK")
	add_child(popup)
	popup.popup_centered()
	popup.confirmed.connect(popup.queue_free)

# Public method: Update current scene UI text
func update_current_scene_ui():
	if current_scene and current_scene.has_method("_update_ui_text"):
		current_scene._update_ui_text() 
