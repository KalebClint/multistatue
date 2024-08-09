extends StaticBody3D


var opened = false

func _ready():
	var rand = randf()
	if rand < 0.49:
		openOrClose()

func openOrClose():
	if opened == true:
		opened = false
		rotate_y(90)
	else:
		opened = true
		rotate_y(-90)
	

func findDisToStat(stat):
	var d = global_position.distance_to(stat.global_position)
	if d < stat.closestStatToDoor:
		stat.closestStatToDoor = d
		stat.closestDoor = self
