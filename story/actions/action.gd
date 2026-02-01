@abstract class_name Action

class CurtainsOpening extends Action:pass
class CurtainsClosing extends Action:pass
class SceneChange extends Action:
	var scene
	func _init(_scene):
		scene = _scene
