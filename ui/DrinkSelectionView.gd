extends Control

signal drink_selected(drink_name: String)
signal back_to_menu

@export var scroll_view: ScrollContainer
@export var grid_view: GridContainer
@export var grid_cell: DrinkCell

var selected_drink: String = ""
var drink_cells: Array[DrinkCell] = []

var mock_data: Array[Dictionary] = [
	{
		"name": "Beer",
		"translation_key": "BEER",
		"description": "A refreshing beer",
		"image": "res://assets/images/beer.jpg"
	},
	{
		"name": "Lemon Sour",
		"translation_key": "LEMON_SOUR", 
		"description": "A refreshing lemon sour",
		"image": "res://assets/images/lemon_sour.jpg"
	},
	{
		"name": "Grapefruit Sour",
		"translation_key": "GRAPEFRUIT_SOUR",
		"description": "A refreshing grapefruit sour",
		"image": "res://assets/images/grapefruit_sour.jpg"
	},
	{
		"name": "Beer",
		"translation_key": "BEER",
		"description": "A refreshing beer",
		"image": "res://assets/images/beer.jpg"
	},
	{
		"name": "Lemon Sour",
		"translation_key": "LEMON_SOUR", 
		"description": "A refreshing lemon sour",
		"image": "res://assets/images/lemon_sour.jpg"
	},
	{
		"name": "Grapefruit Sour",
		"translation_key": "GRAPEFRUIT_SOUR",
		"description": "A refreshing grapefruit sour",
		"image": "res://assets/images/grapefruit_sour.jpg"
	},
	{
		"name": "Beer",
		"translation_key": "BEER",
		"description": "A refreshing beer",
		"image": "res://assets/images/beer.jpg"
	},
	{
		"name": "Lemon Sour",
		"translation_key": "LEMON_SOUR", 
		"description": "A refreshing lemon sour",
		"image": "res://assets/images/lemon_sour.jpg"
	},
	{
		"name": "Grapefruit Sour",
		"translation_key": "GRAPEFRUIT_SOUR",
		"description": "A refreshing grapefruit sour",
		"image": "res://assets/images/grapefruit_sour.jpg"
	},
]

func _ready():
	_setup_drink_cells()
	_setup_ui_buttons()
	_update_ui_text()

func _setup_drink_cells():
	# Clear existing cells in grid_view
	for child in grid_view.get_children():
		if child != grid_cell:  # Don't remove the template
			child.queue_free()
	
	drink_cells.clear()
	
	# Hide the template cell
	if grid_cell:
		grid_cell.visible = false
	
	# Generate cells from mock_data using template
	for drink_data in mock_data:
		var cell = _create_drink_cell(drink_data)
		grid_view.add_child(cell)
		drink_cells.append(cell)
		
		# Connect button signal
		cell.button.pressed.connect(_on_drink_button_pressed.bind(cell.button, drink_data))

func _create_drink_cell(drink_data: Dictionary) -> DrinkCell:
	# Duplicate the template cell
	var cell = grid_cell.duplicate() as DrinkCell
	cell.visible = true
	
	# Set button text and properties
	cell.button.text = tr(drink_data.translation_key)
	cell.button.mouse_filter = Control.MOUSE_FILTER_PASS
	
	# Load and set icon if image path exists
	if drink_data.has("image"):
		var texture = load(drink_data.image) as Texture2D
		if texture:
			cell.button.icon = texture
	
	return cell

func _setup_ui_buttons():
	%ConfirmButton.pressed.connect(_on_confirm_button_pressed)
	%BackButton.pressed.connect(_on_back_button_pressed)
	
	# Set up touch support for UI buttons
	%ConfirmButton.mouse_filter = Control.MOUSE_FILTER_PASS
	%BackButton.mouse_filter = Control.MOUSE_FILTER_PASS

func _on_drink_button_pressed(button: Button, drink_data: Dictionary):
	# Reset all button styles
	for cell in drink_cells:
		cell.button.modulate = Color.WHITE
	
	# Highlight selected button
	# button.modulate = Color.YELLOW
	selected_drink = drink_data.name
	
	# Enable confirm button
	%ConfirmButton.disabled = false

func _on_confirm_button_pressed():
	if selected_drink != "":
		drink_selected.emit(selected_drink)

func _on_back_button_pressed():
	back_to_menu.emit()

func _update_ui_text():
	%Title.text = tr("DRINK_SELECTION_TITLE")
	%ConfirmButton.text = tr("CONFIRM")
	%BackButton.text = tr("BACK")
	
	# Update drink cell button texts with translations
	for i in range(drink_cells.size()):
		if i < mock_data.size():
			drink_cells[i].button.text = tr(mock_data[i].translation_key) 
