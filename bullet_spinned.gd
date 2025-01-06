extends Node2D

var life_long : float
var pattern_snapshot : Vector2
var pattern_transfered : Vector2
var boss_snapshot
var bullet_speed : float
var patter_real : Vector2
var reflect : bool
var was_hit_by_player : bool
var pos_change_timer :float = 0

signal player_hit_by_bullet 

func _ready() -> void:
	
	boss_snapshot = Events.current_boss
	pattern_snapshot = Events.current_pattern
	
	match Events.current_boss:
		1:
			print("i am rarted frfr")
		2:
			patter_real = pattern_snapshot




func _physics_process(delta: float) -> void:
	
	if was_hit_by_player == true:
		pattern_transfered = (position - Events.player_position).normalized()
		position += pattern_transfered*bullet_speed
	
	pattern_transfered += (Events.player_position - position).normalized()/20
	position += pattern_transfered*bullet_speed
	
	if position.y > 740 :
		self.queue_free()
	

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
		patter_real = (position - Events.player_position ).normalized()
		bullet_speed = bullet_speed*3
		was_hit_by_player = true
	if area.is_in_group("boss"):
		if was_hit_by_player == true:
			self.queue_free()
