extends StaticBody3D

var isItWHYDOINEEDTHISIREALLYSHOULDNTIAMANNOYED = false

func playerPickUp():
	isItWHYDOINEEDTHISIREALLYSHOULDNTIAMANNOYED = false
	GlobalScript.amuletStolen = true
	queue_free()

func _ready():
	if !GlobalScript.amuletSpawned:
		var rand = randf()
		if rand < 0.5:
			GlobalScript.amuletSpawned = true
			isItWHYDOINEEDTHISIREALLYSHOULDNTIAMANNOYED = true
			print("am spawn")
		
	await get_tree().create_timer(2).timeout
	
	if isItWHYDOINEEDTHISIREALLYSHOULDNTIAMANNOYED == false:
		queue_free()
	

