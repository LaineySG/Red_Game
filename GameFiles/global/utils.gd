extends Node

func pausegame():
	if get_tree().paused == false:
		get_tree().paused = true
		
func unpausegame():
	if get_tree().paused == true:
		get_tree().paused = false
			
func reset():
	get_tree().reload_current_scene()
	

	



