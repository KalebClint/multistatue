extends Node3D

var zeRoom
var zeArea

func checkIfCollidingWithRoomButMakeSureToExcludeRoomThatCalledSaidFunc(room):
	zeRoom = room
	print(zeRoom)

func sorryButIHaveToDeleteYouKnow():
	queue_free()
	print("deleted")
	GlobalScript.roomsGenerated -= 1

func _on_detection_area_entered(area):
	if area.is_in_group("room") && !zeRoom:
		#print(zeRoom)
		area.get_parent().sorryButIHaveToDeleteYouKnow()
		#print(area.get_parent())
