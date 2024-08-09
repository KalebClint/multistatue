extends CanvasLayer

# This is the menu script, to keep things concise, everything will be done here, quitting, changing options, and playing game.

@onready var menu = $MainMenu
@onready var options = $PauseMenu
@onready var world = $WorldEnvironment


func _ready():
	get_tree().paused = false
	options.hide()
	menu.show()
	GlobalScript.mainMenu = true

func _process(delta):
	world.environment.adjustment_brightness = GlobalScript.brightness / 100
	options.brightCheck.modulate.a = GlobalScript.brightness / 150

# Solo Play Button, when clicked loads in game as mode of single player.
func OnPlayPressed():
	GlobalScript.soloPlayer = true
	GlobalScript.mainMenu = false
	get_tree().change_scene_to_file("res://Scenes/Game/gameManager.tscn")

# Multi Play Button, when clicked loads in game as mode of multiplayer.
func OnMultiPlayPressed():
	GlobalScript.soloPlayer = false
	GlobalScript.mainMenu = false
	get_tree().change_scene_to_file("res://Scenes/Game/gameManager.tscn")

#Options button, hides main menu and shows options menu
func OnOptionsPressed():
	
	options.show()
	menu.hide()

# Quits game for those too cowardly to handle it.
func OnQuitPressed():
	#Pretty easy, ik.
	get_tree().quit()

# THIS IS OPTIONS MENU CODE

# Hide Options, Show Menu
func OnBackButtonPressed():
	options.hide()
	menu.show()
