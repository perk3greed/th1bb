extends Node2D


var reached_left_border : bool = true
var reached_right_border : bool = false
var health_points : int = 10
var modulated_timer : float = 0
var modulated_state : bool = false
var impulse : Vector2 
var center_screen : Vector2 = Vector2(660,430)

signal target_hit
signal boss1testkilled


func _process(delta: float) -> void:
	Events.boss_position = position
	
	center_screen.x = 450 + (720 - Events.player_position.x)/4
	center_screen.y = 360 + (450 - Events.ball_position.y)/10
	if modulated_state == true:
		position += impulse/80
		impulse -= impulse/24
		modulated_timer += 1*delta
		if modulated_timer >= 1.6:
			modulated_state = false
			$Sprite2D.modulate = Color(1,1,1)
	position += (center_screen - position).normalized()*2
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		if modulated_state == false:
			health_points -= 1
			impulse = body.linear_velocity
			$Sprite2D.modulate = Color(0.9,0,0.8,0.4)
			modulated_state = true
			modulated_timer = 0
			Events.boss_hp = health_points
			Events.emit_signal("target_hit")
			if health_points <= 0:
				Events.emit_signal("boss1testkilled")
				self.queue_free()


func _on_attacktime_timeout() -> void:
	Events.emit_signal("boss_attack",14)
