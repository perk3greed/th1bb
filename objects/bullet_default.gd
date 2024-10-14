extends Node2D

var life_long : float
var pattern_snapshot : Vector2
var pattern_transfered : Vector2
var boss_snapshot

signal player_hit_by_bullet 

func _ready() -> void:
	boss_snapshot = Events.current_boss
	pattern_snapshot = Events.current_pattern
	print(Events.current_boss)

func _physics_process(delta: float) -> void:
	
	match Events.current_boss:
		1:
			pass
		2:
			self.position += pattern_snapshot*Events.bullet_speed
		3:
			self.position += pattern_transfered*Events.bullet_speed
		

func _process(delta: float) -> void:
	life_long += 1*delta
	if life_long >= 8:
		self.queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Events.emit_signal("player_hit_by_bullet")
	if body.is_in_group("ball"):
		self.queue_free()
