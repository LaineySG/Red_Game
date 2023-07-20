extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_node("MarginContainer/RichTextLabel2").rarity == "Common":
		self_modulate = Color8(255,255,255,255)
	if get_node("MarginContainer/RichTextLabel2").rarity == "Uncommon":
		self_modulate = Color8(255,255,255,255)
	if get_node("MarginContainer/RichTextLabel2").rarity == "Rare":
		self_modulate = Color8(255,207,233,255)
	if get_node("MarginContainer/RichTextLabel2").rarity == "Epic":
		self_modulate = Color8(255,169,99,255)
	if get_node("MarginContainer/RichTextLabel2").rarity == "Insane":
		self_modulate = Color8(255,184,219,255)
	if get_node("MarginContainer/RichTextLabel2").rarity == "Perfect":
		self_modulate = Color8(255,229,181,255)
		
	var sizediff = (get_node("MarginContainer").size.y - 260) * 2
	if global_position.y > (630 - sizediff):
		global_position.y = (630 - sizediff)
		
	if get_node("MarginContainer").size.y > 60 and get_node("MarginContainer").size.y < 1000:
		size.y = get_node("MarginContainer").size.y + 20
