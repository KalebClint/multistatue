extends CharacterBody3D

#Okay so assume max four player, min one. 
#Global script has array that has each player name.

#IT IS WORKING SO WELL WITHOUT DIFFICULTY
#I AM SO SMAT

@onready var playersNode = $"../../Players"
@onready var collision = $Collision
@onready var mesh = $Mesh

#Movement variables
@onready var navAgent = $NavAgent
var speed = 10
var pushForce = 5

var targetPlayer

var ray1Used : bool
var ray2Used : bool
var ray3Used : bool
var ray4Used : bool

var closestPlayerDis = 1000
var closestPlayer : int

var range = 100
var withinRange : bool

var lazerHitPlayer : bool
var seen : bool

var camTotal : int

var seen1 : bool
var seen2 : bool

#Statue Behaviors

var statueBehaviour : int
#disApear
var hathBeenSawed : bool
var active : bool
var becomeActive : bool
var anoyingVarINeedToAdd: bool

var boringChance = 0.6
var behaviourChance = 0.2
var behaviourAmount = 5

# 0 = boring
# 1 = disApear
# 2 = aPear
# 3 = aPearDisApear
# 4 = shooty


func _ready():  
	hathBeenSawed = false
	camTotal = 0
	FindClosestPlayer()
	
	#Pick behavior randomlyish
	statueBehaviour = 0
	var rand = randf()
	if rand > 0:#boringChance:
		decideBahaviour()

func decideBahaviour():
	var index = 1
	while index != behaviourAmount:
		var rand = randf()
		if rand < behaviourChance:
			statueBehaviour = index
			break
		index += 1
	if statueBehaviour == 2 || 3:
		mesh.hide()
		active = false
		collision.disabled = true

func _physics_process(delta):
	if hathBeenSawed != true && seen:
		hathBeenSawed = true
	
	#Set false for new frame, isn't horribly optimized as its contanstly checking each frame, but works so yippeee
	withinRange = false
	lazerHitPlayer = false
	
	#Check if at least a player is in range
	for player in GlobalScript.players:
		var p
		if player != 0:
			p = playersNode.get_node(str(player))
			
		var d = global_position.distance_to(p.global_position)
			
		if d < range:
			withinRange = true
			
	if !withinRange:
		await get_tree().create_timer(0.05).timeout
		if withinRange:
			FindClosestPlayer()
		
	#Go through each player, create a ray and shoot them with said lazer. if lazer hits at least one player, statue can be seen.
	#but only if statue is in cam. optimization (:
	if camTotal > 0:
	
		for player in GlobalScript.players:
			
			var p = playersNode.get_node(str(player))
				
			var start = global_transform.origin
			
			var space_state = get_world_3d().direct_space_state
			var ray_query = PhysicsRayQueryParameters3D.new()
			ray_query.from = start
			ray_query.to = p.global_transform.origin
			ray_query.exclude = [self]
			var result = space_state.intersect_ray(ray_query)
			
			if result:
				var collider = result.collider
				if collider.is_in_group("player"):
					lazerHitPlayer = true
		
	
	if withinRange && camTotal > 0 && lazerHitPlayer:
		seen = true
	else:
		seen = false
		
		
	#Oki with all that fun stuff out of the wayu (thx mmultiplayer /:) now time for movement. ez clapz
	var currentLocation = global_transform.origin
	var next_location = navAgent.get_next_path_position()
	var newVelocity = (next_location - currentLocation).normalized() * speed
	
	navAgent.set_velocity(newVelocity)
	
	#Right, choose player to target. Ig should always be closest player?
	#it only changes closest player every time deactivated then actived / when look at, so wont randomly go after someone
	#else when they get closer, only when reset and they are closer.
	if closestPlayer != 0:
		targetPlayer = playersNode.get_node(str(closestPlayer))
		if !seen && targetPlayer != null:
			look_at(targetPlayer.global_transform.origin,Vector3.UP)
			rotation.x = 0
		
		if !seen && withinRange && targetPlayer != null:
			updateTargetLocation(targetPlayer.global_transform.origin)
	
func updateTargetLocation(targetLoc):
	if targetLoc != null:
		navAgent.target_position = targetLoc
	else:
		print("zac says Target Non Existant")
		
func _on_nav_agent_velocity_computed(safe_velocity):
	if !seen && withinRange && active:
		velocity = velocity.move_toward(safe_velocity,0.25)
		move_and_slide()
		if targetPlayer != null:
			look_at(-targetPlayer.global_position)
		rotation.x = 0
		
		for i in get_slide_collision_count():
			var c = get_slide_collision(i)
			if c.get_collider() is RigidBody3D:
				c.get_collider().apply_central_impulse(-c.get_normal() * pushForce)
		
func _on_nav_agent_target_reached():
	#if !seen && !targetPlayer.playerBeingKilledBrutaly:
	pass#targetPlayer.playerKilled()
		
func FindClosestPlayer():
	#find the closest player, call when activated (first player enters range) or becomes seen
	closestPlayer = 0
	closestPlayerDis = 100
	
	for player in GlobalScript.players:
		var p = playersNode.get_node(str(player))
		var d = global_position.distance_to(p.global_position)
		
		if d < closestPlayerDis:
			closestPlayerDis = d
			closestPlayer = p.name.to_int()
		
func statueAppear():
		active = true
		mesh.show()
		collision.disabled = false
	
func statueDisapear():
	await get_tree().create_timer(0.1).timeout
	queue_free()
		
#If this works then i am so smat bro
#Actualyl wait im so dumb
#It can be so much simplter

#This is necessary as there can be multiple players, but all i care about is whether or not at least one player is looking at it. 
#if camTotal is 0 then the statue isn't in any camera view, so no need for raycast. I then raycast to check if wall imbetween.


# 0 = boring
# 1 = disApear
# 2 = aPear
# 3 = aPearDisApear
# 4 = shooty

func _on_visible_on_screen_notifier_3d_screen_entered():
	camTotal += 1
	
	if closestPlayerDis < 100 && statueBehaviour == 2 || 3:
		becomeActive = true
		
	if !seen2 && seen1:
		seen2 = true
	elif !seen1:
		seen1 = true


func _on_visible_on_screen_notifier_3d_screen_exited():
	camTotal -= 1
	if statueBehaviour == 1:
		if hathBeenSawed == true:
			#statueDisapear()
			print("zac says bye")
			
	if seen2 && statueBehaviour == 3:
		print("zac says dis 2")
		#statueDisapear()
			
	if statueBehaviour == 2 || 3:
		if becomeActive == true && !active:
			print("zac says hi")
			statueAppear()
			
	
	


