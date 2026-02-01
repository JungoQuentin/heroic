@abstract class_name Action

class CurtainsOpening extends Action:pass

class CurtainsClosing extends Action:pass

class TurnOffLight extends Action:pass

class TurnOnLight extends Action:pass

class JorgeHide extends Action:pass

class JorgeShow extends Action:pass

class PaysanCiao extends Action:pass

class Sfx extends Action:
	var stream: AudioStream
	var time: float
	func _init(s, t = -1.) -> void:
		stream = s
		time = t

class SceneChange extends Action:
	var scene_name: String
	func _init(_scene: String):
		scene_name = _scene

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
