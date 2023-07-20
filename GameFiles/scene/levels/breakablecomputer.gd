extends AnimatedSprite2D

var broken = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_body_entered(body):
	if !broken and body.name == "bullet":
		play("break")
		broken = true
		get_node("GPUParticles2D").emitting = true
		get_node("GPUParticles2D2").emitting = true
		get_node("GPUParticles2D3").emitting = true
		get_node("GPUParticles2D4").emitting = true
