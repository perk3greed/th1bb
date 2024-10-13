extends RigidBody2D

var player_Pos : Vector2
var boss_Pos : Vector2
signal player_hit_by_ball

func _ready() -> void:
	Events.connect("attack", be_moved_by_attack)
	Events.connect("left_slide_attack", be_moved_by_left_attack)
	Events.connect("right_slide_attack", be_moved_by_right_attack)
	Events.connect("target_hit", be_moved_by_boss)


func be_moved_by_attack():
	apply_impulse(-linear_velocity)
	player_Pos = Events.player_position
	var impulse_vectorX : float = position.x - player_Pos.x
	var impulse_vectorY : float = position.y - player_Pos.y
	apply_impulse(Vector2(impulse_vectorX,impulse_vectorY).normalized()*1300)

func be_moved_by_boss():
	print("boss_hit")
	apply_impulse(-linear_velocity)
	boss_Pos = Events.boss_position
	var impulse_vectorX : float = position.x - boss_Pos.x
	var impulse_vectorY : float = position.y - boss_Pos.y
	apply_impulse(Vector2(impulse_vectorX,impulse_vectorY).normalized()*1000)

func be_moved_by_left_attack():
	apply_impulse(-linear_velocity)
	var impulse_vectorX : float = 5
	var impulse_vectorY : float = -3
	apply_impulse(Vector2(impulse_vectorX,impulse_vectorY).normalized()*1500)



func be_moved_by_right_attack():
	apply_impulse(-linear_velocity)
	var impulse_vectorX : float = -5
	var impulse_vectorY : float = -3
	apply_impulse(Vector2(impulse_vectorX,impulse_vectorY).normalized()*1500)
	


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		Events.emit_signal("player_hit_by_ball")
