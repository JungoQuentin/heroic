class_name Timeline

const MIntro = preload("res://audio/music/intro-v1.mp3")
const MBoss = preload("res://audio/music/boss-v1.mp3")
const MShop = preload("res://audio/music/shop-v1.mp3")

func choice(_choices: Dictionary[String, StoryNode]) -> StoryNodeChoice:
	return StoryNodeChoice.new(_choices)

func action(_action: Action) -> StoryNodeAction:
	return StoryNodeAction.new(_action)

func line(_audio: Resource, _poses: Dictionary[float, Line.Pose] = {}) -> Line:
	return Line.new(_audio, _poses)

func list(_list: Array[StoryNode]) -> StoryNodeList:
	return StoryNodeList.new(_list)

var intro = list([
	# TODO(bonus) -> du bruit de foule, puis le silence
	action(Action.Music.new(MIntro)),
	action(Action.Wait.new(4.)),
	# 0-01
	action(line(
		preload("res://audio/voices/0-01-ofatalite.wav"),
		{0.00: Line.Pose.new("flex_03")} 
	)),
	# 0-02
	choice({
		"Ouvrir les rideaux": action(Action.CurtainsOpening.new()),
	}),
	# TODO -> applause !
	# TODO(bonus) -> apparition trop cool
	# 0-03
	# 0-04
	action(line(
		preload("res://audio/voices/0-02-levillabominable.wav"), {
			0.00: Line.Pose.new("flex_03"),
			1.08: Line.Pose.new("flex_01"),
			3.30: Line.Pose.new("flex_02"),
		}
	)),
	# 0-05
	action(line(
		preload("res://audio/voices/0-03-adresseparole.wav"), {
			0.00: Line.Pose.new("flex_03"),
			1.01: Line.Pose.new("flex_02"),
		}
	)),
	# TODO mettre un cri ? "cri"
	# 0-06
	action(line(preload("res://audio/voices/public-03-oh.wav"))),
	# 0-07
	action(line(
		preload("res://audio/voices/0-04-monroleproteger.wav"), {
			0.00: Line.Pose.new("flex_03"),
			4.44: Line.Pose.new("flex_01"),
		}
	)),
	# 0-08
	action(line(
		preload("res://audio/voices/0-05-odieuxdonnezmoirage.wav"), {
			0.00: Line.Pose.new("flex_03"),
			3.40: Line.Pose.new("enerve_01"),
		}
	)),
	action(Action.Wait.new(1.)),
	# 0-09
	action(line(
		preload("res://audio/voices/0-06-allonsy.wav"), { 
			0: Line.Pose.new("flex_03") 
		}
	)),
	# 0-10
	action(Action.CurtainsClosing.new()),
	# 0-11
	action(line(preload("res://audio/voices/public-03-oh.wav"))),
	
	action(Action.Music.new(MIntro, Action.MusicAction.STOP)),
	
	# TODO applause
	action(Action.Wait.new(4.)),
])

#region ARMOR PLACE

var armor_place = list([
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
		"Nous rencontrons un manque de budget": armor_place_without_budget,
		"Lumiere": armor_place_light_on_public,
	}),
])

var sword_vs_brosse: Dictionary[String, StoryNode] = {
	"Epee": list([]),
	"Brosse": list([]),
}

var armor_place_with_jorge = list([
	# 2-A-1 TODO Jorge arrive
	# 2-A-2
	action(line(preload("res://audio/voices/2a-01-j-monseigneurpermettezmoi.wav"))),
	# 2-A-3
	choice(sword_vs_brosse.merged({
		"Le jumeau de Jorge": list([]),
	})),
	# 2-A-7
	action(line(preload("res://audio/voices/2a-02-mevoilapret.wav"))),
	# 2-A-8 
	action(line(preload("res://audio/voices/2a-03-j-sibongout.wav"))),
	# 2-A-9 
	action(line(preload("res://audio/voices/2a-04-enroutecheval.wav"))),
	# 2-A-10 TODO - Jorge se met à 4 pattes, et le héros monte sur son dos pour partir
])

var armor_place_without_budget = list([
	# TODO garder l'info *-> en fait Jorge jouerai le méchant -> on le reconnaitra*
	# 2-B-1
	action(line(preload("res://audio/voices/voixoff-01-nomonture.wav"))),
	# 2-B-2
	action(line(preload("res://audio/voices/b-tousse.wav"))),
	# 2-B-3 TODO B est énervé de cette situation
	# 2-A-3
	choice(sword_vs_brosse),
	# 2-B-4 TODO Et au lieu de monter sur son dos, juste il part
])

var armor_place_light_on_public = list([
	# 2-C-1 TODO moment de silence
	# 2-C-2
	action(line(preload("res://audio/voices/b-tousse.wav"))),
	# 2-C-3 TODO travalto confused -> est confused, puis par du public
	# 2-C-4 B:"hem hem", prend son épée et part
])

#endregion

var affrontement = list([
	# 3-1 TODO Un mec arrive en courant pour apporter une missive, contenant le lieu de l'affrontement
	# 3-2 **CHOIX 1** :
	choice({
		"Bord d'une falaise": null,
		"Dans la fontaine du village": null,
		"Bibliotheque": null,
	}),
	# 3-6
	action(Action.CurtainsClosing.new()),
	action(Action.SceneChange.new("TODO")),
	# 3-7
	action(Action.CurtainsOpening.new()),
	# 3-8 TODO Le chevalier noir apparait
	#- si on avait choisi "manque de budget"
		#- 3.5-A-1 Jorge est le chevalier noir
		#- 3.5-A-2 Il rate les premieres repliques...
	#- sinon, 
		#- 3.5-B-1 Jorge vient le dégager et prendre sa place
	# 3-9 TODO Pétage de plomb de Jorge
	# 3-10
	action(line(preload("res://audio/voices/3a-01-j-tondosjorge.wav"))),
	# 3-11 TODO **QTE** moment de noir -> appuyer plein de fois sur espace, devient intense, juste 2 epees qui se rapproche, jusqu'au "chling" de fin (coup d'epee)
	# 3-12 TODO Fondu au blanc - heroic/epic
])

var the_end = list([
	action(line(preload("res://audio/voices/4a-01-barthotriomphe.wav"))),
	action(line(preload("res://audio/voices/voixoff-4a-fin.wav"))),
	# TODO aplause
	# fin
])


var story = list([
	intro,
	armor_place,
	affrontement,
	the_end,
])
