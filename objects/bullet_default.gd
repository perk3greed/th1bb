extends Node2D

var movement_direction : Vector2 
var life_long : float
var pattern_snapshot : Vector2

signal player_hit_by_bullet 

func _ready() -> void:
	movement_direction = Vector2(0, 3)
	pattern_snapshot = Events.current_pattern

func _physics_process(delta: float) -> void:
	self.position += pattern_snapshot*Events.bullet_speed
	

func _process(delta: float) -> void:
	life_long += 1*delta
	if life_long >= 8:
		self.queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Events.emit_signal("player_hit_by_bullet")
	if body.is_in_group("ball"):
		self.queue_free()
