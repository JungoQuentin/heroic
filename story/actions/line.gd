## Une replique
class_name Line extends Action

@export var audio: AudioStream
@export var poses_times: Dictionary[float, CompressedTexture2D]

func _init(_audio: AudioStream, _poses: Dictionary[float, CompressedTexture2D]):
	audio = _audio
	poses_times = _poses
