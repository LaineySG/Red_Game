extends Area2D

@onready var open = false
signal opendoor2
var door2opened = false
var door1opened = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if has_overlapping_bodies():
		open = true
		if Input.is_action_just_pressed("ui_E"):
			door2opened = true
			emit_signal("opendoor2")
		

