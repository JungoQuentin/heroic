extends CanvasLayer


func _ready() -> void:
	$Label.text = '<the start>'
	$ChoicesContainer.hide()
	await get_tree().create_timer(1.).timeout
	start_story(Timeline.new().story)


func start_story(current_story: StoryNode) -> void:
	print('enter with, ', current_story)
	$ChoicesContainer.hide()
	
	if current_story is StoryNodeList:
		for action in current_story.list:
			await start_story(action)
	elif current_story is StoryNodeAction:
		await execute_action(current_story.action)
		#start_story(current_story.next)
	elif current_story is StoryNodeChoice:
		var i = 0
		for choice in current_story.choices:
			$ChoicesContainer.show()
			$ChoicesContainer.get_child(i).text = choice
			$ChoicesContainer.get_child(i).pressed.connect(func(): start_story(current_story.choices[choice])) 
			i += 1
		if i == 1: # sorry for the spaghetti
			$ChoicesContainer.get_child(1).hide()
			$ChoicesContainer.get_child(2).hide()
		if i == 2: # sorry for the spaghetti
			$ChoicesContainer.get_child(2).hide()
		return
	else: # is null
		$Label.text = '<the end>'
		return


func execute_action(action: Action) -> void:
	if action is Line:
		$"../AudioStreamPlayer".stream = action.audio
		$"../AudioStreamPlayer".play()
		poses_loop(action.poses_times, Time.get_ticks_msec())
		await $"../AudioStreamPlayer".finished
	elif action is Action.CurtainsClosing:
		pass
	elif action is Action.CurtainsOpening:
		pass
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
		$"../Sprite3D".texture = poses_times[first]
		poses_times.erase(first)
	await get_tree().create_timer(0.1).timeout
	poses_loop(poses_times, started_since)
