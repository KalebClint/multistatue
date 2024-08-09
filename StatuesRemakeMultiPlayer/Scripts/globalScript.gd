extends Node

#GlobablWorldEnviroment.enviroment.adjustment_brightness = BANANA

var amuletSpawned = false
var amuletStolen = false

var brightness : float
var masterVolume : float
var musicVolume : float
var sfxVolume : float

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
		#BTW currently brightness value will not carry over from main menu to game,
		#becuz me lazy, and have very little time left. that just ezier
		brightness = _slider
		if !mainMenu:
			get_tree().call_group("main","changeBrightness")
	elif sliderType == 1:#MasterVolume
		masterVolume = _slider
		if !mainMenu:
			get_tree().call_group("main","changeAudio")
	elif sliderType == 2:#MusicVolume
		musicVolume = _slider
		if !mainMenu:
			get_tree().call_group("main","changeAudio")
	elif sliderType == 3:#SfxVolume
		sfxVolume = _slider
		if !mainMenu:
			get_tree().call_group("main","changeAudio")
		

var ummm = 0
var hasVeryEvil = false

var roomsGenerated = 0
var maxRooms = 13

var numberOfTorches = 0

var paintingNumber = 0
var paintingPerCell = 11

var torchNumber = 0
var torchPerCell = 5
#Procedual Generation
var playerSpawnSet = false
