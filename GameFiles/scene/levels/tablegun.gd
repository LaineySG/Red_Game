extends Area2D

var picked_up =false
var wtf = preload("res://scene/mob/wtf.tscn")
var rng = RandomNumberGenerator.new()
signal gun1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_overlapping_bodies() != []:
		if get_overlapping_bodies()[0].name == "Player":
			if Input.is_action_just_pressed("ui_E") and !picked_up:
				var gotgun = wtf.instantiate()
				var locationmodx = rng.randi_range(-80,0)
				gotgun.position = global_position
				gotgun.position.x += locationmodx
				gotgun.position.y -= 15
				gotgun.settext("Picked up sleeping agent's Gun!")
				gotgun.modulate = Color(1,0,0,1)
				get_parent().add_child(gotgun)
				picked_up = true
				Game.gun_list.append("gun")
				Game.weapon_equipped = Game.gun_list[0]
				gun1.emit()
				if Game.inventorylock:
					Game.inventorylock = false
				self.queue_free()
			

