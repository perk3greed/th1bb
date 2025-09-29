extends Node2D

var life_long : float
var pattern_snapshot : Vector2
var pattern_transfered : Vector2
var boss_snapshot
var bullet_speed : float
var patter_real : Vector2
var reflect : bool
var rot_angle : float
var bouncecount : int
signal player_hit_by_bullet 
var wrld_boundarie_left : int
var wrld_boundarie_right : int
var wrld_boundarie_top : int

func _ready() -> void:
	
	boss_snapshot = Events.current_boss
	pattern_snapshot = Events.current_pattern
	
	patter_real = pattern_transfered
	wrld_boundarie_left = Events.world_boundaries[0]
	wrld_boundarie_right = Events.world_boundaries[1]
	wrld_boundarie_top = Events.world_boundaries[2]

func _physics_process(delta: float) -> void:
	
	if self.position.x >= wrld_boundarie_right or self.position.x <=wrld_boundarie_left:
		patter_real.x = -patter_real.x
		bouncecount += 1
		check_bounce()
	if position.y <= wrld_boundarie_top:
		patter_real.y = -patter_real.y
		bouncecount += 1
		check_bounce()
	self.position += patter_real*bullet_speed
	
	

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


func check_bounce():
	if bouncecount >= 2:
		queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("reflector"):
		patter_real = (position - Events.player_position).normalized()
		bullet_speed = bullet_speed*3
		Events.emit_signal("bullet_reflected")
