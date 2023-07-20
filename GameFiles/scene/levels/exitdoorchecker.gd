extends Node2D

signal which_door_opened(x)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_exitdoor_open_door(x):
	which_door_opened.emit(x)


func _on_exitdoor_2_open_door(x):
	which_door_opened.emit(x)


func _on_exitdoor_3_open_door(x):
	which_door_opened.emit(x)


func _on_exitdoor_1_open_door(x):
	which_door_opened.emit(x)
