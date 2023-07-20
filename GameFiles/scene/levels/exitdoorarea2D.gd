extends Area2D

@onready var open = false
signal opendoor(chosendoor)
var locked = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if has_overlapping_bodies() and !locked:
		open = true
		if Input.is_action_just_pressed("ui_E") and !locked:
			emit_signal("opendoor",self)
		

