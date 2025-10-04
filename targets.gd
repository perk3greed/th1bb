extends Node2D

const bullet_timer : float = 1 
var bullet_projectile := preload("res://objects/attacks/bullet_default.tscn")
var bullet_timing : float
var rng = RandomNumberGenerator.new()
var bullet_counter : float
var current_pattern : String 
var patterning_shitty_shit : int
var boss_position : Vector2 
var powerup_prld := preload("res://objects/pick_ups/power_up.tscn")
var reflect_bullet := preload("res://objects/attacks/bullet_reflective.tscn")
var tracking_bullet := preload("res://objects/attacks/bullet_lookingfor.tscn")
var circling_bullet := preload("res://objects/attacks/bullet_circling.tscn")
var bullet_spinned := preload("res://objects/attacks/bullet_spinned.tscn")
var big_ball := preload("res://objects/attacks/big_ball.tscn")
var lazer_atk := preload("res://objects/attacks/lazer.tscn")
var small_lazer := preload("res://objects/attacks/small_lazer.tscn")
var wrld_boundaries_x_right : int
var wrld_boundaries_x_left : int
var wrld_boundaries_x_top : int
var attack_cycle : int = 0
var attack_giga_cycle : int = 0
var player_snapshot : bool = false
var player_position = Vector2(0,0)
var amount_of_bullets : int = 0 
var await_timer : float
var pause_attack : bool = false


const spiral_positions : Array = [Vector2(400,100), Vector2(-400,100),Vector2(0,150),
 Vector2(300,200),Vector2(-300,200), Vector2(0,175),Vector2(200,250), Vector2(-200,275),
Vector2(0,235),Vector2(0,0)]
	
	
	

signal fourth_aoe_finished
signal attack_finished
signal big_ball_sent
signal await_finished


var boss3_pattern_arrey : Array = [Vector2(15,5),Vector2(10,5),Vector2(5,5),Vector2(0,5),Vector2(-5,5),Vector2(-10,5),Vector2(-15,5)]

var boos4_pattern_arrey : Array = [Vector2(-20,5),Vector2(-18,5),Vector2(-16,5),Vector2(-14,5),Vector2(-12,5),Vector2(-10,5),Vector2(-8,5),Vector2(-6,5),Vector2(-4,5),Vector2(-2,5), Vector2( 0, 5), Vector2( 2, 5)]


func _ready() -> void:
	#Events.connect("spawn_boss", change_pattern)
	Events.connect("boss_attack", change_pattern)
	Events.connect("target_hit", react_to_boss_hit)
	Events.connect("clear_attack", clear_the_scene)


