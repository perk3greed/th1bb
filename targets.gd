extends Node2D

var bullet_timer : float = 1 
var bullet_projectile := preload("res://objects/bullet_default.tscn")
var bullet_timing : float
var rng = RandomNumberGenerator.new()
var bullet_counter : float
var current_pattern : int 
var patterning_shitty_shit : int
var boss_position : Vector2 
var powerup_prld := preload("res://objects/pick ups/power_up.tscn")
var reflect_bullet := preload("res://objects/bullet_reflective.tscn")
var tracking_bullet := preload("res://objects/targets/bullet_lookingfor.tscn")
var circling_bullet := preload("res://objects/targets/bullet_circling.tscn")
var bullet_spinned := preload("res://objects/bullet_spinned.tscn")


signal fourth_aoe_finished
signal attack_finished

var boss3_pattern_arrey : Array = [Vector2(15,5),Vector2(10,5),Vector2(5,5),Vector2(0,5),Vector2(-5,5),Vector2(-10,5),Vector2(-15,5)]

var boos4_pattern_arrey : Array = [Vector2(-20,5),Vector2(-18,5),Vector2(-16,5),Vector2(-14,5),Vector2(-12,5),Vector2(-10,5),Vector2(-8,5),Vector2(-6,5),Vector2(-4,5),Vector2(-2,5), Vector2( 0, 5), Vector2( 2, 5)]


func _ready() -> void:
	#Events.connect("spawn_boss", change_pattern)
	Events.connect("boss_attack", change_pattern)
	Events.connect("target_hit", react_to_boss_hit)

