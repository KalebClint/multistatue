extends Node3D


func _ready():
	spawnChair()
		
var chairChances : float = 0.03
var circleTableChances : float = 0.08
var tableChances : float = 0.13
var brokenChairChances : float = 0.18
var couchChances : float = 0.23
var bedChances : float = 0.28
var deskChances : float = 0.32
var counterChances : float = 0.38
var boxChances : float = 0.43
var bookcaseChances : float = 0.48


var roomType : int
var roomThing : int

#All the different kinds o funriture (:
@export var circleTable : PackedScene
@export var squareTable : PackedScene
@export var couch : PackedScene
@export var bed : PackedScene
@export var chair : PackedScene
@export var brokenChai : PackedScene
@export var desk : PackedScene
@export var counter : PackedScene
@export var boxOne : PackedScene
@export var boxTwo : PackedScene
@export var bookshelf : PackedScene

@onready var room = $"../.."

func setType(type : int, thing : int):
	# 0 = Generic || 1 = hall || 2 = door || 3 =  border || 4 = kitchen || 5 = bedroom || 6 = living
	# 7 = library || 8 = storage || 9 = dungeon || 10 = dining || 11 = garden 
	# 1 edge - 2 free - 3 doorway - 4 hallway
	roomType = type
	roomThing = thing
	
func spawnStuff():
	# Spawn furniture for each room, in order of
	if roomType == 0:
		if spawnChair() == true:
			room.roomClear = false
			return
		elif spawnBrokenChair() == true:
			room.roomClear = false
			return
	elif roomType == 1: #Hall
		if spawnBoxOne() == true:
			room.roomClear = false
			return
		else:
			return
	elif roomType == 4: #Kitchen
		if spawnCounter() == true:
			room.roomClear = false
			return
		elif spawnCircleTable() == true:
			room.roomClear = false
			return
		elif spawnBrokenChair() == true:
			room.roomClear = false
			return
		elif spawnChair() == true:
			room.roomClear = false
			return
		else:
			return
	elif roomType == 5: #Bedroom
		if spawnBed() == true:
			room.roomClear = false
			return
		elif spawnDesk() == true:
			room.roomClear = false
			return
		elif spawnBrokenChair() == true:
			room.roomClear = false
			return
		elif spawnChair() == true:
			room.roomClear = false
			return
		elif spawnCircleTable() == true:
			room.roomClear = false
			return
	elif roomType == 6: # Living Room
		if spawnBrokenChair() == true:
			room.roomClear = false
			return
		elif spawnChair() == true:
			room.roomClear = false
			return
		elif spawnCircleTable() == true:
			room.roomClear = false
			return
		elif spawnCouch() == true:
			room.roomClear = false
			return
		else:
			return
	elif roomType == 7: # Library
		if spawnBookcase() == true:
			room.roomClear = false
			return
		elif spawnBrokenChair() == true:
			room.roomClear = false
			return
		elif spawnChair() == true:
			room.roomClear = false
			return
		elif spawnCircleTable() == true:
			room.roomClear = false
			return
		elif spawnCouch() == true:
			room.roomClear = false
			return
		elif spawnDesk() == true:
			room.roomClear = false
			return
		else:
			return
	elif roomType == 8: # Storage
		if spawnBoxTwo() == true:
			room.roomClear = false
			return
		elif spawnBoxOne() == true:
			room.roomClear = false
			return
		elif spawnChair() == true:
			room.roomClear = false
			return
		else:
			return
	elif roomType == 9: # Dungeon
		if spawnBoxTwo() == true:
			room.roomClear = false
			return
		elif spawnBoxOne() == true:
			room.roomClear = false
			return
		elif spawnBrokenChair() == true:
			room.roomClear = false
			return
		else:
			return
	elif roomType == 10: # dining
		if spawnChair() == true:
			room.roomClear = false
			return
		elif spawnTable() == true:
			room.roomClear = false
			return
		elif spawnCircleTable() == true:
			room.roomClear = false
			return
		else:
			return
	else:
		return
		
