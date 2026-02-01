## Une replique
class_name Line extends Action

var audio: AudioStream
var poses_times: Dictionary[float, Pose]
var qui: String # b ou j ou p(ublic) ou o(ff)

func _init(_qui: String, _audio: AudioStream, _poses: Dictionary[float, Pose]):
	qui = _qui
	audio = _audio
	poses_times = _poses
	#assert(qui == 'b' or qui == 'j' or qui == 'p' or qui == 'o', "must be in b/j/p/o")


class Pose:
	var pose_name: String 
	var position_x: float # TODO seulement sur cet axe ?
	func _init(
		_pose: String,
		_position_x: float = -1.,
	) -> void:
		position_x = _position_x
		pose_name = _pose
