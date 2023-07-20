extends Area2D

@onready var open = false
signal opendoor
var door1opened = false
var door2opened = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if Game.tutorial_area2count == 1:
		self.remove_from_group("interact")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if has_overlapping_bodies():
		open = true
		if Input.is_action_just_pressed("ui_E") and Game.tutorial_area2count == 0:
			door1opened = true
			emit_signal("opendoor")
		

