class_name BWorld extends Node3D


func open_curtains() -> void:
	$Theater/rideau_droite.open()
	await $Theater/rideau_gauche.open()

func close_curtains() -> void:
	$Theater/rideau_droite.close()
	await $Theater/rideau_gauche.close()
