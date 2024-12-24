extends Node2D

var bullet_timer : float = 1 
var bullet_projectile := preload("res://objects/bullet_default.tscn")
var bullet_timing : float
var rng = RandomNumberGenerator.new()
var bullet_counter : float
var current_pattern : int 
var patterning_shitty_shit : int
var boss_position : Vector2 
var bullet_position : Vector2
var powerup_prld := preload("res://objects/pick ups/power_up.tscn")

signal fourth_aoe_finished


var boss3_pattern_arrey : Array = [Vector2(15,5),Vector2(10,5),Vector2(5,5),Vector2(0,5),Vector2(-5,5),Vector2(-10,5),Vector2(-15,5)]

var boos4_pattern_arrey : Array = [Vector2(-20,5),Vector2(-18,5),Vector2(-16,5),Vector2(-14,5),Vector2(-12,5),Vector2(-10,5),Vector2(-8,5),Vector2(-6,5),Vector2(-4,5),Vector2(-2,5), Vector2( 0, 5), Vector2( 2, 5)]


func _ready() -> void:
	Events.connect("spawn_boss", change_pattern)
	Events.connect( "boss_attack", change_pattern)
	Events.connect("target_hit", react_to_boss_hit)


func _process(delta: float) -> void:
	
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
						bullet_inst.position = Vector2(--200,100) + Vector2(patterning_shitty_shit*75,0)
						bullet_inst.pattern_transfered = Vector2(patterning_shitty_shit,15).normalized()
					add_child(bullet_inst)
				elif patterning_shitty_shit >= 9 and patterning_shitty_shit < 27 :
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= 27:
					patterning_shitty_shit = 0
					change_pattern(0)
					Events.emit_signal("fourth_aoe_finished")


func change_pattern(pattern):
	current_pattern = pattern + 1



func react_to_boss_hit():
	var power_up_inst = powerup_prld.instantiate()
	power_up_inst.position = Events.boss_position
	add_child(power_up_inst)
