class_name Ui extends CanvasLayer


func _ready() -> void:
	$ChoicesContainer.hide()


func display_choices(choices, start_story: Callable) -> void:
	$ChoicesContainer.show()
	for button in $ChoicesContainer.get_children():
		button.hide()
	var i = 0
	for choice in choices:
		var button = $ChoicesContainer.get_child(i)
		button.show()
		button.text = choice
		button.pressed.connect(
			func(): 
				start_story.call(choices[choice])
				$ChoicesContainer.hide()
		)
		i += 1
