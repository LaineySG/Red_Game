extends Node2D
var choicemade = false
var clearitems = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for children in get_children():
		for childlayer2 in children.get_children():
			if childlayer2.given:
				choicemade = true
	if choicemade:
		for children in get_children():
			for childlayer2 in children.get_children():
				childlayer2.given = true
				
	
	for children in get_children():
		for childlayer2 in children.get_children():
			if childlayer2.clear:
				clearitems = true


func _on_idea_choice_made():
	get_node("ping").play()
	get_node("poof").play()
	get_node("item1").visible = false
	get_node("item2").visible = false
	get_node("item1").queue_free()
	get_node("item2").queue_free()


func _on_ping_finished():
	queue_free()
