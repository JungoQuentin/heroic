class_name StoryNodeAction extends StoryNode

@export var text: String
@export var next: StoryNode

#func _init(_text: String, _next: StoryNode) -> void:
	#self.text = _text
	#self.next = _next

func _to_string() -> String:
	return text
