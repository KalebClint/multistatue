extends Node

#GlobablWorldEnviroment.enviroment.adjustment_brightness = BANANA

var brightness : int
var masterVolume : int
var musicVolume : int
var sfxVolume : int

func setVariables(sliderType,_slider):
	if sliderType == 0:#Brightness
		brightness = _slider
	elif sliderType == 1:#MasterVolume
		masterVolume = _slider
	elif sliderType == 2:#MusicVolume
		musicVolume = _slider
	elif sliderType == 3:#SfxVolume
		sfxVolume = _slider
