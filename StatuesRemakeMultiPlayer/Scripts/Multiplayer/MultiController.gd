extends Node3D

var enabled : bool

func _ready():
	enabled = !GlobalScript.soloPlayer
