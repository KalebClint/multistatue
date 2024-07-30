extends Node3D

@export var playerScene : PackedScene
@onready var players = $Players

func addPlayer(id = 1):
	var player = playerScene.instantiate()
	player.name = str(id)
	players.add_child(player) #WHY DOES THIS BREAK IT
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
	
	players.get_node(str(id)).queue_free()
	await get_tree().create_timer(0.1).timeout
	call_deferred("AddToArray")
	
func AddToArray():
	GlobalScript.players.clear()
	
	for player in players.get_children():
		var player_id = player.name.to_int()  # Assuming the player's name can be converted to an integer
		GlobalScript.players.append(player_id)
		
		print(GlobalScript.players)
	
func _ready():
	if GlobalScript.soloPlayer:
		var player = playerScene.instantiate()
		call_deferred("add_child",player)
