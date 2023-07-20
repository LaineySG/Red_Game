extends Node2D

var spark = preload("res://scene/player/spark.tscn")
var on = true
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	


func _on_flickertimer_timeout():
	var randinterval
	if on:
		on = false
		get_node("Shadow").energy = 0
		get_node("TextureLight").energy = 0
		randinterval = rng.randf_range(0.1,0.3)
		get_node("flickertimer").wait_time = randinterval
	else:
		on = true
		get_node("Shadow").energy = 1
		get_node("TextureLight").energy = 1
		get_node("GPUParticles2D").emitting = true
		randinterval = rng.randf_range(0.4,1.8)
		get_node("flickertimer").wait_time = randinterval
		
		
	
	
