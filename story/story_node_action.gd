class_name StoryNodeAction extends StoryNode

@export var actionTitle: String
@export var action: Action
#@export var next: StoryNode

func _to_string() -> String:
	return actionTitle

func _init(_action: Action) -> void:
	action = _action
	#next = _next
