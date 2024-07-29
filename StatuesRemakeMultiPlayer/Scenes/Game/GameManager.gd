extends Node3D

@export var playerScene : PackedScene
@onready var pauseMenu = $PauseMenu

func addPlayer(id = 1):
	var player = playerScene.instantiate()
	player.name = str(id)
	call_deferred("add_child",player)
	
func cowardLeft(id):
	multiplayer.peer_disconnected.connect(kickCoward)
	kickCoward(id)
	
func kickCoward(id):
	rpc("_kickCoward",id)
	
@rpc("any_peer","call_local")
func _kickCoward(id):
	get_node(str(id)).queue_free()
	
func _ready():
	if GlobalScript.soloPlayer:
		var player = playerScene.instantiate()
		call_deferred("add_child",player)
	pauseMenu.hide()
		
func _physics_process(delta):
	if Input.is_action_just_pressed("pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		pauseMenu.show()
		
