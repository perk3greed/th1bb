extends Node2D


var health_points : float = 60
var modulated_timer : float = 0
var modulated_state : bool = false
var this_boss_patter : Vector2 
var snapshot_position : Vector2 
var boss_internal_timer : float = 0
var amount_attacks : int 
var invul_state : bool = false
var phaze_changed : bool = true
var current_phaze : int = 1
var health_threshlod : int = 52


var rng = RandomNumberGenerator.new()


signal target_hit
signal boss1testkilled
signal boss_attack

func _ready() -> void:
	Events.boss_fight_faze = current_phaze

func _process(delta: float) -> void:
	
	Events.boss_position = position
	if modulated_state == true:
		if invul_state == true:
			return
		else:
			modulated_timer += 1*delta
			if modulated_timer >= 2.8:
				modulated_state = false
				$Sprite2D2.modulate = Color(1,1,1,1)




func phaze_change():
	if Events.attack_currently_active == true:
		$phaze_await.start()
		print("await")
		$random_attak.stop()

	else:
		$phaze_await.stop()
		print(Events.attack_currently_active,"phazechangeletsogoooooooooo")
		$small_attak_timer.start()
		$big_attak_timer.stop()
		
		invul_state = true
		

func close_phase_change():
	$small_attak_timer.stop()
	phaze_changed = true
	current_phaze += 1
	Events.boss_fight_faze = current_phaze
	amount_attacks = 0
	#Events.emit_signal("clear_attack")
	invul_state = false
	health_threshlod -= 10
	$small_attak_timer.wait_time = (7-current_phaze)/2
	$random_attak.start()
	print("crtfpaze===", current_phaze)

	
	if current_phaze > 2:
		$big_attak_timer.start()


func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("ball"):
		var ball_charge = Events.ball_charge
		if ball_charge < 4:
			if modulated_state == false:
				health_points -= 4-ball_charge
				$Sprite2D2.modulate = Color(0.7,0.3,0.5,0.3)
				modulated_state = true
				modulated_timer = 0
				Events.boss_hp = health_points
				Events.emit_signal("target_hit")
				if health_points < health_threshlod:
					phaze_changed = false
					phaze_change()

			
			
			if health_points <= 0:
				Events.emit_signal("boss1testkilled")
				self.queue_free()
			


func _on_small_attak_timer_timeout() -> void:
	print("iamgooning")
	if amount_attacks < current_phaze+1:
		if phaze_changed == false:
			Events.emit_signal("boss_attack", 4)
			amount_attacks += 1
	elif amount_attacks == current_phaze +1 : 
		amount_attacks += 1
	elif amount_attacks > current_phaze:
		Events.attack_currently_active = false
		amount_attacks = 0
		close_phase_change()


func _on_big_attak_timer_timeout() -> void:
	Events.emit_signal("boss_attack", 3)


func _on_random_attak_timeout() -> void:
	if phaze_changed == true:
		Events.emit_signal("boss_attack", 19)


func _on_phaze_await_timeout() -> void:
	phaze_change()