func _process(delta: float) -> void:
	
	if Events.pos_changing == true:
		return
	
	match current_pattern : 
		
		"zero":
			wrld_boundaries_x_right = Events.world_boundaries[1] 
			wrld_boundaries_x_left = Events.world_boundaries[0]
			wrld_boundaries_x_top = Events.world_boundaries[2]
			Events.attack_currently_active = false

		
		
		"await":
			if bullet_counter < await_timer:
				bullet_counter += 1*delta
			else:
				await_timer = 0 
				Events.attack_currently_active = false
				bullet_counter = 0 
				print("awaitedxdd")
				Events.emit_signal("await_finished") 
				change_pattern("zero")

		
		
		"pattern1":

			if patterning_shitty_shit < 36:
				patterning_shitty_shit += 1
				if patterning_shitty_shit % 6 == 0:
					var bullet_inst = bullet_projectile.instantiate()
					bullet_inst.position = Events.boss_position 
					bullet_inst.bullet_speed = 4
					bullet_inst.pattern_transfered = ( - Events.boss_position + Events.player_position).normalized()
					add_child(bullet_inst)
			elif patterning_shitty_shit >= 36 and patterning_shitty_shit < 180 :
				patterning_shitty_shit += 1
			elif patterning_shitty_shit >= 180:
				patterning_shitty_shit = 0

		"pattern2":
			Events.attack_currently_active = true
			bullet_counter += 10*delta
			if bullet_counter >= bullet_timer:
				var bullet_inst = bullet_projectile.instantiate()
				var random_deviation = rng.randi_range(1,3)
				
				bullet_inst.bullet_speed = 4
				bullet_inst.position = Events.boss_position
				bullet_counter = 0
				if patterning_shitty_shit < 18:
					patterning_shitty_shit += 1
					bullet_inst.pattern_transfered = Vector2(1,1).rotated(patterning_shitty_shit*PI/24 - PI/4).normalized() 
					add_child(bullet_inst)
				elif patterning_shitty_shit >= 18 and patterning_shitty_shit < 72 :
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= 72:
					Events.attack_currently_active = false
					patterning_shitty_shit = 0
					change_pattern("boss3 rotating poles")



		"boss3 rotating poles":
			#boss 4 rotating poles
			Events.attack_currently_active = true
			boss_position = Events.boss_position
			var bullet_inst = small_lazer.instantiate()
			bullet_inst.pattern_transfered = Vector2(1,0).normalized()
			bullet_inst.scale = Vector2(7,1)
			bullet_inst.max_life = 5
			if attack_cycle % 2 == 0:
				bullet_inst.rot_angle = 0.4
				bullet_inst.position = Vector2(240,360)
			else:
				bullet_inst.position = Vector2(1040,360)
				bullet_inst.rot_angle = -0.4
			add_child(bullet_inst)
			
			change_pattern("zero")
			attack_cycle += 1
			patterning_shitty_shit += 1*delta
			if patterning_shitty_shit > 2:
				Events.attack_currently_active = false



		"boss4 attack":
			#boss 4 attack 
			var lazer_arrays : Array = [50,100,150,250,425,370,345,250,125,350,375,400]
			var lazer_spread : int = 75
			Events.attack_currently_active = true
			
			
			for i in range(2):
				var lazer = lazer_atk.instantiate()
				lazer.bullet_speed = 4 + Events.boss_fight_faze/3
				lazer.pattern_transfered = Vector2(0,1).normalized()
				if attack_cycle >= lazer_arrays.size():
					attack_cycle = 0
				if i == 0:
					lazer.position = Vector2(350 + lazer_arrays[attack_cycle],0)
					lazer.rotate(PI/2)
					add_child(lazer)
				elif i == 1:
					lazer.position = Vector2(2350 + lazer_arrays[attack_cycle] + lazer_spread,0)
					lazer.rotate(PI/2)
					add_child(lazer)
					attack_cycle += 1
			change_pattern("zero")



		"pattern5":
			Events.attack_currently_active = true
			bullet_counter += 12*delta
			boss_position = Events.boss_position
			player_position = Events.player_position
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
					change_pattern("zero")
					Events.attack_currently_active = false




		"reflective_attackboss5":
