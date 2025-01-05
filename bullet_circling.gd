extends Node2D

var life_long : float
var pattern_snapshot : Vector2
var pattern_transfered : Vector2
var boss_snapshot
var bullet_speed : float
var patter_real : Vector2
var reflect : bool
var rot_angle : float

signal player_hit_by_bullet 

func _ready() -> void:
	#var boss_relation : Vector2 = position - Events.boss_position 
	#if boss_relation.x > 0:
		#rot_angle = -0.002
	#else:
		#rot_angle = 0.002
	#
	
	boss_snapshot = Events.current_boss
	pattern_snapshot = Events.current_pattern
	
	match Events.current_boss:
		1:
			print("i am rarted frfr")
		2:
			patter_real = pattern_snapshot


func _physics_process(delta: float) -> void:
	
	var rotation_vector = position - Events.boss_position
	position = rotation_vector.rotated(rot_angle) + Events.boss_position
	self.position += pattern_transfered*bullet_speed 
	

func _process(delta: float) -> void:
	life_long += 1*delta
	if life_long >= 12:
		self.queue_free()
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Events.emit_signal("player_hit_by_bullet")
	if body.is_in_group("ball"):
		if Events.ball_killing_bullets == true:
			self.queue_free()




func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("attack"):
		pattern_transfered = (position - Events.player_position).normalized()
		bullet_speed = bullet_speed*3
