extends Area2D

var picked_up = false
var wtf = preload("res://scene/mob/wtf.tscn")
var rng = RandomNumberGenerator.new()
signal gun2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_overlapping_bodies() != []:
		if get_overlapping_bodies()[0].name == "Player" and !picked_up:
			if Input.is_action_just_pressed("ui_E"):
				var gotgun = wtf.instantiate()
				var locationmodx = rng.randi_range(-50,0)
				gotgun.position = global_position
				gotgun.position.x += locationmodx
				gotgun.position.y -= 15
				gotgun.settext("Picked up your toy gun!")
				gotgun.modulate = Color(1,1,0,1)
				get_parent().add_child(gotgun)
				picked_up = true
				Game.gun_list.append("toygun")
				Game.weapon_equipped = Game.gun_list[0]
				gun2.emit()
				if Game.inventorylock:
					Game.inventorylock = false
				self.queue_free()
			

