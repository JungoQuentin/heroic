class_name Story extends Resource

@export var story: StoryNode

class StoryNodeEnd extends StoryNode: 
	func _to_string() -> String:
		return 'StoryNodeEnd'
