class_name Ui extends CanvasLayer

signal _choices_made

var _choice: StoryNode


func _ready() -> void:
	$ChoicesContainer.hide()


func display_choices(choices: Dictionary[String, StoryNode]) -> StoryNode:
	$ChoicesContainer.show()
	for button: Button in $ChoicesContainer.get_children():
		button.hide()
		disconnect_all(button.pressed)
	var i = 0
	for choice in choices:
		var button = $ChoicesContainer.get_child(i)
		button.show()
		button.text = choice
		button.pressed.connect(
			func():
				_choice = choices[choice]
				_choices_made.emit()
				$ChoicesContainer.hide()
		)
		i += 1
	await _choices_made
	assert(_choice != null, "should have a choice")
	return _choice

func disconnect_all(sig:Signal):
	for dict in sig.get_connections():
		sig.disconnect(dict.callable)
