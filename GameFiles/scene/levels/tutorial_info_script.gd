extends CanvasLayer
var numpages = 1
var currentpage = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	numpages = get_child_count()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if self.visible:
		if Input.is_action_just_pressed("ui_cancel"):
			self.visible = false
			Utils.unpausegame()
		if numpages > 1:
			if Input.is_action_just_pressed("ui_left"):
				if currentpage > 1:
					currentpage -= 1
				showpage(currentpage)
			elif Input.is_action_just_pressed("ui_right"):
				if currentpage < numpages:
					currentpage += 1
				showpage(currentpage)
	
	
func showpage(page):
	for childs in get_children():
		childs.visible = false
		
	get_node("page"+ str(page)).visible = true
			
