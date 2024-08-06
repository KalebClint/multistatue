extends GridMap

@onready var dunMesh = $"../NavRegion/DunMesh"

#Ui SCENES
@onready var loadingScreen = $"../LoadingScreen"

#@export var start : bool = false : set = set_start
#func set_start(val:bool)->void:
#	if Engine.is_editor_hint():
#		generate()

@export var player : PackedScene
@onready var spawner = $Spawner

func addPlayer(id = 1):
	var p = player.instantiate()
	p.global_position = spawner.global_position
	p.name = str(id)
	call_deferred("add_child",p)
	
	
func exitGame(id):
	multiplayer.peer_disconnected.connect(kickCoward)
	kickCoward(id)
	
func kickCoward(id):
	rpc("_kickCoward",id)
	
@rpc("any_peer","call_local")
func _kickCoward(id):
	get_node(str(id)).queue_free()
	


func _ready():
	
	loadingScreen.show()
	
	#Room number will be semi-random, but the more players the more rooms.
	##Normal Size
	#room_number = randi_range(30,60)
	
	#min_room_size = randi_range(2,4)
	#max_room_size = randi_range(5,8)
	
	room_number = randi_range(20,30)
	
	min_room_size = 3
	max_room_size = 7
	
	border_size = room_number * 1.7
	
	generate()
	
	await get_tree().create_timer(3).timeout
	dunMesh.startIt()

@export_range(0,1) var survival_chance : float = 0.25
@export var border_size : int = 20 : set = set_border_size
func set_border_size(val : int)->void:
	border_size = val
	if Engine.is_editor_hint():
		visualize_border()

@export var room_number : int = 4
@export var room_margin : int = 1
@export var room_recursion : int = 15
@export var min_room_size : int = 2 
@export var max_room_size : int = 4
@export_multiline var custom_seed : String = "" : set = set_seed 

var roomsGenerated : int = 0
var entranceRoom = 0
var dungeonRoom = room_number

func set_seed(val:String)->void:
	custom_seed = val
	seed(val.hash())

var room_tiles : Array[PackedVector3Array] = []
var room_positions : PackedVector3Array = []

func visualize_border():
	clear()
	for i in range(-1,border_size+1):
		set_cell_item( Vector3i(i,0,-1),3)
		set_cell_item( Vector3i(i,0,border_size),3)
		set_cell_item( Vector3i(border_size,0,i),3)
		set_cell_item( Vector3i(-1,0,i),3)

func generate():
	roomsGenerated = 0
	room_tiles.clear()
	room_positions.clear()
	var t : int = 0
	if custom_seed : set_seed(custom_seed)
	visualize_border()
	for i in room_number:
		t+=1
		var roomType : int = getRoomType()
		make_room(room_recursion,roomType)
		if t%17 == 16: await get_tree().create_timer(0).timeout
	
	var rpv2 : PackedVector2Array = []
	var del_graph : AStar2D = AStar2D.new()
	var mst_graph : AStar2D = AStar2D.new()
	
	for p in room_positions:
		rpv2.append(Vector2(p.x,p.z))
		del_graph.add_point(del_graph.get_available_point_id(),Vector2(p.x,p.z))
		mst_graph.add_point(mst_graph.get_available_point_id(),Vector2(p.x,p.z))
	
	var delaunay : Array = Array(Geometry2D.triangulate_delaunay(rpv2))
	
	for i in delaunay.size()/3:
		var p1 : int = delaunay.pop_front()
		var p2 : int = delaunay.pop_front()
		var p3 : int = delaunay.pop_front()
		del_graph.connect_points(p1,p2)
		del_graph.connect_points(p2,p3)
		del_graph.connect_points(p1,p3)
	
	var visited_points : PackedInt32Array = []
	visited_points.append(randi() % room_positions.size())
	while visited_points.size() != mst_graph.get_point_count():
		var possible_connections : Array[PackedInt32Array] = []
		for vp in visited_points:
			for c in del_graph.get_point_connections(vp):
				if !visited_points.has(c):
					var con : PackedInt32Array = [vp,c]
					possible_connections.append(con)
					
		#Occaisionnaly and randomly throws errors.
		await get_tree().create_timer(0.01).timeout #Maybe dis will fix it
		var connection : PackedInt32Array = possible_connections.pick_random()
		for pc in possible_connections:
			if rpv2[pc[0]].distance_squared_to(rpv2[pc[1]]) <\
			rpv2[connection[0]].distance_squared_to(rpv2[connection[1]]):
				connection = pc
		
		visited_points.append(connection[1])
		mst_graph.connect_points(connection[0],connection[1])
		del_graph.disconnect_points(connection[0],connection[1])
	
	var hallway_graph : AStar2D = mst_graph
	
	for p in del_graph.get_point_ids():
		for c in del_graph.get_point_connections(p):
			if c>p:
				var kill : float = randf()
				if survival_chance > kill :
					hallway_graph.connect_points(p,c)
					
	create_hallways(hallway_graph)
	
