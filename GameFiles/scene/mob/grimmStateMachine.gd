extends StateMachine

func _ready():
	add_state("run")
	add_state("idle")
	add_state("attack_start")
	add_state("attack_finish")
	add_state("death")
	add_state("frozen")
	add_state("casting")
	add_state("dead")
	add_state("jump")
	add_state("happy")
	call_deferred("set_state", states.idle)

func _state_logic(delta):	
	if state == states.run or state == states.jump:
		parent._apply_movement(delta)
	elif state != states.death and state != states.dead:
		parent._apply_movement(delta,true) #delta, nomove = true
	elif parent.frozen or state == states.dead:
		parent.apply_gravity(delta)
	
func _get_transition(_delta):
	if parent.player != null:
		if parent.player.camo:
			return states.idle
	if parent.casting:
		return states.casting
		
	if parent.tutorial_area_2_cutscene_1:
		return states.run
	if parent.is_in_cutscene:
		return states.idle
		
	if parent.dying and !parent.dead:
		return states.death
	if parent.nopatience and !parent.frozen:
		return states.happy
	if parent.nopatience and parent.frozen and state != states.frozen and state != states.dead:
		return states.frozen
	if parent.chase and (parent.navi.get_final_position().y < (parent.global_position.y - 40.0)) and !parent.dead and !parent.dying and state != states.happy and !parent.frozen:
		# if player is higher
		if parent.jumptimer.is_stopped():
			parent.jumptimer.start()
		if state != states.jump and parent.player_higher:
			parent.velocity.y = -300 # jump
			parent.velocity.x = (Vector2(1000,0) * ((parent.player.position - parent.position).normalized())).x
			return states.jump
		var currentpos
		if parent.chase:
			currentpos = parent.position.x
			if parent.repathtimer.is_stopped():
				parent.repathtimer.start()
		if parent.chase and parent.repath:
			if abs(parent.position.x - currentpos) < 30 and parent.navi.distance_to_target() > 150:
				if !parent.hypnotized:
					parent.velocity.x = (Vector2(2000,0) * ((parent.player.position - parent.position).normalized())).x
				else:
					parent.velocity.x = (Vector2(2000,0) * ((parent.frogtarget.position - parent.position).normalized())).x
				parent.velocity.y = -300 # short hop away 
				parent.repath = false
	else:
		parent.player_higher = false
	match state:
		states.idle:
			if parent.chase:
				return states.run
		states.run:
			if parent.attack_ready:
				return states.attack_start
			if !parent.chase and !parent.attack_ready:
				return states.idle
		states.attack_start:
			if parent.hit: #if timer ended
				return states.attack_finish
			if parent.chase: # if player has left area
				return states.idle
		states.attack_finish:
			if parent.attack_ready: # repeat attack if ready
				return states.attack_start
			else:
				return states.idle
		states.happy:
			if parent.berserk:
				return states.idle
		states.death:
			return states.dead
		states.jump:
			if parent.is_on_floor():
				return states.run
		states.frozen:
			return states.dead
		states.casting:
			if !parent.casting:
				return states.idle


func _enter_state(new, _previous):
	match new:
		states.idle:
			parent.anim.play("Idle")
			get_node("Label").text = "idle"
		states.run:
			parent.anim.play("Jump")
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
			parent.chase = false
			parent.interactions(false)
			if !parent.frozen:
				parent.anim.play("dead")
				get_node("Label").text = "dead"
			elif parent.frozen:
				parent.anim.play("ice_block")
				parent.get_node("AnimatedSprite2D").modulate = Color(.3,.3,.3,.4)
				get_node("Label").text = "Ice_block"
		states.happy:
			parent.attack_ready = false
			parent.chase = false
			parent.interactions(false)
			parent.anim.play("Idle")
			get_node("Label").text = "happy"
		states.attack_start:
			parent.anim.play("attack")
			get_node("Label").text = "attack_start"
			parent.attacktimer.start()
		states.casting:
			parent.anim.play("magic")
			get_node("Label").text = "casting"
		states.attack_finish:
			parent.attack()
			get_node("Label").text = "attack_finish"
			parent.hit = false
		
	
func _exit_state(previous, _new):
	match previous:
		states.happy:
			parent.interactions(true)
