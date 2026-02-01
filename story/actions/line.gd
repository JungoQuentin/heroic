## Une replique
class_name Line extends Action

var audio: AudioStream
var poses_times: Dictionary[float, Pose]

func _init(_audio: AudioStream, _poses: Dictionary[float, Pose]):
	audio = _audio
	poses_times = _poses


class Pose:
	var pose_name: String 
	var position_x: float # TODO seulement sur cet axe ?
	func _init(
		_pose: String,
		_position_x: float = -1.,
	) -> void:
		position_x = _position_x
		pose_name = _pose
