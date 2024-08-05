extends Node3D

@onready var room = $".."
var chances : float = 0.08
@export var statue : PackedScene
@onready var statuesNode = $"../../../../Statues"

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(6).timeout
	if room.roomClear:
		room.roomClear = false
		randomize()
		var rand = randf() 
		if rand <=  chances:
			var c = statue.instantiate()
			statuesNode.add_child(c)
			c.global_position = global_position
			c.position.x = c.position.x + randi_range(-7,7)
			c.position.z = c.position.z + randi_range(-7,7)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
