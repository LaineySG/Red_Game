extends Area2D

@onready var open = false
signal opendoor
var unlocked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if has_overlapping_bodies() and unlocked:
		open = true
		if Input.is_action_just_pressed("ui_E") and unlocked:
			emit_signal("opendoor")
		



func _on_tutorial_area_3_gunspickedup():
	unlocked = true
