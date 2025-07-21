extends Control

signal start_game
signal show_rules

@export var title: Label
@export var start_button: Button
@export var rules_button: Button
@export var language_button: Button

var language_index = 0
var languages = ["ja", "zh", "en"]
var game_manager: Node

func _ready():
	# Connect button signals
	rules_button.pressed.connect(_on_rules_button_pressed)
	start_button.pressed.connect(_on_start_button_pressed)
	language_button.pressed.connect(_on_language_button_pressed)
	
	# Set up touch support
	rules_button.mouse_filter = Control.MOUSE_FILTER_PASS
	start_button.mouse_filter = Control.MOUSE_FILTER_PASS
	language_button.mouse_filter = Control.MOUSE_FILTER_PASS
	
	# Get GameManager reference
	game_manager = get_parent()
	
	# Initialize language
	_update_ui_text()
	
	# Set initial language index
	var current_language = TranslationServer.get_locale().split("_")[0] 
	language_index = languages.find(current_language)

func _on_rules_button_pressed():
	show_rules.emit()

func _on_start_button_pressed():
	start_game.emit()

func _on_language_button_pressed():
	# Switch to next language
	language_index = (language_index + 1) % languages.size()
	var new_language = languages[language_index]
	TranslationServer.set_locale(new_language)
	
	# Update UI text
	_update_ui_text()
	
	# Notify GameManager to update other scenes' UI
	if game_manager and game_manager.has_method("update_current_scene_ui"):
		game_manager.update_current_scene_ui()

func _update_ui_text():
	title.text = tr("GAME_TITLE")
	rules_button.text = tr("RULES_BUTTON")
	start_button.text = tr("START_BUTTON")
	
	# Update language button to show current language
	language_button.text = tr("LANGUAGE")
