extends CanvasLayer

var cursor = 0
signal changetext
var is_over = false
var disabletext = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("ui_accept") and cursor != -1 and get_node("spacetimer").is_stopped() and !is_over and !disabletext:
		cursor = -1
		get_node("spacetimer").start()
		is_over = true
	if Input.is_action_pressed("ui_accept") and cursor == -1 and get_node("spacetimer").is_stopped() and !disabletext:
		get_node("spacetimer").start()
		changetext.emit()


func change_text(speech, speaker):
	if !disabletext:
		var icon
		get_node("Sprite2D").scale.x = 15
		get_node("Sprite2D").scale.y = 15
		if speaker == "blue":
			icon = load("res://assets/NPCs/blueportrait.png")
		elif speaker == "red":
			icon = load("res://assets/player/redportrait.png")
		elif speaker == "prof":
			icon = load("res://assets/NPCs/profportrait.png")
		elif speaker == "grimm":
			icon = load("res://assets/NPCs/grimmportrait.png")
		elif speaker == "agent":
			icon = load("res://assets/NPCs/agentportrait.png")
			
			
		cursor = 0
		get_node("RichTextLabel").set_visible_characters(cursor)
		is_over = false
		get_node("Sprite2D").texture = icon
		get_node("RichTextLabel").text = speech

func _on_textscrolltimer_timeout():
	if !disabletext:
		if cursor != -1:
			cursor += 2
			get_node("ColorRect2/spacebaricon").visible = false
		if cursor < get_node("RichTextLabel").get_total_character_count() and cursor != -1:
			get_node("RichTextLabel").set_visible_characters(cursor)
			get_node("ColorRect2/spacebaricon").visible = false
		else:
			cursor = -1
			get_node("RichTextLabel").set_visible_characters(cursor)
			get_node("ColorRect2/spacebaricon").visible = true
			is_over = true
