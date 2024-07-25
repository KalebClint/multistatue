extends CanvasLayer

var enabled : bool

var peer = ENetMultiplayerPeer.new()
@export var playerScene : PackedScene

func _ready():
	enabled = !GlobalScript.soloPlayer
	if enabled:
		show()
	else:
		hide()

func HostButtonPressed():
	peer.create_server(1027)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(addPlayer)
	addPlayer()
	
	hide()

func JoinButtonPressed():
	peer.create_client("127.0.0.1",1027)
	multiplayer.multiplayer_peer = peer
	
	hide()

func addPlayer(id = 1):
	var player = playerScene.instantiate()
	player.name = str(id)
	call_deferred("add_child",player)
	
func cowardLeft(id):
	multiplayer.peer_disconnected.connect(kickCoward)
	kickCoward(id)
	
func kickCoward(id):
	rpc("_kickCoward",id)
	
@rpc("any_peer","call_local")
func _kickCoward(id):
	get_node(str(id)).queue_free()
