extends Node3D

@onready var pose = $AnimationPlayer

#1Base,2Crouch,3Dab,4UpsideDown,5Stretch,6Folding

func setPose(type):
	if type == 1:
		pose.play("BasePosition")
	elif type == 2:
		pose.play("Crouch")
	elif type == 3:
		pose.play("DabPosition")
	elif type == 4:
		pose.play("UpsideDown")
	elif type == 5:
		pose.play("Stretch")
	elif type == 6:
		pose.play("ArmFeld")
	pose.stop()