#			reflective straight simple attack boss 5
			Events.attack_currently_active = true
			bullet_counter += 10*delta
			boss_position = Events.boss_position
			player_position = Events.player_position
			var player_mirrored =  (wrld_boundaries_x_right - wrld_boundaries_x_left)*2 - player_position.x
			var player_mira = -player_position.x + wrld_boundaries_x_left
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
					change_pattern("zero")
					Events.attack_currently_active = false


		7:
			Events.attack_currently_active = true
			bullet_counter += 12*delta
			boss_position = Events.boss_position
			player_position = Events.player_position
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
					change_pattern("zero")
					Events.attack_currently_active = false



		"sans_circling_attack":
			print("sans circlong")
			Events.attack_currently_active = true
			bullet_counter += 24*delta
			boss_position = Events.boss_position
			player_position = Events.player_position
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
				bullet_inst.rotation_point = boss_position

				bullet_counter = 0
				if patterning_shitty_shit < patone:
					patterning_shitty_shit += 1
					bullet_inst.position = boss_position + Vector2(patone-patterning_shitty_shit, patterning_shitty_shit/2 + 3).normalized()*75
					bullet_inst.pattern_transfered = (bullet_inst.position - boss_position).normalized()
					bullet_inst.rot_angle = 0.003
					bullet_inst.life_expectancy = 8
					add_child(bullet_inst)
				elif patterning_shitty_shit >= patone and patterning_shitty_shit < pattwo :
					patterning_shitty_shit += 1
					bullet_inst.position = boss_position + Vector2(patterning_shitty_shit - pattwo, patterning_shitty_shit/2 - patone/2 + 3).normalized()*75
					bullet_inst.pattern_transfered = (bullet_inst.position - boss_position).normalized()
					bullet_inst.rot_angle = 0.003
					bullet_inst.life_expectancy = 8
					add_child(bullet_inst)
					
				elif patterning_shitty_shit >= pattwo and patterning_shitty_shit < pattri :
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= pattri and patterning_shitty_shit <patfor:
					patterning_shitty_shit += 1
					bullet_inst.position = boss_position + Vector2(patfor-patterning_shitty_shit, patterning_shitty_shit/2 - pattri/2 + 3).normalized()*35
					bullet_inst.pattern_transfered = (bullet_inst.position - boss_position).normalized()
					bullet_inst.rot_angle = -0.003
					bullet_inst.life_expectancy = 8
					add_child(bullet_inst)
				elif patterning_shitty_shit >= patfor and patterning_shitty_shit <patpet:
					patterning_shitty_shit += 1
					bullet_inst.position = boss_position + Vector2(patterning_shitty_shit  - patpet, patterning_shitty_shit/2 - patfor/2 + 3).normalized()*35
					bullet_inst.pattern_transfered = (bullet_inst.position - boss_position).normalized()
					bullet_inst.rot_angle = -0.003
					bullet_inst.life_expectancy = 8
					add_child(bullet_inst)
				elif patterning_shitty_shit >= patpet and patterning_shitty_shit < patseh:
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= patseh and patterning_shitty_shit < patsem:
					patterning_shitty_shit += 1
					bullet_inst.position = boss_position + Vector2(patterning_shitty_shit - patsem, patterning_shitty_shit/2 - patseh/2 + 3).normalized()*90
					bullet_inst.pattern_transfered = (bullet_inst.position - boss_position).normalized()
					bullet_inst.rot_angle = 0.003
					bullet_inst.life_expectancy = 8
					add_child(bullet_inst)
				elif patterning_shitty_shit >= patsem and patterning_shitty_shit < patose:
					patterning_shitty_shit += 1
					bullet_inst.position = boss_position + Vector2(patose - patterning_shitty_shit, patterning_shitty_shit/2 - patsem/2 + 3).normalized()*90
					bullet_inst.pattern_transfered = (bullet_inst.position - boss_position).normalized()
					bullet_inst.rot_angle = -0.003
					bullet_inst.life_expectancy = 8
					add_child(bullet_inst)
					
					
				elif patterning_shitty_shit >= patose:
					
					patterning_shitty_shit = 0
					change_pattern("flying_pink_particles")


		"boss6_cirles_phaze_change":
		
			var patcount : int 
			Events.attack_currently_active = true
			boss_position = Events.boss_position
			player_position = Events.player_position
			var rot_ation : float
			var amount_of_repetitions : int = 0
			

			
			for i in range(37):
				var bullet_inst = circling_bullet.instantiate()
				bullet_inst.bullet_speed = 2
				rot_ation = PI/18*i 
				bullet_inst.position = boss_position+Vector2(150,200).rotated(rot_ation)
				bullet_inst.pattern_transfered = (bullet_inst.position - boss_position).normalized()
				bullet_inst.rot_angle = 0.01
				bullet_inst.life_expectancy = 4
				bullet_inst.rotation_point = boss_position 
				add_child(bullet_inst)
			
		
				if i == 36:
					change_pattern("await")
					await_timer = 2
					print("waaintgssss")



		"boss6_cirles_phaze_change_lvl2":
		
			var patcount : int 
			Events.attack_currently_active = true
			boss_position = Events.boss_position
			player_position = Events.player_position
			var rot_ation : float
			var amount_of_repetitions : int = 0
			

			
			for i in range(73):
				if i%2 == 0:
					var bullet_inst = circling_bullet.instantiate()
					bullet_inst.bullet_speed = 3
					rot_ation = PI/32*i 
					bullet_inst.position = boss_position+Vector2(300,60)+Vector2(60,40).rotated(rot_ation)
					bullet_inst.pattern_transfered = (bullet_inst.position - (boss_position+Vector2(300,60)) ).normalized()
					bullet_inst.rot_angle = 0
					bullet_inst.life_expectancy = 7
					bullet_inst.rotation_point = boss_position + Vector2(300,0)
					add_child(bullet_inst)
				else:
					var bullet_inst = circling_bullet.instantiate()
					bullet_inst.bullet_speed = 3
					rot_ation = PI/32*i 
					bullet_inst.position = boss_position+Vector2(-300,60)+Vector2(60,40).rotated(rot_ation)
					bullet_inst.pattern_transfered = (bullet_inst.position - (boss_position+Vector2(-300,60))).normalized()
					bullet_inst.rot_angle = -0
					bullet_inst.life_expectancy = 7
					bullet_inst.rotation_point = boss_position + Vector2(-300,0)
					add_child(bullet_inst)
		
				if i == 72:
					change_pattern("await")
					await_timer = 2
					print("waaintgssss")


		"boss6_cirles_phaze_change_lvl3_part1":
		
			Events.attack_currently_active = true
			boss_position = Events.boss_position
			player_position = Events.player_position
			var rot_ation : float
			
			
			if patterning_shitty_shit < 28:
				var Vector_additive = spiral_positions[bullet_counter]
				var bullet_inst = circling_bullet.instantiate()
				bullet_inst.bullet_speed = 1.8
				rot_ation = patterning_shitty_shit*PI/14
				bullet_inst.position = boss_position+Vector_additive+Vector2(20,15).rotated(rot_ation)
				bullet_inst.pattern_transfered = (bullet_inst.position - (boss_position+Vector_additive) ).normalized()
				bullet_inst.rot_angle = 0
				bullet_inst.life_expectancy = 7
				bullet_inst.rotation_point = boss_position + Vector_additive
				add_child(bullet_inst)
				patterning_shitty_shit += 1
				
			elif patterning_shitty_shit >= 28 and patterning_shitty_shit < 144:
				patterning_shitty_shit += 1
			elif patterning_shitty_shit >= 143:
				bullet_counter += 1
				patterning_shitty_shit = 0
				if bullet_counter < Events.boss_fight_faze*3 :
					change_pattern("boss6_cirles_phaze_change_lvl3_part1")
				else:
					change_pattern("await")
					await_timer = 2
					bullet_counter = 0

		





		"flying_pink_particles":
			Events.attack_currently_active = true
			bullet_counter += 12*delta
			boss_position = Events.boss_position
			var reverse : bool
			if Events.random_number_of_two == 2:
				reverse = true
			else:
				reverse = false
			player_position = Events.player_position
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
					change_pattern("zero")
					Events.emit_signal("attack_finished")
					Events.attack_currently_active = false


		10:
