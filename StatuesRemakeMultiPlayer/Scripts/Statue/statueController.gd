extends CharacterBody3D

#Okay so assume max four player, min one. 
#Global script has array that has each player name.

@onready var playersNode = $"../../Players"

var closestPlayerDis = 1000
var closestPlayer : int

var range = 100
var withinRange : bool


func _ready():
	pass

func _physics_process(delta):
	withinRange = false
	
	for player in GlobalScript.players:
		var p = playersNode.get_node(str(player))
		var d = global_position.distance_to(p.global_position)
			
		if d < range:
			withinRange = true
			print("range")
	
	
	if !withinRange:
		await get_tree().create_timer(0.05).timeout
		if withinRange:
			FindClosestPlayer()
	
func FindClosestPlayer():
	closestPlayer = 0
	closestPlayerDis = 100
	
	for player in GlobalScript.players:
		var p = playersNode.get_node(str(player))
		var d = global_position.distance_to(p.global_position)
		
		if d < closestPlayerDis:
			closestPlayerDis = d
			closestPlayer = p.name.to_int()
			
		print(closestPlayer)
