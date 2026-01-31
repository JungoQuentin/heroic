class_name Timeline


func choice(_choices: Dictionary[String, StoryNode]) -> StoryNodeChoice:
	return StoryNodeChoice.new(_choices)

func action(_action: Action) -> StoryNodeAction:
	return StoryNodeAction.new(_action)


var story = StoryNodeList.new([
	action(Line.new(
		preload("res://audio/voices/0-06-allonsy.wav"), 
		{}
	)),
	choice({
		"Unique": action(Line.new(
			preload("res://audio/voices/0-06-allonsy.wav"), 
			{}
		)),
		"Coucou": action(Action.CurtainsOpening.new())
	}),
])
