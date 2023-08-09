extends CanvasLayer

var allowexit = false
var master_bus = AudioServer.get_bus_index("Master")
var music_bus = AudioServer.get_bus_index("Music")
var SFX_bus = AudioServer.get_bus_index("SFX")

# Called when the node enters the scene tree for the first time.
func _ready():
	if Variables.master_volume_slider_value != null:
		AudioServer.set_bus_volume_db(master_bus, Variables.master_volume_slider_value)
		get_node("Panel/MasterVolume").value = Variables.master_volume_slider_value
		_on_master_volume_value_changed(Variables.master_volume_slider_value)
	if Variables.music_volume_slider_value != null:
		AudioServer.set_bus_volume_db(music_bus, Variables.music_volume_slider_value)
		get_node("Panel/MusicVolume").value = Variables.music_volume_slider_value
		_on_music_volume_value_changed(Variables.music_volume_slider_value)
	if Variables.sfx_volume_slider_value != null:
		AudioServer.set_bus_volume_db(SFX_bus, Variables.sfx_volume_slider_value)
		get_node("Panel/SFXVolume").value = Variables.sfx_volume_slider_value
		_on_sfx_volume_value_changed(Variables.sfx_volume_slider_value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if self.visible:
		await get_tree().create_timer(0.05).timeout
		allowexit = true
	if Input.is_action_just_pressed("ui_cancel") and self.visible and allowexit:
		allowexit = false
		self.visible = false
		Utils.unpausegame()


func _on_master_volume_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus, value)
	Variables.master_volume_slider_value = value
	
	if value == -30:
		AudioServer.set_bus_mute(master_bus, true)
		get_node("Panel/Muted").visible = true
	else:
		AudioServer.set_bus_mute(master_bus, false)
		get_node("Panel/Muted").visible = false


func _on_music_volume_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus, value)
	Variables.music_volume_slider_value = value
	
	if value == -30:
		AudioServer.set_bus_mute(music_bus, true)
		get_node("Panel/Muted2").visible = true
	else:
		AudioServer.set_bus_mute(music_bus, false)
		get_node("Panel/Muted2").visible = false


func _on_sfx_volume_value_changed(value):
	AudioServer.set_bus_volume_db(SFX_bus, value)
	Variables.sfx_volume_slider_value = value
	
	if value == -30:
		AudioServer.set_bus_mute(SFX_bus, true)
		get_node("Panel/Muted3").visible = true
	else:
		AudioServer.set_bus_mute(SFX_bus, false)
		get_node("Panel/Muted3").visible = false


func _on_enemydamagetoggle_toggled(button_pressed):
	Variables.enemy_damage_float_toggle = button_pressed


func _on_playerdamagetoggle_toggled(button_pressed):
	Variables.player_damage_float_toggle = button_pressed
