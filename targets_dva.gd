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

signal fourth_aoe_finished
signal attack_finished
signal secondary_attack_finished

func _ready() -> void:
	Events.connect("boss_secondary_attack", change_pattern)

func _process(delta: float) -> void:
	
	if Events.pos_changing == true:
		return
	
	match current_pattern : 

		1:
			Events.second_attack_active = true
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
					Events.emit_signal("secondary_attack_finished")
					Events.second_attack_active = false


func change_pattern(pattern):
	current_pattern = pattern + 1
