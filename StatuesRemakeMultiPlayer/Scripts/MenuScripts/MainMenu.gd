extends CanvasLayer

# This is the menu script, to keep things concise, everything will be done here, quitting, changing options, and playing game.

@onready var menu = $MainMenu
@onready var options = $PauseMenu


func _ready():
	options.hide()
	menu.show()

# Solo Play Button, when clicked loads in game as mode of single player.
func OnPlayPressed():
	pass #Load Scene in solo

# Multi Play Button, when clicked loads in game as mode of multiplayer.
func OnMultiPlayPressed():
	pass #Load Scene in multi

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
