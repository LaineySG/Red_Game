extends Node
var save_path = "user://saves/"
var scene_name = "scenedata"
var scene_name_postfix = ".tscn"
var save_name = "savegamedata"
var save_name_postfix = ".tres"
var gamedata = ResourceDataVariables.new()
var savecountmax = 10000

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
	var breakloop = false
	for i in savecountmax:
		if !breakloop:
			if ResourceLoader.exists(save_path+save_name+str(i)+save_name_postfix):
				#do nothing - save file exists
				pass
			else:
				var packed_scene = PackedScene.new()
				packed_scene.pack(current_scene)
				ResourceSaver.save(packed_scene,save_path+scene_name+str(i)+scene_name_postfix)
				gamedata.denitialize()
				var gamedata_save = ResourceSaver.save(gamedata, save_path+save_name+str(i)+save_name_postfix)
				assert(gamedata_save == OK)
				breakloop = true
				break
		else:
			break
	if !breakloop: # if all file numbers are taken
		savecountmax += 1000
			
func loadgame() -> PackedScene:
	for i in range(savecountmax,0,-1): #counting down
		if ResourceLoader.exists(save_path+save_name+str(i)+save_name_postfix) and ResourceLoader.exists(save_path+scene_name+str(i)+scene_name_postfix):
			gamedata = ResourceLoader.load(save_path+save_name+str(i)+save_name_postfix)
			gamedata.initialize()
			return ResourceLoader.load(save_path + scene_name+str(i)+scene_name_postfix)
		else:
			pass
			#do nothing
	#if no return = no save file
	return null
		
		
