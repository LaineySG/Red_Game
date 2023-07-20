extends StateMachine

func _ready():
	add_state("run")
	add_state("idle")
	add_state("shoot")
	add_state("death")
	add_state("frozen")
	add_state("dead")
	add_state("happy")
	call_deferred("set_state", states.idle)

func _state_logic(delta):	
	if state == states.run:
		parent._apply_movement(delta)
	elif (state != states.death and state != states.dead) or state == states.idle :
		parent._apply_movement(delta,true) #delta, nomove = true
	elif parent.frozen or state == states.dead:
		parent.apply_gravity(delta)
	
func _get_transition(_delta):
	if parent.player != null:
		if parent.player.camo:
			return states.idle
	
	if parent.tutorial_area_2_cutscene_1:
		return states.run
	
	if parent.dying and !parent.dead:
		return states.death
	if parent.nopatience and !parent.frozen:
		return states.happy
	if parent.nopatience and parent.frozen and state != states.frozen and state != states.dead:
		return states.frozen
		
	match state:
		states.idle:
			if parent.chase:
				return states.run
		states.run:
			if parent.attack_ready:
				return states.shoot
			if !parent.chase and !parent.attack_ready:
				return states.idle
		states.shoot:
			return states.idle
		states.happy:
			if parent.berserk:
				return states.idle
		states.death:
			return states.dead
		states.frozen:
			return states.dead


func _enter_state(new, _previous):
	match new:
		states.idle:
			parent.anim.play("Idle")
			get_node("Label").text = "idle"
		states.run:
			parent.anim.play("Idle")
			get_node("Label").text = "run"
		states.death:
			parent.attack_ready = false
			parent.chase = false
			parent.interactions(false)
			get_node("Label").text = "dying"
			parent.anim.play("Death")
			await parent.anim.animation_finished
			parent.dead = true
		states.frozen:
			parent.attack_ready = false
			parent.chase = false
			parent.interactions(false)
			get_node("Label").text = "frozen"
			parent.anim.play("frozen")
			await parent.anim.animation_finished
			parent.dead = true
		states.dead:
			parent.attack_ready = false
			parent.dead = true
			parent.chase = false
			parent.interactions(false)
			if !parent.frozen:
				parent.anim.play("dead")
				get_node("Label").text = "dead"
			elif parent.frozen:
				parent.anim.play("ice_block")
				get_node("Label").text = "Ice_block"
		states.happy:
			parent.attack_ready = false
			parent.chase = false
			parent.interactions(false)
			parent.anim.play("happy")
			get_node("Label").text = "happy"
		states.shoot:
			parent.anim.play("Idle")
			get_node("Label").text = "shooting"
		
	
func _exit_state(previous, _new):
	match previous:
		states.happy:
			parent.interactions(true)
