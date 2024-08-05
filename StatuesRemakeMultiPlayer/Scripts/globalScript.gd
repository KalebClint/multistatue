extends Node

#GlobablWorldEnviroment.enviroment.adjustment_brightness = BANANA

var brightness : int
var masterVolume : int
var musicVolume : int
var sfxVolume : int

var forwardKey
var backwardKey
var leftKey
var rightKey

var mainMenu : bool

var soloPlayer : bool

#FOR NARNIA!!! (STATUES)

var players = []

func setVariables(sliderType,_slider):
	if sliderType == 0:#Brightness
		brightness = _slider
	elif sliderType == 1:#MasterVolume
		masterVolume = _slider
	elif sliderType == 2:#MusicVolume
		musicVolume = _slider
	elif sliderType == 3:#SfxVolume
		sfxVolume = _slider

var ummm = 0

var roomsGenerated = 0
var maxRooms = 13

var numberOfTorches = 0

var paintingNumber = 0
var paintingPerCell = 11

var torchNumber = 0
var torchPerCell = 5
#Procedual Generation
var playerSpawnSet = false
