class_name Main extends Node3D

@onready var ui: Ui = $Ui
@onready var world: BWorld = $World
@onready var dialog_stream_player: AudioStreamPlayer = $DialogAudioStreamPlayer
@onready var music_stream_player: AudioStreamPlayer = $MusicAudioStreamPlayer
@onready var sfx_stream_player: AudioStreamPlayer = $SfxAudioStreamPlayer
@onready var b_container: Node3D = $Characters/B
@onready var j_container: Node3D = $Characters/J

const stages: Dictionary[String, PackedScene] = {
	"intro": preload("res://scenes/stages/stage_intro.tscn"),
	"armurerie": preload("res://scenes/stages/stage_armurerie.tscn"),
	"fontaine": preload("res://scenes/stages/stage_fontaine.tscn"),
}

const b: Dictionary[String, PackedScene] = {
	"enerve_01": preload("res://assets/3D/Personnages/Bartholome/enerve_01.tscn"),
	"enerve_02": preload("res://assets/3D/Personnages/Bartholome/enerve_02.tscn"),
	"flex_01": preload("res://assets/3D/Personnages/Bartholome/flex_01.tscn"),
	"flex_02": preload("res://assets/3D/Personnages/Bartholome/flex_02.tscn"),
	"flex_03": preload("res://assets/3D/Personnages/Bartholome/flex_03.tscn"),
	"suspicious": preload("res://assets/3D/Personnages/Bartholome/suspicious.tscn"),
	"cri": preload("res://assets/3D/Personnages/Bartholome/cri.tscn"),
	"monture_01": preload("res://assets/3D/Personnages/Bartholome/monture_01.tscn"),
}

const j: Dictionary[String, PackedScene] = {
	"blaze_01": preload("res://assets/3D/Personnages/jorge/blaze_01.tscn"),
	"blaze_02": preload("res://assets/3D/Personnages/jorge/blaze_02.tscn"),
	"enerve_01": preload("res://assets/3D/Personnages/jorge/enerve_01.tscn"),
	"combat_01": preload("res://assets/3D/Personnages/jorge/combat_01.tscn"),
}

func _ready() -> void:
	for bart in b.keys():
		var n: Node3D = b[bart].instantiate()
		b_container.add_child(n)
		n.hide()
		n.rotation.y = deg_to_rad(-90.)
		n.name = bart
	for jorge in j.keys():
		var n: Node3D = j[jorge].instantiate()
		j_container.add_child(n)
		n.hide()
		n.rotation.y = deg_to_rad(-90.)
		n.name = jorge
	start_story(Timeline.new().story)


func start_story(current_story: StoryNode) -> void:
	print(current_story)
	if current_story is StoryNodeList:
		for action in current_story.list:
			print(action)
			await start_story(action)
	elif current_story is StoryNodeAction:
		await execute_action(current_story.action)
	elif current_story is StoryNodeChoice:
		var choice = await ui.display_choices(current_story.choices)
		await start_story(choice)
	else: # is null
		pass # THE END



func execute_action(action: Action) -> void:
	print("launch: ", action)
	if action is Line:
		dialog_stream_player.stream = action.audio
		dialog_stream_player.play()
		poses_loop(action.qui, action.poses_times, Time.get_ticks_msec())
		await dialog_stream_player.finished
	elif action is Action.CurtainsClosing:
		await world.close_curtains()
	elif action is Action.CurtainsOpening:
		await world.open_curtains()
	elif action is Action.SceneChange:
		handle_scene_change(action)
	elif action is Action.Wait:
		await get_tree().create_timer(action.time).timeout
	elif action is Action.TurnOffLight:
		get_node('stage/Scene_Lights').hide()
	elif action is Action.TurnOnLight:
		get_node('stage/Scene_Lights').show()
	elif action is Action.PaysanCiao:
		if get_node_or_null('stage/paysans') != null:
			get_node('stage/paysans').hide()
	elif action is Action.JorgeHide:
		j_container.get_children().map(func(n): n.hide())
	elif action is Action.JorgeShow:
		j_container.get_node("blaze_01").show()
	elif action is Action.Sfx:
		await handle_sfx(action)
	elif action is Action.Music:
		handle_music(action)
	#else:
		#assert(false, "it should be an Action type !")


func poses_loop(
	qui: String,
	poses_times: Dictionary[float, Line.Pose], # TODO way to know the char ! for Jorge
	started_since: int
) -> void:
	if poses_times.is_empty():
		return
	var elapsed = Time.get_ticks_msec() - started_since
	var first = poses_times.keys().min()
	if first * 1000 < elapsed:
		var container: Node3D = null
		match qui:
			'p': pass
			'o': pass
			'b':
				container = b_container
			'j':
				container = j_container
		if container != null:
			var pose: Line.Pose = poses_times[first]
			container.get_children().map(func(c): c.hide())
			var character: Node3D = container.get_node(pose.pose_name)
			character.show()
			# TODO changer sa position # if pose.position_x != -1:
			poses_times.erase(first)
	await get_tree().create_timer(0.07).timeout
	poses_loop(qui, poses_times, started_since)

#region sfx
var sfx_tween: Tween
func handle_sfx(action: Action.Sfx) -> void:
	if music_tween != null:
		music_tween.stop()
		await get_tree().create_timer(0.1).timeout
	sfx_stream_player.stream = action.stream
	sfx_stream_player.play()
	if action.time > 0.:
		await get_tree().create_timer(action.time - 1.).timeout
		sfx_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
		sfx_tween.tween_property(sfx_stream_player, "volume_db", -80., 1.5)
		await sfx_tween.finished
	else:
		await sfx_stream_player.finished
#endregion

#region music
const default_music_db := -16.0
var music_tween: Tween

func handle_music(music: Action.Music) -> void:
	match music.action:
		Action.MusicAction.ON:
			if music_tween != null:
				music_tween.stop()
			music_stream_player.stream = music.music
			music_stream_player.volume_db = default_music_db
			music_stream_player.play()
		Action.MusicAction.STOP:
			music_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
			music_tween.tween_property(music_stream_player, "volume_db", -80., 3.)
		Action.MusicAction.PAUSE:
			music_stream_player.stop() # TODO pause ?


func handle_scene_change(action: Action.SceneChange) -> void:
	var current_stage = get_node_or_null('stage')
	if current_stage != null:
		current_stage.queue_free()
	var stage: Node3D = stages[action.scene_name].instantiate()
	add_child(stage)
	stage.set_deferred('name', 'stage')

	# le B
	var b_start = stage.get_node('B_Start')
	b_container.get_children().map(func(c): c.hide())
	b_container.get_children().map(func(c): c.position = b_start.position)
	b_container.get_node("flex_01").show()
	b_start.queue_free()

	# le J
	var j_start = stage.get_node_or_null('J_Start')
	if j_start:
		j_container.get_children().map(func(c): c.hide())
		j_container.get_children().map(func(c): c.position = j_start.position)
		j_container.get_node("blaze_01").show()
		j_start.queue_free()
