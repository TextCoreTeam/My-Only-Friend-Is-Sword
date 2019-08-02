extends CanvasLayer

signal start_game
var start = false

func show_message(text):
	$Label.text = text
	$Label.show()

func _on_Button_pressed():
	start = true
	$Button.hide()
	$Label.hide()
	emit_signal("start_game")
