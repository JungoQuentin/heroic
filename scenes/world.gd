class_name World extends Node3D


func open_curtains() -> void:
	$Theater/rideau_droite.open()
	$Theater/rideau_gauche.open()

func close_curtains() -> void:
	$Theater/rideau_droite.close()
	$Theater/rideau_gauche.close()
