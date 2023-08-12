extends RichTextLabel
var maxtimer = 60
var numSecs = 60
var combat = false
var timetrial = false
var initiated = false
var goldmod = 0
var trial_passed = false

func formattime(seconds):
	var mins = floor(seconds/60)
	var remainder = seconds % 60
	var secs = remainder
	if secs < 10:
		secs = "0" + str(secs)
		
	var result = ("0" + str(mins) + ":" + str(secs))
	if result == "00:00" or seconds < 0:
		result = "00:00"
		get_node("Timer").stop()
	var redval = (1.0 * seconds / maxtimer)
	self.modulate = Color(1.0,redval,redval,1.0)
	return result
	
func _ready():
	if initiated:
		pass
	else:
		init()
		
func init():
	initiated = true
	numSecs = maxtimer
	if combat and timetrial:
		self.visible = true
		var inittime = formattime(maxtimer)
		text = "[center]" + inittime + "\n" + "TIME TRIAL[/center]"
		
		var colorchange = get_tree().create_tween()
		colorchange.tween_property(self, "modulate", Color(1.0,0.2,0.2,1.0), 0.3)
		await get_tree().create_timer(0.5).timeout
		var colorchange1 = get_tree().create_tween()
		colorchange1.tween_property(self, "modulate", Color(1.0,1.0,1.0,1.0), 0.3)
		await get_tree().create_timer(0.5).timeout
		var colorchange2 = get_tree().create_tween()
		colorchange2.tween_property(self, "modulate", Color(1.0,0.2,0.2,1.0), 0.3)
		await get_tree().create_timer(0.5).timeout
		var colorchange3 = get_tree().create_tween()
		colorchange3.tween_property(self, "modulate", Color(1.0,1.0,1.0,1.0), 0.3)
		await get_tree().create_timer(0.5).timeout
		var colorchange4 = get_tree().create_tween()
		colorchange4.tween_property(self, "modulate", Color(1.0,0.2,0.2,1.0), 0.3)
		await get_tree().create_timer(0.5).timeout
		var colorchange5 = get_tree().create_tween()
		colorchange5.tween_property(self, "modulate", Color(1.0,1.0,1.0,1.0), 0.3)
		
		get_node("Timer").start()
	else:
		get_node("Timer").stop()
		self.visible = false

func _on_timer_timeout():
	if combat:
		numSecs -= 1
		var textout = formattime(numSecs) 
		text = "[center]" + textout + "[/center]"
		
		
		if textout == "00:00":
			await get_tree().create_timer(0.5).timeout
			var colorchange6 = get_tree().create_tween()
			colorchange6.tween_property(self, "modulate", Color(1.0,0.0,0.0,1.0), 0.3)
			await get_tree().create_timer(0.6).timeout
			text = "[center]X[/center]"
			await get_tree().create_timer(0.6).timeout
			text = "[center]00:00[/center]"
			await get_tree().create_timer(0.6).timeout
			text = "[center]X[/center]"
			await get_tree().create_timer(0.8).timeout
			self.queue_free()
	
		
	else:
		trial_passed = true
		await get_tree().create_timer(0.2).timeout
		var colorchange7 = get_tree().create_tween()
		colorchange7.tween_property(self, "modulate", Color(0.0,1.0,0.0,1.0), 0.6)
		await get_tree().create_timer(1.0).timeout
		var colorchange8 = get_tree().create_tween()
		colorchange8.tween_property(self, "modulate", Color(1.0,1.0,1.0,1.0), 0.6)
		await get_tree().create_timer(1.0).timeout
		var goldreward = max((goldmod * ceil(Game.roomcount / 4.0)),10)
		var bonusgoldreward = (float(numSecs) / float(maxtimer) * float(goldreward))
		if bonusgoldreward > 0:
			text = "[center]+" + str(goldreward) + " Coins\n + " + str(int(bonusgoldreward)) + " bonus [/center]"
		else:
			text = "[center]+" + str(goldreward) + " Coins\n [/center]" 
			
		var colorchange9 = get_tree().create_tween()
		colorchange9.tween_property(self, "modulate", Color(0.0,1.0,0.0,1.0), 0.6)
		await get_tree().create_timer(1.0).timeout
		Game.playergold += int(goldreward) + int(bonusgoldreward)
		self.queue_free()
		
		