func create_hallways(hallway_graph:AStar2D):
	var hallways : Array[PackedVector3Array] = []
	for p in hallway_graph.get_point_ids():
		for c in hallway_graph.get_point_connections(p):
			if c>p:
				var room_from : PackedVector3Array = room_tiles[p]
				var room_to : PackedVector3Array = room_tiles[c]
				var tile_from : Vector3 = room_from[0]
				var tile_to : Vector3 = room_to[0]
				for t in room_from:
					if t.distance_squared_to(room_positions[c])<\
					tile_from.distance_squared_to(room_positions[c]):
						tile_from = t
				for t in room_to:
					if t.distance_squared_to(room_positions[p])<\
					tile_to.distance_squared_to(room_positions[p]):
						tile_to = t
				var hallway : PackedVector3Array = [tile_from,tile_to]
				hallways.append(hallway)
				set_cell_item(tile_from,2)
				set_cell_item(tile_to,2)
	
	var astar : AStarGrid2D = AStarGrid2D.new()
	astar.size = Vector2i.ONE * border_size
	astar.update()
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	
	for t in get_used_cells_by_item(0):
		astar.set_point_solid(Vector2i(t.x,t.z))
	var _t : int = 0
	for h in hallways:
		_t +=1
		var pos_from : Vector2i = Vector2i(h[0].x,h[0].z)
		var pos_to : Vector2i = Vector2i(h[1].x,h[1].z)
		var hall : PackedVector2Array = astar.get_point_path(pos_from,pos_to)
		
		for t in hall:
			var pos : Vector3i = Vector3i(t.x,0,t.y)
			if get_cell_item(pos) <0:
				set_cell_item(pos,1)
		if _t%16 == 15: await  get_tree().create_timer(0).timeout
	
func make_room(rec:int, type:int):
	
	if !rec>0:
		return
	
	var width : int = (randi() % (max_room_size - min_room_size)) + min_room_size
	var height : int = (randi() % (max_room_size - min_room_size)) + min_room_size
	
	var start_pos : Vector3i 
	start_pos.x = randi() % (border_size - width + 1)
	start_pos.z = randi() % (border_size - height + 1)
	
	for r in range(-room_margin,height+room_margin):
		for c in range(-room_margin,width+room_margin):
			var pos : Vector3i = start_pos + Vector3i(c,0,r)
			if get_cell_item(pos) == 0:
				var roomType : int = getRoomType()
				make_room(rec-1,roomType)
				return
	
	var room : PackedVector3Array = []
	for r in height:
		for c in width:
			var pos : Vector3i = start_pos + Vector3i(c,0,r)
			set_cell_item(pos,type)
			room.append(pos)
	room_tiles.append(room)
	var avg_x : float = start_pos.x + (float(width)/2)
	var avg_z : float = start_pos.z + (float(height)/2)
	var pos : Vector3 = Vector3(avg_x,0,avg_z)
	room_positions.append(pos)
	
	roomsGenerated += 1

func getRoomType():
	
	randomize()
	var rand = randf()
	
	if roomsGenerated == entranceRoom:
		return 12
	elif roomsGenerated == dungeonRoom:
		return 9
	
	var kitchenChance : float = 0.16
	var libraryChance : float = 0.12
	var livingRoomChance : float = 0.17
	var bedroomChance : float = 0.17
	var diningRoomChance : float = 0.14
	var storageRoomChance : float = 0.2
	var gardenRoomChance : float = 0.15
	
	if rand < bedroomChance:
		return 5
	rand = randf()
	if rand < kitchenChance:
		return 4
	rand = randf()
	if rand < libraryChance:
		return 7
	rand = randf()
	if rand < livingRoomChance:
		return 6
	rand = randf()
	if rand < diningRoomChance:
		return 10
	rand = randf()
	if rand < storageRoomChance:
		return 8
	rand = randf()
	if rand < gardenRoomChance:
		return 11
	else:
		return 0

