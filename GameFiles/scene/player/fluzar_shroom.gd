extends CharacterBody2D

@onready var damageofftimer = get_node("Timer")
var hypno = false
var dmg = 0
var DoT = 0
var poof = preload("res://scene/item/smokepoof.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func setdamage(_input_dmg, input_DoT):
	dmg = 0
	DoT = input_DoT / 6.0
	
func hypnoset():
	hypno = true
	modulate = Color.FOREST_GREEN

func _on_area_2d_body_entered(body):
	if body.name == "Player" and hypno and damageofftimer.is_stopped():
		body.heal(5.0 * DoT)
		damageofftimer.start()
		var poofspawn = poof.instantiate()
		poofspawn.position = position
		poofspawn.modulate = Color.MEDIUM_SEA_GREEN
		get_parent().call_deferred("add_child", poofspawn)
	elif body.name == "Player" and damageofftimer.is_stopped():
		body.hurt(0,DoT)
		damageofftimer.start()
		var poofspawn = poof.instantiate()
		poofspawn.position = position
		poofspawn.modulate = Color.LIGHT_SKY_BLUE
		get_parent().call_deferred("add_child", poofspawn)
	elif body.is_in_group("mob") and hypno and damageofftimer.is_stopped():
		body.hurt(0,0,0,(5.0 * DoT))
		damageofftimer.start()
		var poofspawn = poof.instantiate()
		poofspawn.position = position
		poofspawn.modulate = Color.DARK_OLIVE_GREEN
		get_parent().call_deferred("add_child", poofspawn)


func _on_lifetimer_timeout():
	var fade = get_tree().create_tween()
	fade.tween_property(self,"modulate:a",0, 0.1)
	await get_tree().create_timer(0.2).timeout
	queue_free()
