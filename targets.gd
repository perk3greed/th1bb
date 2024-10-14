extends Node2D

var bullet_timer : float = 1 
var bullet_projectile := preload("res://objects/bullet_default.tscn")
var bullet_timing : float
var rng = RandomNumberGenerator.new()
var bullet_counter : float
var current_pattern : int 
var patterning_shitty_shit : int


func _ready() -> void:
	Events.connect("spawn_boss", change_pattern)



func _process(delta: float) -> void:
	
	match current_pattern : 
		
		1:
			print("null_xd")
		
		2:
			bullet_counter += 1*delta
			if bullet_counter >= bullet_timer:
				var bullet_inst = bullet_projectile.instantiate()
				var random_deviation = rng.randi_range(1,3)
				add_child(bullet_inst)
				bullet_inst.position = Events.boss_position
				bullet_counter = 0
		3:
			bullet_counter += 1*delta
			if bullet_counter >= bullet_timer:
				var bullet_inst = bullet_projectile.instantiate()
				var random_deviation = rng.randi_range(1,3)
				add_child(bullet_inst)
				bullet_inst.position = Events.boss_position
				bullet_counter = 0
				if patterning_shitty_shit < 6:
					patterning_shitty_shit += 1
					bullet_inst.pattern_transfered = Vector2(9*patterning_shitty_shit,45).normalized()
				else :
					patterning_shitty_shit = 0



func change_pattern(pattern):
	current_pattern = pattern + 1
