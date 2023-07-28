extends Area2D
var itemstats = []
var cost
var acceptinput = false
var bodies = []
var given = false
signal cantafford
signal viewitem(item, itemstats)
signal hideitem(item)
@onready var itemgen = $item_generator
# Called when the node enters the scene tree for the first time.
func _ready():
	if itemstats == []:
		itemstats = itemgen._itemgen(1)
	if Variables.current_room_items.has(get_parent().name):
		itemstats = Variables.current_room_items[get_parent().name]
	var rarity = itemstats["Rarity"]
	if rarity == "Common":
		get_node("Sprite2D").texture = load("res://assets/item/idea_common.png")
	if rarity == "Uncommon":
		get_node("Sprite2D").texture = load("res://assets/item/idea.png")
	if rarity == "Rare":
		get_node("Sprite2D").texture = load("res://assets/item/idea_purple.png")
	if rarity == "Epic":
		get_node("Sprite2D").texture = load("res://assets/item/idea_orange.png")
	if rarity == "Insane":
		get_node("Sprite2D").texture = load("res://assets/item/idea_pink.png")
	if rarity == "Perfect":
		get_node("Sprite2D").texture = load("res://assets/item/idea_beige.png")
	Variables.current_room_items[get_parent().name] = itemstats

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for body in bodies:
		if body.name == "Player":
			if Input.is_action_just_pressed("ui_E") and Game.playergold >= cost and !given:
				Game.playergold -= cost
				given = true
				itemstats["Cost"] = floor(cost / 2.0)
				Game.items_list.append(itemstats)
				get_node("Sprite2D").visible = false
				get_node("AnimatedSprite2D").visible = true
				await get_node("AnimatedSprite2D").animation_finished
				self.visible = false
			elif Input.is_action_just_pressed("ui_E"):
				cantafford.emit()


func _on_body_entered(body):
	if body.name == "Player":
		bodies.append(body)
		viewitem.emit(self, self.itemstats)

func _on_animated_sprite_2d_animation_finished():
	queue_free()
	hideitem.emit(self)


func _on_body_exited(_body):
	bodies = []
	hideitem.emit(self)
