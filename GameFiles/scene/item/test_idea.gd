extends Area2D
var itemstats = []
var given = false
@onready var itemgen = $item_generator
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Sprite2D").texture = load("res://assets/item/idea_beige.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(_body):
	if !given:
		for i in range (0,150):
			itemstats = itemgen._itemgen(1)
			Game.items_list.append(itemstats)
		given = true
		get_node("Sprite2D").visible = false
		get_node("AnimatedSprite2D").visible = true


func _on_animated_sprite_2d_animation_finished():
	queue_free()
