extends Control


@onready var slider = $TextureProgressBar


#Do i really need to explain this variable?
var mouseInslider := false

func _ready():
	slider.value = slider.max_value

func _input(event):
	#Listen for mouse click, but only if mouse inside bar.
	if mouseInslider && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		setValue(slider)
		
func setValue(_slider : TextureProgressBar):
	#Set value to wherever mouse is
	_slider.value = ratioInBody(_slider) * _slider.max_value

func ratioInBody(_slider : TextureProgressBar):
	#Find position of mouse in body
	var posClicked = get_local_mouse_position() - _slider.position
	var ratio = posClicked.x / slider.size.x
	
	#If beyond bar, set max, if behind bar, set min.
	if ratio > 1:
		ratio = _slider.min_value
	elif ratio < 0:
		ratio = _slider.max_value
	return ratio


func MouseOn(): #Signal
	mouseInslider = true

func MouseOff(): # Signal
	mouseInslider = false
