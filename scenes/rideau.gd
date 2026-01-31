extends Node3D

@export var is_right: bool = true

const ANIM_TIME:= 1.3

func open() -> void:
	# TODO -> transaltion exterieur
	var tween = get_tree().create_tween()
	if is_right:
		tween.tween_property($rideau_droite, "blend_shapes/Rideau_Blenshape1.rideau_droite_ferme", 0., ANIM_TIME)
	else:
		tween.tween_property($rideau_gauche, "blend_shapes/Rideau_Blenshape.rideau_gauche_ferme", 0., ANIM_TIME)

func close() -> void:
	var tween = get_tree().create_tween()
	if is_right:
		tween.tween_property($rideau_droite, "blend_shapes/Rideau_Blenshape1.rideau_droite_ferme", 1., ANIM_TIME)
	else:
		tween.tween_property($rideau_gauche, "blend_shapes/Rideau_Blenshape.rideau_gauche_ferme", 1., ANIM_TIME)
