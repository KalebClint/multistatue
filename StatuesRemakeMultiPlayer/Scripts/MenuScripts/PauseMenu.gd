extends CanvasLayer

# Just A wittle ittle bit o spaghetti here. In my defence I was hungry.

#Actually, not nearly as much as i thot, guess im just too smat.

#Heres a dictoinary, cuz i totally know how to use em.

var Resolutions: Dictionary = {
	"3840x2160":Vector2i(3840,2160),
	"2568x1440":Vector2i(2568,1440),
	"1920x1080":Vector2i(1920,1080),
	"1366x768":Vector2i(1366,768),
	"1280x720":Vector2i(1280,720),
	"1440x900":Vector2i(1440,900),
	"1600x900":Vector2i(1600,900),
	"800x600":Vector2i(800,600),
}

@onready var resOptions = $Options/TabBar/Video/OptionButton
@onready var gameScene = $".."

@onready var general = $Options/TabBar/General # Index = 0
@onready var audio = $Options/TabBar/Audio # Index = 1
@onready var video = $Options/TabBar/Video # Index = 2
@onready var controls = $Options/TabBar/Controls # Index = 3
@onready var credits = $Options/TabBar/Credits # Index = 4

@onready var tab = $Options/TabBar

@onready var fullscreen = $Options/TabBar/Video/Fullscreen
@onready var windowed = $Options/TabBar/Video/Windowed
@onready var borderless = $Options/TabBar/Video/Borderless

#INPUT STUFF HERE

@onready var fLabel = $Options/TabBar/Controls/Forward/forwardLabel
@onready var bLabel = $Options/TabBar/Controls/Backward/backLabel
@onready var lLabel = $Options/TabBar/Controls/Left/leftLabel
@onready var iLabel = $Options/TabBar/Controls/Interact/interactLabel
@onready var rLabel = $Options/TabBar/Controls/Right/rightLabel

@onready var fButton = $Options/TabBar/Controls/Forward/Button
@onready var bButton = $Options/TabBar/Controls/Backward/Button
@onready var rButton = $Options/TabBar/Controls/Right/Button
@onready var lButton = $Options/TabBar/Controls/Left/Button
@onready var iButton = $Options/TabBar/Controls/Interact/Button



var isRemaping = false
var actionToRemap = null
var buttonLabel = null
var labelToChange = null
var labelBack = ""

func _ready():
	
	#Make sure General is the first tab on start. duh.
	hideAll()
	general.show()
	tab.current_tab = 0
	
	if GlobalScript.mainMenu:
		$Options/TabBar/General/Quit.hide()
		$Options/TabBar/General/Continue.hide()
		general.hide()
		tab.current_tab = 1
		tab.set_tab_hidden(0,true)
	else:
		$Options/TabBar/BackButton.hide()
		
	for r in Resolutions:
		resOptions.add_item(r)

func _input(event):
	if isRemaping:
		if (event is InputEventKey):
			InputMap.action_erase_events(actionToRemap)
			InputMap.action_add_event(actionToRemap,event)
			buttonLabel.text = event.as_text().trim_suffix(" (Physical)")
			labelToChange.text = labelBack
			isRemaping = false
			
		

func TabChanged(tab):
	#Hides all tabs, then shows coresponding one. duh.
	hideAll()
	if tab == 0:
		general.show()
	elif tab == 1:
		audio.show()
	elif tab == 2:
		video.show()
	elif tab == 3:
		controls.show()
	elif tab == 4:
		credits.show()
	
func hideAll():
	#hides every tab. duh.
	general.hide()
	audio.hide()
	video.hide()
	controls.hide()
	credits.hide()

func BackPressed(): # Signal For when back button pressed. duh.
	hide()
	if GlobalScript.mainMenu:
		$"../MainMenu".show()


func LeaveGamePressed():
	#gameScene.cowardLeft() figure out later
	#actually maybe just go to main menu
	#get_tree().quit()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menus/MainMenu.tscn")
	# In main menu wont exist, but in game will leave mlutiplayer if needed, then go to main menu.

func ContinuePressed():
	hide()
	if GlobalScript.mainMenu:
		$"../MainMenu".show()
	else:
		hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if GlobalScript.soloPlayer:
			get_tree().paused = false

# VIDEO SETTINGS

func fullscreenToggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		windowed.button_pressed = false
		borderless.button_pressed = false

func _on_windowed_toggled(toggled_on):
		if toggled_on:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			fullscreen.button_pressed = false
			borderless.button_pressed = false

func _on_borderless_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		windowed.button_pressed = false
		fullscreen.button_pressed = false

func _on_option_button_item_selected(index):
	var ID = resOptions.get_item_text(index)
	get_window().set_size(Resolutions[ID])
	#centerWindow()
	
func centerWindow():
	var centerScreen = DisplayServer.screen_get_position()*DisplayServer.screen_get_size()/2
	var WindowSize = get_window().get_size_with_decorations()
	get_window().set_position(centerScreen*WindowSize/2)

func remapKey():
	isRemaping = true
	labelToChange.text += "  ---  Press Key To Bind..."

#OTHER INPUT STUFF IS HERE AS WELL

func forwardButtonPressed():
	if !isRemaping:
		buttonLabel = fButton
		actionToRemap = "forwardMovement"
		labelToChange = fLabel
		labelBack = "Forward Key"
		remapKey()
		
		

func backwardButtonPressed():
	if !isRemaping:
		buttonLabel = bButton
		actionToRemap = "backwardMovement"
		labelToChange = bLabel
		labelBack = "Backward Key"
		remapKey()

func rightButtonPressed():
	if !isRemaping:
		buttonLabel = rButton
		actionToRemap = "rightMovement"
		labelToChange = rLabel
		labelBack = "Right Key"
		remapKey()

func leftButtonPressed():
	if !isRemaping:
		buttonLabel = lButton
		actionToRemap = "leftMovement"
		labelToChange = lLabel
		labelBack = "Left Key"
		remapKey()

func interactButtonPressed():
	if !isRemaping:
		buttonLabel = iButton
		actionToRemap = "interact"
		labelToChange = iLabel
		labelBack = "Interact Key"
		remapKey()