#			robux two headed attack
			bullet_counter += 25*delta
			var boss_position_left = Events.boss_left_position
			var boss_position_righ = Events.boss_righ_position
			Events.attack_currently_active = true
			boss_position = Events.boss_position
			player_position = Events.player_position
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
					change_pattern("zero")
					patterning_shitty_shit = 0
					Events.attack_currently_active = false
					Events.emit_signal("attack_finished")



		"rotational_all_around_attack":
			#boss pet rotatinal allaround attack 
			Events.attack_currently_active = true
			bullet_counter += 24*delta
			boss_position = Events.boss_position
			player_position = Events.player_position
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
					change_pattern("reflective_attackboss5")
					Events.attack_currently_active = false

		12:
#			robux big ball send
			Events.attack_currently_active = true
			var boss_faze = Events.boss_fight_faze
			bullet_counter += 12*delta
			boss_position = Events.boss_position
			player_position = Events.player_position
			var boss_position_left = Events.boss_left_position
			var boss_position_righ = Events.boss_righ_position
			if bullet_counter >= bullet_timer:
				var bullet_inst = big_ball.instantiate()
				bullet_inst.bullet_speed = 3+boss_faze
				bullet_counter = 0
				if patterning_shitty_shit < 30:
					patterning_shitty_shit += 1
					if patterning_shitty_shit%10 == 0:
						bullet_inst.position = boss_position_left
						bullet_inst.pattern_transfered = ((player_position-boss_position)+ Vector2(patterning_shitty_shit*3,0)).normalized()
						bullet_inst.slow_down_start = true
						add_child(bullet_inst)
					if patterning_shitty_shit%10 == 5:
						bullet_inst.position = boss_position_righ
						bullet_inst.pattern_transfered = ((player_position-boss_position)-Vector2(patterning_shitty_shit*3,0)).normalized()
						bullet_inst.slow_down_start = true
						add_child(bullet_inst)
				elif patterning_shitty_shit >= 30 and patterning_shitty_shit < 60 :
					patterning_shitty_shit += 1
					Events.emit_signal("big_ball_sent")
				elif patterning_shitty_shit >= 60:
					patterning_shitty_shit = 0
					if attack_giga_cycle == 0:
						attack_giga_cycle += 1
						change_pattern(13)
					else :
						change_pattern("zero")
						attack_giga_cycle = 0
						Events.emit_signal("attack_finished")
						Events.attack_currently_active = false



		13:
