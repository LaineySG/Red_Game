extends Sprite2D
	
var shot = false
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _setArmDir():
	if get_global_mouse_position().x > position.x && get_node("SideBodyLayerBase").flip_h == true:
		get_node("SideBodyLayerBase").flip_h = false
		get_node("SideBodyLayerTop").flip_h = false
		get_node("Gunarms/GunarmR").visible = true
		get_node("Gunarms/GunarmL").visible = false
	elif get_global_mouse_position().x < position.x && get_node("SideBodyLayerBase").flip_h == false:
		get_node("SideBodyLayerBase").flip_h = true
		get_node("SideBodyLayerTop").flip_h = true
		get_node("Gunarms/GunarmR").visible = false
		get_node("Gunarms/GunarmL").visible = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_setArmDir()
			
		
	if Input.is_action_just_pressed("ui_left_click"):
		get_node("SideBodyLayerTop").play("fire")
		get_node("SideBodyLayerBase").play("fire")
		shot = true
		#print("bang!")
		
		


func _on_side_body_layer_top_animation_finished():
	if get_node("SideBodyLayerTop").animation == "Sweat":
		get_node("SideBodyLayerTop").play("default")
		#print("Snap back to reality")
	elif get_node("SideBodyLayerTop").animation == "default" and (get_node("Gunarms/GunarmR/gun").fumble or get_node("Gunarms/GunarmL/gun").fumble):
		get_node("SideBodyLayerTop").play("Sweat")
		get_node("Gunarms/GunarmR/gun").fumble = false
		get_node("Gunarms/GunarmL/gun").fumble = false
		#print("Palms are sweaty, knees weak arms are heavy")
	if shot:
		get_node("SideBodyLayerTop").play("default")
		get_node("SideBodyLayerBase").play("default")
		shot = false
		#print("What if you only had one shot, one opportunity")
		
	


func _on_side_body_layer_top_animation_looped():
	if get_node("SideBodyLayerTop").animation == "Sweat":
		get_node("SideBodyLayerTop").play("default")
		#print("Snap back to reality")
	elif get_node("SideBodyLayerTop").animation == "default" and (get_node("Gunarms/GunarmR/gun").fumble or get_node("Gunarms/GunarmL/gun").fumble):
		get_node("SideBodyLayerTop").play("Sweat")
		get_node("Gunarms/GunarmR/gun").fumble = false
		get_node("Gunarms/GunarmL/gun").fumble = false
		#print("Palms are sweaty, knees weak arms are heavy")
	if shot:
		get_node("SideBodyLayerTop").play("default")
		get_node("SideBodyLayerBase").play("default")
		#print("What if you only had one shot, one opportunity")
