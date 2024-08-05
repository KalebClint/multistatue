extends Node3D

#GUI SCENES
@onready var loadingScreen = $"../../LoadingScreen"

@export var grid_map_path : NodePath
@onready var grid_map : GridMap = get_node(grid_map_path)

@onready var player = $"../../Player"
@onready var navRegion = $".."

var previousCell : int

var finished : bool = false

#@export var start : bool = false : set = set_start
#func set_start(val:bool)->void:
#	if Engine.is_editor_hint():
#		create_dungeon()
	
func _ready():
	startIt()
	
func startIt():
	create_dungeon()
	
var dun_cell_scene : PackedScene = preload("res://Assets/Map/Rooms/dun_cell.tscn")

var directions : Dictionary = {
	"up" : Vector3i.FORWARD,"down" : Vector3i.BACK,
	"left" : Vector3i.LEFT,"right" : Vector3i.RIGHT
}


	
# 0 = General Room | 1 = Hallway | 2 = Door
	
# Then for the cell thing
# 1 edge - 2 free - 3 doorway - 4 hallway

func handle_none(cell:Node3D,dir:String):
	#Nothing next to it, remove door keep wall
	cell.call("remove_door_"+dir)
	cell.roomThing = 2
func handle_00(cell:Node3D,dir:String):
	# Room tile next to room tile = remove walls and doors of room
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
	cell.roomThing = 2
func handle_01(cell:Node3D,dir:String):
	# Room next to Hallway = Keep wall, remove door of room
	cell.call("remove_door_"+dir)
	cell.roomThing = 1
func handle_02(cell:Node3D,dir:String):
	#room next to door = Remove wall and door of room
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
	cell.roomThing = 3
func handle_10(cell:Node3D,dir:String):
	#Hallway next to a room = keep wall remove door of hallway
	cell.call("remove_door_"+dir)
	cell.roomThing = 4
func handle_11(cell:Node3D,dir:String):
	# Hallway next to hallway = remove door and wall of hallway
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
	cell.roomThing = 4
func handle_12(cell:Node3D,dir:String):
	#hallway next to door, remove wall and door of hallway
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
	cell.roomThing = 3
func handle_20(cell:Node3D,dir:String):
	#door next to room = remove wall and door of door
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
	cell.roomThing = 2
func handle_21(cell:Node3D,dir:String):
	#Door next to hallway = remove wall keep door of door
	cell.call("remove_wall_"+dir)
	cell.roomThing = 3
func handle_22(cell:Node3D,dir:String):
	#Door next to door, remove door and wall of door
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
	cell.roomThing = 2

func create_dungeon():
	#Clear current Dungeon
	finished = false
	GlobalScript.playerSpawnSet = false
	for c in get_children():
		remove_child(c)
		c.queue_free()
		
	var t : int = 0
	#Add mesh and delete needed doors/walls for every filled cell in the grid map
	for cell in grid_map.get_used_cells():
		var cell_index : int = grid_map.get_cell_item(cell)
		var actualCellIndex = cell_index
		
		
		if cell_index > 3:  # This is to simplify stuff, any room tile should do the same thing
			cell_index = 0
		 
		# As long as its not a border tile
		if cell_index <=2 && cell_index >=0:
			
			#Insance mesh and place at current cells posisiton
			var dun_cell : Node3D = dun_cell_scene.instantiate()
			dun_cell.setCellRoomType(actualCellIndex)
			add_child(dun_cell)
			dun_cell.set_owner(owner)
			dun_cell.position = Vector3i(cell) * 20 + Vector3i(0.5,0,0.5)
			
			
			t += 1 #Add time
			for i in 4: #Repeat four times for all sides
				var cell_n : Vector3i = cell + directions.values()[i]
				var cell_n_index : int = grid_map.get_cell_item(cell_n)
				
				if cell_n_index > 3: # This is to simplify stuff, any room tile should do the same thing
					cell_n_index = 0
					
				#If either nothing or border
				if cell_n_index ==-1 || cell_n_index == 3:
					
					handle_none(dun_cell,directions.keys()[i])
					
				# Otherwise if room, door or hallway
				else:
					#call function based on room types
					var key : String = str(cell_index) + str(cell_n_index)
					call("handle_"+key,dun_cell,directions.keys()[i])
					
			previousCell = actualCellIndex
			
		if t%10 == 9 : await get_tree().create_timer(0).timeout #So it doesn't all gen at once
		
		else:
			#Generation is now finished, do stuff.
			if finished == false:
				mapGenFinished()
				finished = true
		

	
func mapGenFinished():
	#First spawn everything inside the map, then spawn the player.
	await get_tree().create_timer(1).timeout
	get_tree().call_group("wallSpawn","spawnStuff")
	await get_tree().create_timer(4).timeout
	get_tree().call_group("furnitureSpawn","spawnStuff")
	await get_tree().create_timer(4).timeout
	navRegion.bake_navigation_mesh()
	await get_tree().create_timer(1).timeout
	#get_tree().call_group("cell","spawnThePlayer") #Now just when they try to enter.
	loadingScreen.hide()
