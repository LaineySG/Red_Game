extends Node
var save_path = "user://saves/"
var scene_name = "scenedata.tscn"
var save_name = "savegamedata.tres"
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
func savegame(current_scene):
	var packed_scene = PackedScene.new()
	packed_scene.pack(current_scene)
	ResourceSaver.save(packed_scene,save_path+scene_name)
	gamedata.denitialize()
	var gamedata_save = ResourceSaver.save(gamedata, save_path+save_name)
	assert(gamedata_save == OK)
	
func loadgame() -> PackedScene:
	if ResourceLoader.exists(save_path+save_name) and ResourceLoader.exists(save_path+scene_name):
		gamedata = ResourceLoader.load(save_path+save_name)
		gamedata.initialize()
		return ResourceLoader.load(save_path + scene_name)
	else:
		return null
		
		
