extends Sprite2D

var rng = RandomNumberGenerator.new()
var wtf = preload("res://scene/mob/wtf.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if self.visible:
		zzzspawn()

func zzzspawn():
	if self.visible:
		var zzz = wtf.instantiate()
		var locationmodx = rng.randi_range(-20,30)
		zzz.position = global_position
		zzz.position.x += locationmodx
		zzz.position.y -= 25
		zzz.settext("Zzz")
		get_parent().add_child.call_deferred(zzz)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_sleepy_timer_timeout():
	var timemodx = rng.randf_range(0.3,1.6)
	zzzspawn()
	get_node("sleepy_timer").wait_time = 1.0 + timemodx


func _on_timer_timeout():
	var timemodx = rng.randf_range(0.3,1.6)
	zzzspawn()
	get_node("sleepy_timer").wait_time = 1.0 + timemodx
