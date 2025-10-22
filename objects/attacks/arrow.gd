extends Node2D

var life_long : float
var pattern_snapshot : Vector2
var pattern_transfered : Vector2
var boss_snapshot
var bullet_speed : float
var patter_real : Vector2
var reflect : bool
var rot_angle : float
var set_gooo : bool = false



signal player_hit_by_bullet 
signal bullet_reflected 


func _ready() -> void:
	
	
	boss_snapshot = Events.current_boss
	pattern_snapshot = Events.current_pattern
	



func _physics_process(delta: float) -> void:
	if set_gooo == true:
		self.position += pattern_transfered*bullet_speed 
	
	bullet_speed = life_long*life_long*2

func _process(delta: float) -> void:
	life_long += 1*delta
	
	if life_long >= 2:
		set_gooo = true
	
	if life_long >= 12:
		self.queue_free()
	




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Events.emit_signal("player_hit_by_bullet")
	if body.is_in_group("ball"):
		if Events.ball_killing_bullets == true:
			self.queue_free()
