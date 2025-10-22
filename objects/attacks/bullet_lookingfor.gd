extends Node2D

var life_long : float
var pattern_snapshot : Vector2
var pattern_transfered : Vector2
var boss_snapshot
var bullet_speed : float
var patter_real : Vector2
var reflect : bool
var was_hit_by_player : bool
var normalization : int = 38
var start_following : bool = false
var rng = RandomNumberGenerator.new()
var rng_vector : Vector2


signal player_hit_by_bullet 

func _ready() -> void:
	
	boss_snapshot = Events.current_boss
	pattern_snapshot = Events.current_pattern
	
	match boss_snapshot:
		1:
			print("i am rarted frfr")
		2:
			patter_real = pattern_snapshot
		5: 
			normalization = 36
			rng_vector = Vector2(randi_range(-100,100),randi_range(-100,100))



func _physics_process(delta: float) -> void:
	
	if was_hit_by_player == true:
		pattern_transfered = ( Events.boss_position - position).normalized()
	elif was_hit_by_player == false and boss_snapshot == 6:
		pattern_transfered += (Events.player_position - position).normalized()/normalization
	
	elif was_hit_by_player == false and start_following == true:
		pattern_transfered += (Events.player_position - position + rng_vector).normalized()/normalization
	
	
	self.position += pattern_transfered*bullet_speed
	
	if position.y > 600:
		self.queue_free()
	

func _process(delta: float) -> void:
	life_long += 1*delta
	if life_long >= 0.4 and boss_snapshot == 5:
		start_following = true
	elif life_long >= 12:
		self.queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Events.emit_signal("player_hit_by_bullet")
	if body.is_in_group("ball"):
		if Events.ball_killing_bullets == true:
			self.queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("reflector"):
		patter_real = (position - Events.player_position ).normalized()
		bullet_speed = bullet_speed*3
		was_hit_by_player = true
		Events.emit_signal("bullet_reflected")

	if area.is_in_group("boss"):
		if was_hit_by_player == true:
			self.queue_free()
