extends CanvasLayer

var story: Story = preload("res://story_a.tres")

func _ready() -> void:
	print(story.story_node)
	$Label.text = '<the start>'
	$ChoicesContainer.hide()
	await get_tree().create_timer(1.).timeout
	print(story.story_node)
	start_story(story.story_node)


func start_story(current_story: StoryNode) -> void:
	print('enter with, ', current_story)
	$ChoicesContainer.hide()
	
	if current_story is StoryNodeAction:
		$Label.text = current_story.text
		await get_tree().create_timer(2.).timeout
		start_story(current_story.next)
	elif current_story is StoryNodeChoice:
		var i = 0
		for choice in current_story.choices:
			$ChoicesContainer.show()
			$ChoicesContainer.get_child(i).text = choice
			$ChoicesContainer.get_child(i).pressed.connect(func(): start_story(current_story.choices[choice])) 
			i += 1
		return
	else: # is null
		$Label.text = '<the end>'
		return
