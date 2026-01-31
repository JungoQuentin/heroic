class_name StoryNodeChoice extends StoryNode

var choices: Dictionary[String, StoryNode]

func _init(_choices: Dictionary[String, StoryNode]) -> void:
	self.choices = _choices

func _to_string() -> String:
	return ", ".join(self.choices.values())
