extends Control

signal retry_game
signal back_to_menu

var selected_drink: String = ""

func _ready():
	%RetryButton.pressed.connect(_on_retry_button_pressed)
	%BackToMenuButton.pressed.connect(_on_back_to_menu_button_pressed)
	
	# Set up touch support
	%RetryButton.mouse_filter = Control.MOUSE_FILTER_PASS
	%BackToMenuButton.mouse_filter = Control.MOUSE_FILTER_PASS

func set_result(dice1_result: int, dice2_result: int, drink_name: String):
	selected_drink = drink_name
	
	var total = dice1_result + dice2_result
	var service_type = _determine_service_type(dice1_result, dice2_result)
	
	# Update display content
	%DiceResult.text = tr("DICE_RESULT") + ": %d + %d = %d" % [dice1_result, dice2_result, total]
	%ServiceResult.text = tr("SERVICE_RESULT") + ": " + service_type
	%OrderConfirmation.text = drink_name # tr("ORDER_CONFIRMATION") % drink_name

func _determine_service_type(dice1: int, dice2: int) -> String:
	var total = dice1 + dice2
	
	# Same dice (ゾロ目)
	if dice1 == dice2:
		return tr("FREE_DRINK")
	
	# Odd total
	if total % 2 == 1:
		return tr("MEGA_SIZE")
	
	# Even total
	return tr("HALF_PRICE")

func _on_retry_button_pressed():
	retry_game.emit()

func _on_back_to_menu_button_pressed():
	back_to_menu.emit()

func _update_ui_text():
	%Title.text = tr("RESULT_TITLE")
	%RetryButton.text = tr("RETRY_BUTTON")
	%BackToMenuButton.text = tr("BACK_TO_MENU") 
