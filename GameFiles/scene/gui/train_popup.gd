extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	get_node("SpinBox").max_value = Game.meringues
	get_node("Label").text = "meringues (total: " + str(Game.meringues) + ")"
	if self.name == "train_popup_gun":
		get_node("Label2").text = "For " + str(get_node("SpinBox").value) + " gunomancy training points"
		get_node("Label3").text = "Resets all unspent gunomancy training points back to meringues. Cannot be undone."


func _on_texture_button_pressed():
	if self.name == "train_popup_gun":
		var points = get_node("SpinBox").value
		if points <= Game.meringues:
			Game.meringues -= points
			Game.talent_points_gun_unspent += points
			get_node("TextureButton/Label").text = "Done!"
			await get_tree().create_timer(1.0).timeout
			get_node("TextureButton/Label").text = "Accept"


func _on_texture_button_2_pressed():
	var points = Game.talent_points_gun_unspent
	Game.talent_points_gun_unspent = 0
	Game.meringues += points
	get_node("TextureButton2/Label").text = "Done!"
	await get_tree().create_timer(1.0).timeout
	get_node("TextureButton2/Label").text = "Reset"
