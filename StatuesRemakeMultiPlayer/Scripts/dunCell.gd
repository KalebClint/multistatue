extends Node3D

var roomType : int
var roomThing : int # 0 corner - 1 edge - 2 free - 3 doorway - 4 hallway
var spawner = false

@onready var playerSpawner = $PlayerSpawner

@onready var ceiling = $Ceiling
@onready var floor = $Floor

var frontWall : bool = true
var frontDoor : bool = true
var backWall : bool = true
var backDoor : bool = true
var rightWall : bool = true
var rightDoor : bool = true
var leftWall : bool = true
var leftDoor : bool = true

var matWall : Material
var matFloor : Material

var setSpawn : bool = false

var roomClear : bool = true

func _ready():
	frontWall = true
	frontDoor = true
	backWall = true
	backDoor = true
	rightWall= true
	rightDoor = true
	leftWall = true
	leftDoor = true
	
func remove_wall_up():
	$WallFront.free()
	frontWall = false
func remove_wall_down():
	$WallBack.free()
	backWall = false
func remove_wall_left():
	$WallLeft.free()
	leftWall = false
func remove_wall_right():
	$WallRight.free()
	rightWall = false
func remove_door_up():
	$DoorFront.free()
	frontDoor = false
func remove_door_down():
	$DoorBack.free()
	backDoor = false
func remove_door_left():
	$DoorLeft.free()
	leftDoor = false
func remove_door_right():
	$DoorRight.free()
	rightDoor = false
	
func setCellRoomType(type : int):
	# Find the type of room it is from index, eg kitchen, bedroom, etc. Set Textures based on room.
	# 0 = Generic || 1 = hall || 2 = door || 3 =  border || 4 = kitchen || 5 = bedroom || 6 = living
	# 7 = library || 8 = storage || 9 = dungeon || 10 = dining || 11 = garden 
	roomType = type
	setRoomStuff()
	if roomType == 12 && GlobalScript.playerSpawnSet == false: #Spawn
		print("spawner")
		GlobalScript.playerSpawnSet = true
		spawner = true
		
func setRoomStuff():
	
	$Floor/FurntitureSpawner.setType(roomType,roomThing)
	
	if roomType == 0: # Generic
		matFloor = preload("res://Assets/Map/Rooms/CarpetTexture.tres")
		matWall = preload("res://Assets/Map/Rooms/WoodTexture.tres")
	elif roomType == 1: # Hallway
		matFloor = preload("res://Assets/Map/Rooms/CarpetTexture.tres")
		matWall = preload("res://Assets/Map/Rooms/WoodTexture.tres")
	elif roomType == 2: # Door
		matFloor = preload("res://Assets/Map/Rooms/TileTexture.tres")
		matWall = preload("res://Assets/Map/Rooms/WoodTexture.tres")
	elif roomType == 4: # kitchen
		matFloor = preload("res://Assets/Map/Rooms/TileTexture.tres")
		matWall = preload("res://Assets/Map/Rooms/TileTexture.tres")
	elif roomType == 5:# bedroom
		matFloor = preload("res://Assets/Map/Rooms/CarpetTexture.tres")
		matWall = preload("res://Assets/Map/Rooms/WoodTexture.tres")
	elif roomType == 6: # living Room
		matFloor = preload("res://Assets/Map/Rooms/CarpetTexture.tres")
		matWall = preload("res://Assets/Map/Rooms/WoodTexture.tres")
	elif roomType == 7: # library
		matFloor = preload("res://Assets/Map/Rooms/CarpetTexture.tres")
		matWall = preload("res://Assets/Map/Rooms/WoodTexture.tres")
	elif roomType == 8: # storage
		matFloor = preload("res://Assets/Map/Rooms/TileTexture.tres")
		matWall = preload("res://Assets/Map/Rooms/WoodTexture.tres")
	elif roomType == 9: # dungeon
		matFloor = preload("res://Assets/Map/Rooms/BrickTexture.tres")
		matWall = preload("res://Assets/Map/Rooms/BrickTexture.tres")
	elif roomType == 10: # dining room
		matFloor = preload("res://Assets/Map/Rooms/WoodTexture.tres")
		matWall = preload("res://Assets/Map/Rooms/WoodTexture.tres")
	elif roomType == 11: # garden
		matFloor = preload("res://Assets/Map/Rooms/WoodTexture.tres")
		matWall = preload("res://Assets/Map/Rooms/WoodTexture.tres")
	elif roomType == 12: # entrance
		matFloor = preload("res://Assets/Map/Rooms/BrickTexture.tres")
		matWall = preload("res://Assets/Map/Rooms/BrickTexture.tres")
		
	matFloor = preload("res://Assets/Map/Rooms/CarpetTexture.tres")
	matWall = preload("res://Assets/Map/Rooms/BrickTexture.tres")
		
	setCellTextures()
	
func setCellTextures():
	if frontWall:
		$WallFront.material_override = matWall
	if frontDoor:
		$DoorFront.material_override = matWall
		
	if backWall:
		$WallBack.material_override = matWall
	if backDoor:
		$DoorBack.material_override = matWall
		
	if rightWall:
		$WallRight.material_override = matWall
	if rightDoor:
		$DoorRight.material_override = matWall       
		
	if leftWall:
		$WallLeft.material_override = matWall
	if leftDoor:
		$DoorLeft.material_override = matWall
		
	$Floor.material_override = matFloor
	$Ceiling.material_override = matWall
	
func spawnThePlayer():
	if spawner:
		$"../../../Players/Player".global_position = playerSpawner.global_position
	else:
		if playerSpawner != null:
			playerSpawner.free()
