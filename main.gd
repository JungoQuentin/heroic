class_name Main extends Node3D

@onready var ui: Ui = $Ui
@onready var world: BWorld = $World
@onready var dialog_stream_player: AudioStreamPlayer = $DialogAudioStreamPlayer
@onready var characters_container: Node3D = $Characters


func _ready() -> void:
	await get_tree().create_timer(1.).timeout
	start_story(Timeline.new().story)


func start_story(current_story: StoryNode) -> void:
	if current_story is StoryNodeList:
		for action in current_story.list:
			await start_story(action)
	elif current_story is StoryNodeAction:
		await execute_action(current_story.action)
	elif current_story is StoryNodeChoice:
		var choice = await ui.display_choices(current_story.choices)
		await start_story(choice)
	else: # is null
		pass # THE END


func execute_action(action: Action) -> void:
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
	else:
		assert(false, "it should be an Action type !")


var b: Dictionary[String, PackedScene] = {
	"enerve_01": preload("res://assets/3D/personnages/bartholome/enerve_01.tscn"),
	"flex_01": preload("res://assets/3D/personnages/bartholome/flex_01.tscn"),
	"flex_02": preload("res://assets/3D/personnages/bartholome/flex_02.tscn"),
	"flex_03": preload("res://assets/3D/personnages/bartholome/flex_03.tscn"),
}

func poses_loop(
	poses_times: Dictionary[float, Line.Pose], # TODO way to know the char !
	started_since: int
) -> void:
	if poses_times.is_empty():
		return
	var elapsed = Time.get_ticks_msec() - started_since
	var first = poses_times.keys().min()
	if first * 1000 < elapsed:
		var pose: Line.Pose = poses_times[first]
		var character: Node3D= characters_container.get_node_or_null("B")
		if character == null:
			character = b[pose.pose_name].instantiate()
			character.name = "B" # TODO Jorge
			characters_container.add_child(character)
		else:
			# TODO get position de base ?
			character.queue_free()
			
			character = b[pose.pose_name].instantiate()
			character.name = "B" # TODO Jorge
			characters_container.add_child(character)
		# TODO changer sa position
		poses_times.erase(first)
	await get_tree().create_timer(0.1).timeout
	poses_loop(poses_times, started_since)
