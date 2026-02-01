@abstract class_name Action

class CurtainsOpening extends Action:pass

class CurtainsClosing extends Action:pass

class SceneChange extends Action:
	var scene
	func _init(_scene):
		scene = _scene

class Wait extends Action:
	var time: float
	func _init(_time: float) -> void:
		time = _time

class Music extends Action:
	var music: AudioStream
	var action: MusicAction
	func _init(_music: AudioStream, _action: MusicAction = MusicAction.ON) -> void:
		music = _music
		action = _action
enum MusicAction {
	ON,
	STOP,
	PAUSE
}
