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
	# 0-01
	action(line(preload("res://audio/voices/0-01-ofatalite.wav"))),
	# 0-02
	choice({
		"Ouvrir les rideaux": action(Action.CurtainsOpening.new())
	}),
	# 0-03
	# 0-04
	action(line(preload("res://audio/voices/0-02-levillabominable.wav"))),
	# 0-05
	action(line(preload("res://audio/voices/0-03-adresseparole.wav"))),
	# 0-06
	action(line(preload("res://audio/voices/public-03-oh.wav"))),
	# 0-07
	action(line(preload("res://audio/voices/0-04-monroleproteger.wav"))),
	# 0-08
	action(line(preload("res://audio/voices/0-05-odieuxdonnezmoirage.wav"))),
	# 0-09
	action(line(preload("res://audio/voices/0-06-allonsy.wav"))),
	# 0-10
	action(Action.CurtainsClosing.new()),
	# 0-11
	action(line(preload("res://audio/voices/public-03-oh.wav"))),
])
