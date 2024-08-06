extends Node3D

@onready var navMesh = $NavRegion
@onready var pauseScreen = $PauseScreen

var paused = false

@export var playerScene : PackedScene
@onready var playersNode = $Players

func _ready():
	bakeMesh()
	await get_tree().create_timer(5).timeout
	startStoppingDaTorches()
	if GlobalScript.soloPlayer: 
		var player = playerScene.instantiate()
		playersNode.add_child(player)

func _physics_process(delta):
	if Input.is_action_just_pressed("pause"):
		if !paused:
			get_tree().paused = true
			pauseScreen.show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			get_tree().paused = false
			pauseScreen.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func addPlayer(id = 1):
	var player = playerScene.instantiate()
	player.name = str(id)
	playersNode.add_child(player) #WHY DOES THIS BREAK IT
	#call_deferred("add_child",player)
	GlobalScript.players += [id]
	print(GlobalScript.players)
	
func cowardLeave(id):
	multiplayer.peer_disconnected.connect(kickCoward)
	kickCoward(id)
	
func kickCoward(id):
	rpc("_kickCoward",id)
	
@rpc("any_peer","call_local")
func _kickCoward(id):
	# Find the index of the player ID in the array
	
	playersNode.get_node(str(id)).queue_free()
	await get_tree().create_timer(0.1).timeout
	call_deferred("AddToArray")
	
func AddToArray():
	GlobalScript.players.clear()
	
	for player in playersNode.get_children():
		var player_id = player.name.to_int()  # Assuming the player's name can be converted to an integer
		GlobalScript.players.append(player_id)
		
		print(GlobalScript.players)
	# Called when the node enters the scene tree for the first time.

func bakeMesh():
	await get_tree().create_timer(1.75).timeout
	navMesh.bake_navigation_mesh()
		
func startStoppingDaTorches():
	await get_tree().create_timer(5).timeout
	var index = 1
	while index < GlobalScript.numberOfTorches:
		get_tree().call_group("Torch","turnOff",index)
		index += 1
		await get_tree().create_timer(20).timeout
