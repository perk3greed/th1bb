extends Node2D

var life_long : float
var pattern_snapshot : Vector2
var pattern_transfered : Vector2
var boss_snapshot
var bullet_speed : float
var patter_real : Vector2
var reflect : bool


signal player_hit_by_bullet 

func _ready() -> void:
	
	boss_snapshot = Events.current_boss
	pattern_snapshot = Events.current_pattern
	
	match Events.current_boss:
		1:
			print("i am rarted frfr")
		2:
			patter_real = pattern_snapshot
		3:
			patter_real = pattern_transfered
			
		4:
			patter_real = pattern_transfered
		5:
			patter_real = pattern_transfered


func _physics_process(delta: float) -> void:
	
	self.position += patter_real*bullet_speed
	
	

func _process(delta: float) -> void:
	life_long += 1*delta
	if life_long >= 8:
		self.queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Events.emit_signal("player_hit_by_bullet")
	if body.is_in_group("ball"):
		self.queue_free()




func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("attack"):
		patter_real = (position - Events.player_position).normalized()
		bullet_speed = bullet_speed*3
