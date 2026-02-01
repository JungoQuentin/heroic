class_name StoryNodeAction extends StoryNode

var actionTitle: String
var action: Action

func _to_string() -> String:
	return actionTitle

func _init(_action: Action) -> void:
	action = _action
