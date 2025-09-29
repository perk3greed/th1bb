extends Node2D


var health_points : float = 30
var modulated_timer : float = 0
var modulated_state : bool = false
var this_boss_patter : Vector2 
var current_position : int = 0
var pos_changed : bool = true
var snapshot_position : Vector2 
var pos_change_timer : float = 0
var boss_internal_timer : float = 0
var amount_of_aoue_attacks : int 
var player_snapshot_pos : Vector2
var play_snap_mir : Vector2
var rng = RandomNumberGenerator.new()
var pos_change_in_que : bool
var health_threshold : int = 29
var faze_changed : bool = true

signal target_hit
signal boss1testkilled
signal boss_attack
signal boss_secondary_attack


func _ready() -> void:
	$normal_attack.start()
	Events.connect("attack_finished", react_to_finished_attack)
	Events.connect("await_finished", procede_with_faze_change)
	Events.boss_position = position
	Events.boss_fight_faze = 1
	
	
	




func react_to_finished_attack():
	print("iwant to change", faze_changed)
	$normal_attack.stop()
	if faze_changed == false:
		Events.emit_signal("boss_attack", "boss6_cirles_phaze_change_lvl2")
		modulated_state = true
		modulated_timer = -11111
	else:
		$normal_attack.start()
	


func _process(delta: float) -> void:
	
	
	
	if modulated_state == true:
		
		modulated_timer += 1*delta
		if modulated_timer >= 0.6:
			modulated_state = false
			$Sprite2D.modulate = Color(1,1,1)





func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		var ball_charge = Events.ball_charge
		if ball_charge < 4:
			if modulated_state == false:
				health_points -= 4-ball_charge
				$Sprite2D.modulate = Color(0.1,0.1,0.1)
				modulated_state = true
				modulated_timer = 0
				Events.boss_hp = health_points
				Events.emit_signal("target_hit")
				if health_points < health_threshold:
					print("thershold passseddddddddddddddddddddddd")
					faze_changed = false
					
				
				
				
				if health_points <= 0:
					Events.emit_signal("boss1testkilled")
					self.queue_free()
				


func _on_normal_attack_timeout() -> void:
	print("attkkk_active==" ,Events.attack_currently_active)
	
	#Events.emit_signal("boss_attack", "sans_circling_attack")
	Events.emit_signal("boss_attack", "boss6_cirles_phaze_change_lvl3_part1")



func procede_with_faze_change():
	Events.boss_fight_faze += 1
	$normal_attack.start()
	modulated_timer = 0.3
	health_threshold -= 6
	faze_changed = true


#
#
#
	#print("attkkk_active==" ,Events.attack_currently_active)
	#if rng.randi()%2 == 0:
		#if Events.attack_currently_active == true:
			#return
		#else:
			##Events.emit_signal("boss_attack", "sans_circling_attack")
			#Events.emit_signal("boss_attack", "boss6_cirles_phaze_change")
			##Events.boss_fight_faze = 2 
		#var random_place = rng.randi()%2
		#if random_place == 1:
			#Events.random_number_of_two = 1
		#else:
			#Events.random_number_of_two = 2
#
	#else :
		#if Events.attack_currently_active == true:
			#return
		#else:
			#
			##Events.emit_signal("boss_attack", "sans_circling_attack")
			#Events.emit_signal("boss_attack", "boss6_cirles_phaze_change")
#
	#if amount_of_aoue_attacks < 2:
		#amount_of_aoue_attacks += 1
		#$normal_attack.start()
	#elif amount_of_aoue_attacks == 2 :
		#
		#$normal_attack.start()
	#
#
#
#
