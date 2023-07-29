extends Node
var save_path = "user://saves/"
var scene_name = "scenedata"
var scene_name_postfix = ".tscn"
var save_name = "savegamedata"
var save_name_postfix = ".tres"
var gamedata = ResourceDataVariables.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	verify_save_directory(save_path)

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
#
func savegame(current_scene,slot): # slot can be 1,2,3,4. 1 is autosave.
	var packed_scene = PackedScene.new()
	packed_scene.pack(current_scene)
	ResourceSaver.save(packed_scene,save_path+scene_name+str(slot)+scene_name_postfix)
	gamedata.denitialize()
	var gamedata_save = ResourceSaver.save(gamedata, save_path+save_name+str(slot)+save_name_postfix)
	assert(gamedata_save == OK)
			
func get_save_data(slot):
	if ResourceLoader.exists(save_path+save_name+str(slot)+save_name_postfix) and ResourceLoader.exists(save_path+scene_name+str(slot)+scene_name_postfix):
		var time = FileAccess.get_modified_time(save_path+save_name+str(slot)+save_name_postfix)
		return Time.get_datetime_string_from_unix_time(time,true)		
	else:
		return null
			
func loadgame(slot) -> PackedScene:
	if ResourceLoader.exists(save_path+save_name+str(slot)+save_name_postfix) and ResourceLoader.exists(save_path+scene_name+str(slot)+scene_name_postfix):
		gamedata = ResourceLoader.load(save_path+save_name+str(slot)+save_name_postfix)
		gamedata.initialize()
		return ResourceLoader.load(save_path + scene_name+str(slot)+scene_name_postfix)
	else:
		return null
		
		