#			robux two headed circles attack
			Events.attack_currently_active = true
			bullet_counter += 24*delta
			var boss_position_cent = Events.boss_position
			var boss_position_left = Events.boss_left_position
			var boss_position_righ = Events.boss_righ_position
			player_position = Events.player_position
			
			var patone : float = 8
			var pattwo : float = 16

			var boss_faze = Events.boss_fight_faze
			if bullet_counter >= bullet_timer:
				var bullet_inst = bullet_projectile.instantiate()
				bullet_inst.bullet_speed = 4
				bullet_counter = 0
				if patterning_shitty_shit < patone:
					for i in range(5+boss_faze*2):
						bullet_inst = bullet_projectile.instantiate()
						bullet_inst.position = boss_position_righ + Vector2(patone-patterning_shitty_shit - i, (patterning_shitty_shit+i)/2 + 3).normalized()*75
						bullet_inst.pattern_transfered = (bullet_inst.position - boss_position_righ).normalized()
						bullet_inst.bullet_speed = 3 + boss_faze/4
						add_child(bullet_inst)
						if i == 3+boss_faze:
							patterning_shitty_shit = patone
							i = 0
				elif patterning_shitty_shit >= patone and patterning_shitty_shit < pattwo :
					for g in range(5+boss_faze*2):
						bullet_inst = bullet_projectile.instantiate()
						bullet_inst.position = boss_position_left + Vector2((patterning_shitty_shit+g) - pattwo, (patterning_shitty_shit+g)/2 - patone/2 + 3).normalized()*75
						bullet_inst.pattern_transfered = (bullet_inst.position - boss_position_left).normalized()
						bullet_inst.bullet_speed = 3 + boss_faze/4
						add_child(bullet_inst)
						if g == 3+boss_faze:
							patterning_shitty_shit = 0
							g = 0
							attack_cycle += 1
							if attack_cycle >= 3 + boss_faze:
								patterning_shitty_shit = 0
								attack_cycle = 0
								if attack_giga_cycle == 0:
									attack_giga_cycle += 1
									change_pattern(12)
								else :
									Events.emit_signal("attack_finished")
									change_pattern("zero")
									attack_giga_cycle = 0
									Events.attack_currently_active = false

		"tutorial_boss_attack":
			#first boss attack 
			Events.attack_currently_active = true
			
			var start_angle = 2*PI
			var real_angle 
			for i in range(6):
				var bullet_inst = bullet_projectile.instantiate()
				real_angle = i*start_angle/18
				bullet_inst.bullet_speed = 3
				bullet_inst.pattern_transfered = Vector2(1,1).rotated(real_angle).normalized()
				bullet_inst.position = Events.boss_position
				add_child(bullet_inst)

				
			Events.attack_currently_active = false
			change_pattern("zero")



		"8th boss spinning lazer attack ":
			#8th boss spinning lazer attack 
			Events.attack_currently_active = true
			attack_cycle += 1
			var start_angle = 2*PI
			var real_angle 
			for i in range(6):
				
				var bullet_inst = small_lazer.instantiate()
				real_angle = i*start_angle/18
				bullet_inst.bullet_speed = 3
				bullet_inst.pattern_transfered = Vector2(1,1).rotated(real_angle).normalized()
				bullet_inst.position = Events.boss_position
				if attack_cycle % 2 == 0:
					bullet_inst.rot_angle = 1
				else:
					bullet_inst.rot_angle = -1
				add_child(bullet_inst)
				
			Events.attack_currently_active = false
			if Events.boss_fight_faze == 1:
				change_pattern("zero")
				Events.emit_signal("attack_finished")
			else:
				change_pattern("8th boss spinning lazer attack additional")


		"8th boss spinning lazer attack additional":
			#8th boss spinning lazer attack additional
			
			Events.attack_currently_active = true
			attack_cycle += 1
			var start_angle = 2*PI
			var real_angle 
			for i in range(3):
				
				var bullet_inst = small_lazer.instantiate()
				bullet_inst.bullet_speed = 4
				bullet_inst.pattern_transfered = Vector2(1,0).normalized()
				bullet_inst.position = Vector2(-i*240,640)
				if attack_cycle % 2 == 0:
					bullet_inst.rot_angle = 1
				else:
					bullet_inst.rot_angle = -1
				add_child(bullet_inst)
				
			Events.attack_currently_active = false
			change_pattern("zero")
		

		"8th boss spinning lazer attack topdown":
			#8th boss spinning lazer attack topdown
			Events.attack_currently_active = true
			bullet_counter += 12*delta
			boss_position = Events.boss_position
			if player_snapshot == false:
				player_position = Events.player_position
				player_snapshot = true
			if bullet_counter >= bullet_timer:
				var bullet_inst = small_lazer.instantiate()
				bullet_inst.bullet_speed = 4
				
				bullet_counter = 0
				if patterning_shitty_shit < 9:
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= 9 and patterning_shitty_shit < 27 :
					if patterning_shitty_shit %2 == 0:
						bullet_inst.position = boss_position 
						bullet_inst.pattern_transfered = (player_position - 	boss_position).normalized()
						bullet_inst.rot_angle = 1
						add_child(bullet_inst)
					else :
						pass
					
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= 18 and patterning_shitty_shit < 72 :
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= 72:
					patterning_shitty_shit = 0
					player_snapshot = false
					change_pattern("zero")
					Events.attack_currently_active = false
					Events.emit_signal("attack_finished")




		"8thboss_rotatuing in the middle attack":
			#8thboss_rotatuing in the middle attack
			Events.attack_currently_active = true
			
			var bullet_inst = small_lazer.instantiate()
			bullet_inst.bullet_speed = 0
			bullet_inst.pattern_transfered = Vector2(0,0).normalized()
			var posittionelle : Vector2 = Vector2((Events.world_boundaries[1] - Events.world_boundaries[0])/2 + Events.world_boundaries[0 ], (Events.world_boundaries[3] - Events.world_boundaries[2])/2 + Events.world_boundaries[2])
			bullet_inst.position = Vector2(posittionelle)
			if attack_cycle % 2 == 0:
				bullet_inst.rot_angle = Events.boss_fight_faze*0.1
			else:
				bullet_inst.rot_angle = -Events.boss_fight_faze*0.1
			bullet_inst.set_scale(Vector2(8,2))
			add_child(bullet_inst)

			Events.attack_currently_active = false
			change_pattern("zero")
			Events.emit_signal("attack_finished")
			


		"boss4 spiral":
			
			#4rthboss_spiral 
			Events.attack_currently_active = true
			var boss_stage = Events.boss_fight_faze
			var start_angle = PI/2
			var real_angle 
			var ofset_counter : int 
			var angles_array : Array = [1,5,4,7,10,11,13,90,21,60,30,120]
			var angles_offset : Array = [1,2,3,5,7,11,13,17,19]
			var angles_offset_two : Array = [23,29,31,37,41,43,47,53,59]
			var angles_offset_electr_boogalu : Array = [5,15,25,45,40,35,30,15,55]
			if patterning_shitty_shit % 3 == 0 and patterning_shitty_shit < (60 + 25*boss_stage) :
				var bullet_inst = reflect_bullet.instantiate()
				if ofset_counter < angles_offset.size():
					ofset_counter += 1
				else:
					ofset_counter = 0
					#angles_offset[ofset_counter]
				real_angle = patterning_shitty_shit*start_angle/angles_array[boss_stage]
				bullet_inst.bullet_speed = 2.5
				bullet_inst.pattern_transfered = Vector2(1,1).rotated(real_angle).normalized()
				bullet_inst.position = Events.boss_position + Vector2(0,150)
				add_child(bullet_inst)
				amount_of_bullets += 1 

			patterning_shitty_shit += 1
			
			if patterning_shitty_shit >= 900:
				Events.attack_currently_active = false
				change_pattern("zero")
				patterning_shitty_shit = 0
				amount_of_bullets = 0
				Events.emit_signal("attack_finished")








		
func change_pattern(pattern):
	current_pattern = pattern
	print(current_pattern)
	print(Events.boss_fight_faze)


func react_to_boss_hit():
	var power_up_inst = powerup_prld.instantiate()
	power_up_inst.position = Events.boss_position
	add_child(power_up_inst)

func clear_the_scene():
	for i in self.get_child_count():
		var child_delited = self.get_child(i)
		child_delited.queue_free()
		change_pattern("zero")


func _on_attack_timer_length_timeout() -> void:
	pass # Replace with function body.
