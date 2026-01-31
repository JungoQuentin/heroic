class_name StoryNodeAction extends StoryNode

@export var actionTitle: String
@export var action: Action
@export var next: StoryNode

func _to_string() -> String:
	return 'node_action' # TODO : action type ?
