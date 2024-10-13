extends Node2D

var bullet_timer : float = 1 
var bullet_projectile := preload("res://objects/bullet_default.tscn")
var bullet_timing : float
var rng = RandomNumberGenerator.new()
var bullet_counter : float


func _process(delta: float) -> void:
	
	bullet_counter += 1*delta
	
	if bullet_counter >= bullet_timer:
		var bullet_inst = bullet_projectile.instantiate()
		var random_deviation = rng.randi_range(1,3)
		add_child(bullet_inst)
		bullet_inst.position = Events.boss_position
		bullet_counter = 0
