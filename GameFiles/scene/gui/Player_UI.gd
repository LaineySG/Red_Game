extends CanvasLayer

var shine = false
var gamegoldstore = 0
@onready var gold = get_node("gold")

# Called when the node enters the scene tree for the first time.
func _ready():
	gamegoldstore = Game.playergold


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !shine:
		shine = true
		await get_tree().create_timer(15.0).timeout
		gold.play("default")
		shine = false
		
	
	if gamegoldstore < Game.playergold:
		var redscale = get_tree().create_tween()
		redscale.tween_property(gold, "scale", Vector2(4.0,4.0), 0.2)
		await get_tree().create_timer(0.2).timeout
		var backtonormal2 = get_tree().create_tween()
		backtonormal2.tween_property(gold, "scale", Vector2(1.6,1.6), 0.1)
		
		gamegoldstore = Game.playergold
	elif gamegoldstore > Game.playergold:
		gamegoldstore = Game.playergold


func _on_settings_opensettings():
	get_node("pause_modulation").visible = false
	get_node("settings_modulation").visible = true


func _on_main_menu_returntomenu():
	get_node("pause_modulation").visible = true
	get_node("settings_modulation").visible = false
