extends Node3D

@export var is_right: bool = true
@onready var node_path = "rideau_droite" if is_right else "rideau_gauche"
@onready var pros_path = "blend_shapes/Rideau_Blenshape1.rideau_droite_ferme" if is_right else "blend_shapes/Rideau_Blenshape.rideau_gauche_ferme"
@onready var final_pos = 2.5 if is_right else -2.5

const ANIM_TIME:= 1.3

func open() -> void:
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(get_node(node_path), pros_path, 0., ANIM_TIME)
	tween.parallel().tween_property(get_node(node_path), "position", Vector3(0, 0, final_pos), ANIM_TIME)
	await tween.finished

func close() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(get_node(node_path), pros_path, 1., ANIM_TIME)
	tween.parallel().tween_property(get_node(node_path), "position", Vector3(0, 0, 0), ANIM_TIME)
	await tween.finished