func _process(delta: float) -> void:
	
	if Events.pos_changing == true:
		return
	
	match current_pattern : 
		
		1:
			pass
		
		2:

			if patterning_shitty_shit < 36:
				patterning_shitty_shit += 1
				if patterning_shitty_shit % 6 == 0:
					var bullet_inst = bullet_projectile.instantiate()
					bullet_inst.position = Events.boss_position 
					bullet_inst.bullet_speed = 4
					add_child(bullet_inst)
			elif patterning_shitty_shit >= 36 and patterning_shitty_shit < 180 :
				patterning_shitty_shit += 1
			elif patterning_shitty_shit >= 180:
				patterning_shitty_shit = 0

		3:
			bullet_counter += 10*delta
			if bullet_counter >= bullet_timer:
				var bullet_inst = bullet_projectile.instantiate()
				var random_deviation = rng.randi_range(1,3)
				
				bullet_inst.bullet_speed = 4
				bullet_inst.position = Events.boss_position
				bullet_counter = 0
				if patterning_shitty_shit < 6:
					patterning_shitty_shit += 1
					bullet_inst.pattern_transfered = boss3_pattern_arrey[patterning_shitty_shit].normalized()
					add_child(bullet_inst)
				elif patterning_shitty_shit >= 6 and patterning_shitty_shit < 36 :
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= 36:
					#Events.emit_signal("third_boss_attack_finished")
					patterning_shitty_shit = 0
				

		4:
			bullet_counter += 10*delta
			boss_position = Events.boss_position
			if bullet_counter >= bullet_timer:
				var bullet_inst = bullet_projectile.instantiate()
				var random_deviation = rng.randi_range(1,3)
				
				bullet_inst.bullet_speed = 5
				bullet_inst.position = boss_position
				
				bullet_counter = 0
				if patterning_shitty_shit < 11:
					patterning_shitty_shit += 1
					if boss_position.x > 500:
						bullet_inst.pattern_transfered = boos4_pattern_arrey[patterning_shitty_shit].normalized()
					elif boss_position.x < 500: 
						bullet_inst.pattern_transfered = (boos4_pattern_arrey[patterning_shitty_shit]*Vector2(-1,1)).normalized()
					add_child(bullet_inst)
				elif patterning_shitty_shit >= 11 and patterning_shitty_shit < 35 :
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= 35:
					#Events.emit_signal("third_boss_attack_finished")
					patterning_shitty_shit = 0

		5:
			Events.attack_currently_active = true

			bullet_counter += 25*delta
			boss_position = Events.boss_position
			if bullet_counter >= bullet_timer:
				var bullet_inst = bullet_projectile.instantiate()
				bullet_inst.bullet_speed = 5
				
				bullet_counter = 0
				if patterning_shitty_shit < 9:
					patterning_shitty_shit += 1
					if boss_position.x < 500:
						bullet_inst.position = Vector2(1100,100) - Vector2(patterning_shitty_shit*75,0)
						bullet_inst.pattern_transfered = Vector2(-patterning_shitty_shit,15).normalized()
					elif boss_position.x > 500: 
						bullet_inst.position = Vector2(-200,100) + Vector2(patterning_shitty_shit*75,0)
						bullet_inst.pattern_transfered = Vector2(patterning_shitty_shit,15).normalized()
					add_child(bullet_inst)
				elif patterning_shitty_shit >= 9 and patterning_shitty_shit < 27 :
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= 27:
					patterning_shitty_shit = 0
					change_pattern(0)
					Events.emit_signal("fourth_aoe_finished")
					Events.attack_currently_active = false




		6:
			Events.attack_currently_active = true
			bullet_counter += 12*delta
			boss_position = Events.boss_position
			var player_position = Events.player_position
			if bullet_counter >= bullet_timer:
				var bullet_inst = bullet_projectile.instantiate()
				bullet_inst.bullet_speed = 6
				
				bullet_counter = 0
				if patterning_shitty_shit < 9:
					patterning_shitty_shit += 1
					bullet_inst.position = boss_position + Vector2(100,0)
					bullet_inst.pattern_transfered = ((player_position-boss_position)-Vector2(150,0)).normalized()
					add_child(bullet_inst)
				elif patterning_shitty_shit >= 9 and patterning_shitty_shit < 18 :
					bullet_inst.position = boss_position + Vector2(-100,0)
					bullet_inst.pattern_transfered = ((player_position-boss_position)-Vector2(-150,0)).normalized()
					add_child(bullet_inst)
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= 18 and patterning_shitty_shit < 56 :
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= 56:
					patterning_shitty_shit = 0
					change_pattern(0)
					Events.attack_currently_active = false




		7:
			
			Events.attack_currently_active = true
			bullet_counter += 10*delta
			boss_position = Events.boss_position
			var player_position = Events.player_position
			var player_mirrored =  2560 - player_position.x
			var player_mira = -player_position.x 
			var plm_false = Vector2(player_mira,player_position.y) - boss_position
			var plm_true = Vector2(player_mirrored,player_position.y) - boss_position
			if bullet_counter >= bullet_timer:
				var bullet_inst = reflect_bullet.instantiate()
				bullet_inst.bullet_speed = 5
				
				bullet_counter = 0
				if patterning_shitty_shit < 9:
					patterning_shitty_shit += 1
					bullet_inst.position = boss_position 
					bullet_inst.pattern_transfered = (plm_true + Vector2(0, - patterning_shitty_shit*25)).normalized()
					add_child(bullet_inst)
				elif patterning_shitty_shit >= 9 and patterning_shitty_shit < 18 :
					bullet_inst.position = boss_position 
					bullet_inst.pattern_transfered = (plm_false + Vector2(0,(- 18 + patterning_shitty_shit )*25)).normalized()
					add_child(bullet_inst)
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= 18 and patterning_shitty_shit < 36 :
					patterning_shitty_shit += 1
					bullet_inst.position = boss_position 
					bullet_inst.pattern_transfered = (plm_true + Vector2(0,(- patterning_shitty_shit + 18)*16)).normalized()
					add_child(bullet_inst)
				elif patterning_shitty_shit >= 36 and patterning_shitty_shit < 54 :
					bullet_inst.position = boss_position 
					bullet_inst.pattern_transfered = (plm_false + Vector2(0,(- 54 + patterning_shitty_shit )*16)).normalized()
					add_child(bullet_inst)
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= 54 and patterning_shitty_shit < 98 :
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= 86:
					patterning_shitty_shit = 0
					change_pattern(0)
					Events.attack_currently_active = false


		8:
			Events.attack_currently_active = true
			bullet_counter += 12*delta
			boss_position = Events.boss_position
			var player_position = Events.player_position
			if bullet_counter >= bullet_timer:
				var bullet_inst = tracking_bullet.instantiate()
				bullet_inst.bullet_speed = 4
				
				bullet_counter = 0
				if patterning_shitty_shit < 9:
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= 9 and patterning_shitty_shit < 18 :
					bullet_inst.position = boss_position 
					bullet_inst.pattern_transfered = (Vector2(rng.randi_range(-4,4),-8)).normalized()
					add_child(bullet_inst)
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= 18 and patterning_shitty_shit < 72 :
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= 72:
					patterning_shitty_shit = 0
					change_pattern(0)
					Events.attack_currently_active = false



		9:
			Events.attack_currently_active = true
			bullet_counter += 24*delta
			boss_position = Events.boss_position
			var player_position = Events.player_position
			var patone : float = 8
			var pattwo : float = 16
			var pattri : float = 20
			var patfor : float = 28
			var patpet : float = 36
			var patseh : float = 44
			var patsem : float = 52
			var patose : float = 60
			if bullet_counter >= bullet_timer:
				var bullet_inst = circling_bullet.instantiate()
				bullet_inst.bullet_speed = 2

				bullet_counter = 0
				if patterning_shitty_shit < patone:
					patterning_shitty_shit += 1
					bullet_inst.position = boss_position + Vector2(patone-patterning_shitty_shit, patterning_shitty_shit/2 + 3).normalized()*75
					bullet_inst.pattern_transfered = (bullet_inst.position - boss_position).normalized()
					bullet_inst.rot_angle = 0.003
					add_child(bullet_inst)
				elif patterning_shitty_shit >= patone and patterning_shitty_shit < pattwo :
					patterning_shitty_shit += 1
					bullet_inst.position = boss_position + Vector2(patterning_shitty_shit - pattwo, patterning_shitty_shit/2 - patone/2 + 3).normalized()*75
					bullet_inst.pattern_transfered = (bullet_inst.position - boss_position).normalized()
					bullet_inst.rot_angle = 0.003
					add_child(bullet_inst)
				elif patterning_shitty_shit >= pattwo and patterning_shitty_shit < pattri :
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= pattri and patterning_shitty_shit <patfor:
					patterning_shitty_shit += 1
					bullet_inst.position = boss_position + Vector2(patfor-patterning_shitty_shit, patterning_shitty_shit/2 - pattri/2 + 3).normalized()*35
					bullet_inst.pattern_transfered = (bullet_inst.position - boss_position).normalized()
					bullet_inst.rot_angle = -0.003
					add_child(bullet_inst)
				elif patterning_shitty_shit >= patfor and patterning_shitty_shit <patpet:
					patterning_shitty_shit += 1
					bullet_inst.position = boss_position + Vector2(patterning_shitty_shit  - patpet, patterning_shitty_shit/2 - patfor/2 + 3).normalized()*35
					bullet_inst.pattern_transfered = (bullet_inst.position - boss_position).normalized()
					bullet_inst.rot_angle = -0.003
					add_child(bullet_inst)
				elif patterning_shitty_shit >= patpet and patterning_shitty_shit < patseh:
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= patseh and patterning_shitty_shit < patsem:
					patterning_shitty_shit += 1
					bullet_inst.position = boss_position + Vector2(patterning_shitty_shit - patsem, patterning_shitty_shit/2 - patseh/2 + 3).normalized()*90
					bullet_inst.pattern_transfered = (bullet_inst.position - boss_position).normalized()
					bullet_inst.rot_angle = 0.003
					add_child(bullet_inst)
				elif patterning_shitty_shit >= patsem and patterning_shitty_shit < patose:
					patterning_shitty_shit += 1
					bullet_inst.position = boss_position + Vector2(patose - patterning_shitty_shit, patterning_shitty_shit/2 - patsem/2 + 3).normalized()*90
					bullet_inst.pattern_transfered = (bullet_inst.position - boss_position).normalized()
					bullet_inst.rot_angle = -0.003
					add_child(bullet_inst)
					
					
				elif patterning_shitty_shit >= patose:
					
					Events.emit_signal("attack_finished")
					patterning_shitty_shit = 0
					change_pattern(9)
					Events.attack_currently_active = false

		10:
			Events.attack_currently_active = true
			bullet_counter += 12*delta
			boss_position = Events.boss_position
			var reverse : bool
			if Events.random_number_of_two == 2:
				reverse = true
			else:
				reverse = false
			var player_position = Events.player_position
			if bullet_counter >= bullet_timer:
				var bullet_inst = tracking_bullet.instantiate()
				bullet_inst.bullet_speed = 2
				
				bullet_counter = 0
				if patterning_shitty_shit < 28:
					if reverse == true:
						bullet_inst.position = Vector2(100 + patterning_shitty_shit * 40, 0) 
					else:
						bullet_inst.position = Vector2(1180 - patterning_shitty_shit * 40, 0) 
					bullet_inst.pattern_transfered = (Vector2(rng.randi_range(-4,4),-8)).normalized()
					add_child(bullet_inst)
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= 28 and patterning_shitty_shit < 72 :
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= 72:
					patterning_shitty_shit = 0
					change_pattern(0)
					Events.emit_signal("attack_finished")
					Events.attack_currently_active = false


		11:
			bullet_counter += 25*delta
			var boss_position_left = Events.boss_left_position
			var boss_position_righ = Events.boss_righ_position
			Events.attack_currently_active = true
			boss_position = Events.boss_position
			var player_position = Events.player_position
			if bullet_counter >= bullet_timer:
				var bullet_inst = bullet_spinned.instantiate()
				bullet_inst.bullet_speed = 1
				
				bullet_counter = 0
				if patterning_shitty_shit < 9:
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= 9 and patterning_shitty_shit < 18 :
					bullet_inst.position = boss_position_left 
					add_child(bullet_inst)
					bullet_inst.pattern_transfered = (boss_position_righ - boss_position_left).normalized()
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= 18 and patterning_shitty_shit < 27 :
					patterning_shitty_shit += 1
					bullet_inst.position = boss_position_righ 
					bullet_inst.pattern_transfered = (boss_position_left - boss_position_righ).normalized()
					add_child(bullet_inst)
				elif patterning_shitty_shit >= 27 and patterning_shitty_shit < 36 :
					bullet_inst.position = boss_position_left 
					add_child(bullet_inst)
					bullet_inst.pattern_transfered = (boss_position_righ - boss_position_left).normalized()
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= 36 and patterning_shitty_shit < 45 :
					patterning_shitty_shit += 1
					bullet_inst.position = boss_position_righ 
					bullet_inst.pattern_transfered = (boss_position_left - boss_position_righ).normalized()
					add_child(bullet_inst)
				elif patterning_shitty_shit >= 45 and patterning_shitty_shit < 75 :
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= 75:
					change_pattern(0)
					patterning_shitty_shit = 0
					Events.attack_currently_active = false
					Events.emit_signal("attack_finished")



		12:
			Events.attack_currently_active = true
			bullet_counter += 24*delta
			boss_position = Events.boss_position
			var player_position = Events.player_position
			var patone : float = 8
			var pattwo : float = 16
			var pattri : float = 20
			var patfor : float = 28
			var patpet : float = 36
			var patseh : float = 44
			var patsem : float = 52
			var patose : float = 60
			if bullet_counter >= bullet_timer:
				var bullet_inst = reflect_bullet.instantiate()
				bullet_inst.bullet_speed = 3

				bullet_counter = 0
				if patterning_shitty_shit < patone:
					patterning_shitty_shit += 1
					bullet_inst.position = boss_position + Vector2(patone/2 - patterning_shitty_shit/2, patterning_shitty_shit).normalized()*75
					bullet_inst.pattern_transfered = (-bullet_inst.position + boss_position).normalized()
					bullet_inst.rot_angle = 0.003
					add_child(bullet_inst)
				elif patterning_shitty_shit >= patone and patterning_shitty_shit < pattwo :
					patterning_shitty_shit += 1
					bullet_inst.position = boss_position + Vector2(patterning_shitty_shit/2 - pattwo/2, patterning_shitty_shit - patone).normalized()*75
					bullet_inst.pattern_transfered = (-bullet_inst.position + boss_position).normalized()
					bullet_inst.rot_angle = 0.003
					add_child(bullet_inst)
				elif patterning_shitty_shit >= pattwo and patterning_shitty_shit < pattri :
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= pattri and patterning_shitty_shit <patfor:
					patterning_shitty_shit += 1
					bullet_inst.position = boss_position + Vector2(patfor/2-patterning_shitty_shit/2, patterning_shitty_shit - pattri).normalized()*35
					bullet_inst.pattern_transfered = (-bullet_inst.position + boss_position).normalized()
					bullet_inst.rot_angle = -0.003
					add_child(bullet_inst)
				elif patterning_shitty_shit >= patfor and patterning_shitty_shit <patpet:
					patterning_shitty_shit += 1
					bullet_inst.position = boss_position + Vector2(patterning_shitty_shit/2 - patpet/2, patterning_shitty_shit - patfor).normalized()*35
					bullet_inst.pattern_transfered = (-bullet_inst.position + boss_position).normalized()
					bullet_inst.rot_angle = -0.003
					add_child(bullet_inst)
				elif patterning_shitty_shit >= patpet and patterning_shitty_shit < patseh:
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= patseh and patterning_shitty_shit < patsem:
					patterning_shitty_shit += 1
					bullet_inst.position = boss_position + Vector2(patterning_shitty_shit - patsem, patterning_shitty_shit/2 - patseh/2 + 3).normalized()*90
					bullet_inst.pattern_transfered = (bullet_inst.position - boss_position).normalized()
					bullet_inst.rot_angle = 0.003
					add_child(bullet_inst)
				elif patterning_shitty_shit >= patsem and patterning_shitty_shit < patose:
					patterning_shitty_shit += 1
					bullet_inst.position = boss_position + Vector2(patose - patterning_shitty_shit, patterning_shitty_shit/2 - patsem/2 + 3).normalized()*90
					bullet_inst.pattern_transfered = (bullet_inst.position - boss_position).normalized()
					bullet_inst.rot_angle = -0.003
					add_child(bullet_inst)
					
					
				elif patterning_shitty_shit >= patose:
					
					Events.emit_signal("attack_finished")
					patterning_shitty_shit = 0
					change_pattern(6)
					Events.attack_currently_active = false








func change_pattern(pattern):
	current_pattern = pattern + 1



func react_to_boss_hit():
	var power_up_inst = powerup_prld.instantiate()
	power_up_inst.position = Events.boss_position
	add_child(power_up_inst)
