extends Area2D
signal overlapping(count)
var bodies = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_area_entered(area):
	if area != null:
		if self.get_rid() > area.get_rid():
			bodies.append(area)
			overlapping.emit(bodies.size())


func _on_area_exited(area):
	if area != null:
		if self.get_rid() > area.get_rid():
			if bodies.has(area):
				bodies.erase(area)
			overlapping.emit(bodies.size())
