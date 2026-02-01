class_name StoryNodeChoice extends StoryNode

@export var choicesTitle: String
@export var choices: Dictionary[String, StoryNode]

func _init(_choices: Dictionary[String, StoryNode]) -> void:
	choices = _choices
	assert(!choices.is_empty(), "should have choices")
	assert(choices.values().all(func(v): return v != null), "choices should all be set")

func _to_string() -> String:
	return ", ".join(self.choices.values())
