extends CanvasLayer

var story: StoryNode = StoryNodeAction.new(
	"first action !", 
	StoryNodeAction.new(
		"the next action", 
		StoryNodeChoice.new({
			"choix A": StoryNodeAction.new("vous avez choisi A !", Story.StoryNodeEnd.new()),
			"choix B": StoryNodeAction.new("vous avez choisi B !", Story.StoryNodeEnd.new()),
			"finir maintenant !": Story.StoryNodeEnd.new(),
		})
	)
)

func _ready() -> void:
	$Label.text = '<the start>'
	$ChoicesContainer.hide()
	await get_tree().create_timer(1.).timeout
	start_story(story)


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
	elif current_story is Story.StoryNodeEnd:
		$Label.text = '<the end>'
		return
