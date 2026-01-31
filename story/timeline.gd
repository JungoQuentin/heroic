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
		"Ouvrir les rideaux": action(Action.CurtainsOpening.new()),
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
	# next
	armor_place
])

var armor_place = StoryNodeList.new([
	action(Action.SceneChange.new("")),
	action(Action.CurtainsOpening.new()),
	# 1-01 -> TODO Il arrive, il y a pleins de gens sur scene (des paysans)
	# 1-02 -> TODO Il regarde le public, comme s'il s'attendait à ce que le public l'aclame
	# 1-03
	choice({
		"Ils l'acclament": null, # Normal
		"Ils partent": null, # 1-05 -> TODO piss off
		"Ils l'ignorent": null, # 1-06 -> TODO piss off
	}),
	# 1-07
	action(line(preload("res://audio/voices/1-01-assezdevoir.wav"))),
	# 1-08
	action(line(preload("res://audio/voices/1-02-monecuyer.wav"))),
	# 1-09
	choice({
		"Jorge": armor_place_with_jorge,
		"Nous rencontrons un manque de budget": null,
		"Lumiere": null,
	}),
])

var armor_place_with_jorge = StoryNodeList.new([
	# 2-A-1 TODO Jorge arrive
	# 2-A-2
	action(line(preload("res://audio/voices/2a-01-j-monseigneurpermettezmoi.wav"))),
	# 2-A-3
	choice({
		"Epee": null,
		"Brosse": null,
		"Le jumeau de Jorge": null
	})
])
