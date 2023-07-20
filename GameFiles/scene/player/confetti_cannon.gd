extends Node2D

@onready var particle1 = $GPUParticles2D
@onready var particle2 = $GPUParticles2D2
@onready var particle3 = $GPUParticles2D3
@onready var particle4 = $GPUParticles2D4


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var children = get_node("Childspawner").get_children()
	for i in children:
		if i.is_visible_in_tree() == false:
			i.queue_free()
	
func hideall():
	pass

func emitall(start_pos):
	var temp1 = particle1.duplicate()
	var temp2 = particle2.duplicate()
	var temp3 = particle3.duplicate()
	var temp4 = particle4.duplicate()
	get_node("Childspawner").add_child(temp1)
	get_node("Childspawner").add_child(temp2)
	get_node("Childspawner").add_child(temp3)
	get_node("Childspawner").add_child(temp4)
	self.global_position = start_pos
	var direction = (get_global_mouse_position() - start_pos).normalized()
	temp1.process_material.direction.x = direction.x
	temp1.process_material.direction.y = direction.y
	temp2.process_material.direction.x = direction.x
	temp2.process_material.direction.y = direction.y
	temp3.process_material.direction.x = direction.x
	temp3.process_material.direction.y = direction.y
	temp4.process_material.direction.x = direction.x
	temp4.process_material.direction.y = direction.y
	temp1.restart()
	temp1.emitting = true
	temp2.restart()
	temp2.emitting = true
	temp3.restart()
	temp3.emitting = true
	temp4.restart()
	temp4.emitting = true
