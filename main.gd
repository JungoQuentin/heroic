class_name Main extends Node3D

@onready var ui: Ui = $Ui
@onready var world: BWorld = $World
@onready var dialog_stream_player: AudioStreamPlayer = $DialogAudioStreamPlayer
@onready var music_stream_player: AudioStreamPlayer = $MusicAudioStreamPlayer
@onready var b_container: Node3D = $Characters/B
@onready var j_container: Node3D = $Characters/J

var b: Dictionary[String, PackedScene] = {
	"enerve_01": preload("res://assets/3D/Personnages/Bartholome/enerve_01.tscn"),
	"enerve_02": preload("res://assets/3D/Personnages/Bartholome/enerve_02.tscn"),
	"flex_01": preload("res://assets/3D/Personnages/Bartholome/flex_01.tscn"),
	"flex_02": preload("res://assets/3D/Personnages/Bartholome/flex_02.tscn"),
	"flex_03": preload("res://assets/3D/Personnages/Bartholome/flex_03.tscn"),
	"suspicious": preload("res://assets/3D/Personnages/Bartholome/suspicious.tscn"),
	"cri": preload("res://assets/3D/Personnages/Bartholome/cri.tscn"),
}

var j: Dictionary[String, PackedScene] = {
}

func _ready() -> void:
	for bart in b.keys():
		var n: Node3D = b[bart].instantiate()
		b_container.add_child(n)
		n.hide()
		n.name = bart
	for jorge in j.keys():
		var n: Node3D = j[jorge].instantiate()
		j_container.add_child(n)
		n.hide()
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
		poses_loop(action.poses_times, Time.get_ticks_msec())
		await dialog_stream_player.finished
	elif action is Action.CurtainsClosing:
		await world.close_curtains()
	elif action is Action.CurtainsOpening:
		await world.open_curtains()
	elif action is Action.SceneChange:
		print("changing to scene: ", action.scene) # TODO
	elif action is Action.Wait:
		await get_tree().create_timer(action.time).timeout
	elif action is Action.Music:
		handle_music(action)
	else:
		assert(false, "it should be an Action type !")


func poses_loop(
	poses_times: Dictionary[float, Line.Pose], # TODO way to know the char ! for Jorge
	started_since: int
) -> void:
	if poses_times.is_empty():
		return
	var elapsed = Time.get_ticks_msec() - started_since
	var first = poses_times.keys().min()
	if first * 1000 < elapsed:
		var pose: Line.Pose = poses_times[first]
		b_container.get_children().map(func(c): c.hide())
		var character: Node3D = b_container.get_node(pose.pose_name)
		character.show()
		character.rotation.y = -90.
		character.position = Vector3(4.5, 2, 0)
		# TODO changer sa position # if pose.position_x != -1:
		poses_times.erase(first)
	await get_tree().create_timer(0.1).timeout
	poses_loop(poses_times, started_since)


#region music
const default_music_db := -5.0
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
