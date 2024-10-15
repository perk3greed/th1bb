extends Node2D

var bullet_timer : float = 1 
var bullet_projectile := preload("res://objects/bullet_default.tscn")
var bullet_timing : float
var rng = RandomNumberGenerator.new()
var bullet_counter : float
var current_pattern : int 
var patterning_shitty_shit : int

var boss3_pattern_arrey : Array = [Vector2(15,5),Vector2(10,5),Vector2(5,5),Vector2(0,5),Vector2(-5,5),Vector2(-10,5),Vector2(-15,5)]


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
				bullet_inst.position = Events.boss_position
				bullet_counter = 0
				bullet_inst.bullet_speed = 5
				add_child(bullet_inst)

		3:
			bullet_counter += 10*delta
			if bullet_counter >= bullet_timer:
				var bullet_inst = bullet_projectile.instantiate()
				var random_deviation = rng.randi_range(1,3)
				
				bullet_inst.bullet_speed = 4
				bullet_inst.position = Vector2(100,200)
				bullet_counter = 0
				if patterning_shitty_shit < 6:
					patterning_shitty_shit += 1
					bullet_inst.pattern_transfered = boss3_pattern_arrey[patterning_shitty_shit].normalized()
					add_child(bullet_inst)
				elif patterning_shitty_shit >= 6 and patterning_shitty_shit < 36 :
					patterning_shitty_shit += 1
				elif patterning_shitty_shit >= 36:
					Events.emit_signal("third_boss_attack_finished")
					patterning_shitty_shit = 0
				
	print(patterning_shitty_shit)

func change_pattern(pattern):
	current_pattern = pattern + 1
