class_name Main extends Node3D

@onready var ui: Ui = $Ui
@onready var world: BWorld = $World
@onready var dialog_stream_player: AudioStreamPlayer = $DialogAudioStreamPlayer


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
		ui.display_choices(current_story.choices, start_story)
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
	else:
		assert(false, "it should be an Action type !")


func poses_loop(
	poses_times: Dictionary[float, CompressedTexture2D], 
	started_since: int
) -> void:
	if poses_times.is_empty():
		return
	var elapsed = Time.get_ticks_msec() - started_since
	var first = poses_times.keys().min()
	if first * 1000 < elapsed:
		#$"../Sprite3D".texture = poses_times[first]
		poses_times.erase(first)
	await get_tree().create_timer(0.1).timeout
	poses_loop(poses_times, started_since)
