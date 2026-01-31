class_name Timeline


func choice(_choices: Dictionary[String, StoryNode]) -> StoryNodeChoice:
	return StoryNodeChoice.new(_choices)

func action(_action: Action) -> StoryNodeAction:
	return StoryNodeAction.new(_action)

func line(_audio: Resource) -> Line:
	return Line.new(_audio, {})

var story = StoryNodeList.new([
	# INTRODUCTION
	# Les rideaux sont fermés
	action(line(preload("res://audio/voices/0-01-ofatalite.wav"))),
	choice({
		"Unique": action(line(preload("res://audio/voices/0-06-allonsy.wav"))),
		"Coucou": action(Action.CurtainsOpening.new())
	}),
])
