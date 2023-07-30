extends LineEdit
var currently_focused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_focus_entered():
	currently_focused = true
	Variables.inputIsDisabled = true


func _on_focus_exited():
	currently_focused = false
	Variables.inputIsDisabled = false


func _on_text_submitted(_new_text):
	currently_focused = false
	Variables.inputIsDisabled = false
