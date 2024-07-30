extends CanvasLayer

var enabled : bool

var peer = ENetMultiplayerPeer.new()
@export var playerScene : PackedScene
@onready var gameScene = $".."

func _ready():
	enabled = !GlobalScript.soloPlayer
	if enabled:
		show()
	else:
		hide()

func HostButtonPressed():
	peer.create_server(1027)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(gameScene.addPlayer)
	gameScene.addPlayer()
	
	hide()

func JoinButtonPressed():
	peer.create_client("127.0.0.1",1027)
	multiplayer.multiplayer_peer = peer
	
	hide()


