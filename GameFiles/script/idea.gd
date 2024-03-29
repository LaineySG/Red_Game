extends Area2D
var itemstats = []
var given = false
@onready var itemgen = $item_generator
# Called when the node enters the scene tree for the first time.
func _ready():
	if itemstats == []:
		itemstats = itemgen._itemgen(1)
	if Variables.current_room_items.has(self.name):
		itemstats = Variables.current_room_items[self.name]
	var rarity = itemstats["Rarity"]
	
	if Game.roomcount == 0 or Game.roomcount == 1:
		while rarity == "Common":
			itemstats = itemgen._itemgen(1)
			rarity = itemstats["Rarity"]
			
	
	if rarity == "Common":
		get_node("Sprite2D").texture = load("res://assets/item/idea_common_2.png")
	if rarity == "Uncommon":
		get_node("Sprite2D").texture = load("res://assets/item/idea_2.png")
	if rarity == "Rare":
		get_node("Sprite2D").texture = load("res://assets/item/idea_purple_2.png")
	if rarity == "Epic":
		get_node("Sprite2D").texture = load("res://assets/item/idea_orange_2.png")
	if rarity == "Insane":
		get_node("Sprite2D").texture = load("res://assets/item/idea_pink_2.png")
	if rarity == "Perfect":
		get_node("Sprite2D").texture = load("res://assets/item/idea_beige_2.png")
		
	Variables.current_room_items[self.name] = itemstats


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(_body):
	if !given:
		given = true
		Game.items_list.append(itemstats)
		get_node("ping").play()
		get_node("poof").play()
		get_node("Sprite2D").visible = false
		get_node("AnimatedSprite2D").visible = true


func _on_animated_sprite_2d_animation_finished():
	get_node("Sprite2D").visible = false
	get_node("AnimatedSprite2D").visible = false


func _on_ping_finished():
	queue_free()