func spawnChair():
	randomize()
	var rand = randf() 
	if rand <=  chairChances:
		var c = chair.instantiate()
		add_child(c)
		c.global_position = global_position
		c.position.x = c.position.x + randi_range(-6,6)
		c.position.z = c.position.z + randi_range(-6,6)
		return true
	else:
		return false
		
func spawnCircleTable():
	randomize()
	var rand = randf() 
	if rand <= circleTableChances:
		var c = circleTable.instantiate()
		
		add_child(c)
		c.global_position = global_position
		c.position.x = c.position.x + randi_range(-7,7)
		c.position.z = c.position.z + randi_range(-7,7)
		return true
	else:
		return false
		
func spawnTable():
	if roomThing == 2:
		randomize()
		var rand = randf() 
		if rand <= tableChances:
			var c = squareTable.instantiate()
			
			add_child(c)
			c.global_position = global_position
			c.position.x = c.position.x + randi_range(-7,7)
			c.position.z = c.position.z + randi_range(-7,7)
			return true
	else:
		return false
		
func spawnBrokenChair():
	randomize()
	var rand = randf() 
	if rand <= brokenChairChances:
		var c = brokenChai.instantiate()
		
		add_child(c)
		c.global_position = global_position
		c.position.x = c.position.x + randi_range(-7,7)
		c.position.z = c.position.z + randi_range(-7,7)
		return true
	else:
		return false
		
func spawnCouch():
	randomize()
	var rand = randf() 
	if rand <= couchChances:
		var c = couch.instantiate()
		
		add_child(c)
		c.global_position = global_position
		c.position.x = c.position.x + randi_range(-7,7)
		c.position.z = c.position.z + randi_range(-7,7)
		return true
	else:
		return false
		
func spawnBed():
	if roomThing == 2:
		randomize()
		var rand = randf() 
		if rand <= bedChances:
			var c = bed.instantiate()
			
			add_child(c)
			c.global_position = global_position
			c.position.x = c.position.x + randi_range(-7,7)
			c.position.z = c.position.z + randi_range(-7,7)
			return true
	else:
		return false
		
func spawnDesk():
	randomize()
	var rand = randf() 
	if rand <= deskChances:
		var c = desk.instantiate()
		
		add_child(c)
		c.global_position = global_position
		c.position.x = c.position.x + randi_range(-7,7)
		c.position.z = c.position.z + randi_range(-7,7)
		return true
	else:
		return false
		
func spawnCounter():
	if roomThing == 2:
		randomize()
		var rand = randf() 
		if rand <= counterChances:
			var c = counter.instantiate()
			
			add_child(c)
			c.global_position = global_position
			c.position.x = c.position.x + randi_range(-7,7)
			c.position.z = c.position.z + randi_range(-7,7)
			return true
	else:
		return false
		
func spawnBoxOne():
	randomize()
	var rand = randf() 
	if rand <= boxChances:
		var c = boxOne.instantiate()
		
		add_child(c)
		c.global_position = global_position
		c.position.x = c.position.x + randi_range(-7,7)
		c.position.z = c.position.z + randi_range(-7,7)
		return true
	else:
		return false

func spawnBoxTwo():
	randomize()
	var rand = randf() 
	if rand <= boxChances:
		var c = boxTwo.instantiate()
		
		add_child(c)
		c.global_position = global_position
		c.position.x = c.position.x + randi_range(-7,7)
		c.position.z = c.position.z + randi_range(-7,7)
		return true
	else:
		return false
		
func spawnBookcase():
	if roomType == 2:
		randomize()
		var rand = randf() 
		if rand <= bookcaseChances:
			var c = bookshelf.instantiate()
			
			add_child(c)
			c.global_position = global_position
			#c.position.x = c.position.x + randi_range(-7,7)
			#c.position.z = c.position.z + randi_range(-7,7)
			return true
	else:
		return false
