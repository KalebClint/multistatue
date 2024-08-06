extends CharacterBody3D

@onready var game_manager = $"../.."

@onready var neck := $Neck
@onready var camera := $Neck/Camera

@onready var light = $Neck/Camera/SpotLight3D
@onready var ray = $Neck/Camera/StatueRay

@onready var interRay = $Neck/Camera/InterRay

@onready var pauseMenu = $PauseMenu

var lightStrength = 70

var SPEED = 13
const JUMP_VELOCITY = 15

var double_jumped = false
var double_jump_unlocked = false
var statue
var playerBeingKilledBrutaly = false

@export var sensetivity = 0.005

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 20
var pushForce = 75

func _enter_tree():
	if !GlobalScript.soloPlayer:
		set_multiplayer_authority(name.to_int())

func _ready():
	if !GlobalScript.soloPlayer:
		camera.current = is_multiplayer_authority()
	pauseMenu.hide()


func _unhandled_input(event):
	if !playerBeingKilledBrutaly:
		if event is InputEventMouseButton:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		elif event.is_action_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				if event is InputEventMouseMotion:
					neck.rotate_y(-event.relative.x * sensetivity)
					camera.rotate_x(-event.relative.y * sensetivity)
					camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))

func _physics_process(delta):
	
	if !playerBeingKilledBrutaly:
	
		if Input.is_action_just_pressed("interact"):
			var col = interRay.get_collider()
			if col != null:
				if col.is_in_group("Door"):
					col.toggle()
		if Input.is_action_just_pressed("pause"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			pauseMenu.show()
			if GlobalScript.soloPlayer:
				get_tree().paused = true
		
		if statue != null:
			if statue.inCamView:
				ray.look_at(statue.global_transform.origin)
				#ray.target_position = statue.global_transform.origin
				if ray.is_colliding():
					var col = ray.get_collider()
					if col.is_in_group("statue"):
						statue.seen = true
					else:
						statue.seen = false
							
		
		light.light_energy = lightStrength
		
		# Add the gravity.
		
		if not is_on_floor():
			velocity.y -= gravity * delta
		elif is_on_floor():
			double_jumped = false
			
		# Handle Jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif Input.is_action_just_pressed("ui_accept") and not is_on_floor() and double_jumped == false and double_jump_unlocked == true:
			velocity.y = JUMP_VELOCITY
			double_jumped = true
			
		# Get the input direction and handle the movement/deceleration.
		var input_dir = Input.get_vector("leftMovement", "rightMovement", "forwardMovement", "backMovement")
		var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		move_and_slide()
		
		for i in get_slide_collision_count():
			var c = get_slide_collision(i)
			if c.get_collider() is RigidBody3D:
				c.get_collider().apply_central_impulse(-c.get_normal() * pushForce)
		
func checkSatue(stat):
	statue = stat
	#Not using ray rn, maybe will, but for now statues stop even if there is something between them and camera.
	#ray.enabled = true
	stat.seen = true
	
func stopCheckingStatue(stat):
	ray.enabled = false
	stat.seen = false
	
func playerKilled():
	playerBeingKilledBrutaly = true
	await get_tree().create_timer(3).timeout # Have Statue player animation of grabbing player
	#Probably add some sort of spectator thing for other players, maybe control a statue.
	#play sound too.
	#For now, just main menu.
	get_tree().change_scene_to_file("res://Scenes/Menus/mainMenu.tscn")
	

