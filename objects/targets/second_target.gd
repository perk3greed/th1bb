extends Node2D


var reached_left_border : bool = true
var reached_right_border : bool = false
var health_points : int = 28
var modulated_timer : float = 0
var modulated_state : bool = false
var this_boss_patter : Vector2 
var combat_timer : int = 15
var j : float 
var bullet_counter : float

var bullet_timer : float = 1 
var bullet_projectile := preload("res://objects/bullet_default.tscn")
var bullet_timing : float
var rng = RandomNumberGenerator.new()



signal target_hit
signal boss1testkilled


func _process(delta: float) -> void:
	if j < 1:
		j += 1*delta
	elif j >= 1:
		combat_timer += 1
		j = 0

	Events.boss_position = position
	var player_pos : Vector2 = Events.player_position
	
	var distance_to_player : Vector2 = player_pos - position
	position.x += distance_to_player.x/60
	var distance_to_ex : float = position.x - player_pos.x
	if distance_to_ex < 0:
		distance_to_ex = -distance_to_ex
	
	var y_axis_displacement : float = position.y - 210
	position.y += distance_to_ex/60 - y_axis_displacement/60
	
	Events.current_pattern = (distance_to_player - Vector2(0,100)).normalized()
	
	
	if modulated_state == true:
		
		modulated_timer += 1*delta
		if modulated_timer >= 0.5:
			modulated_state = false
			$Sprite2D.modulate = Color(1,1,1,1)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		var ball_charge = Events.ball_charge
		if ball_charge < 4:
			if modulated_state == false:
				health_points -= 4-ball_charge
				$Sprite2D.modulate = Color(0.7,0.3,0.5,0.3)
				modulated_state = true
				modulated_timer = 0
				Events.boss_hp = health_points
				Events.emit_signal("target_hit")
		
		
		
		if health_points <= 0:
			Events.emit_signal("boss1testkilled")
			self.queue_free()
		


func _on_timer_timeout() -> void:
	Events.emit_signal("boss_attack",3)
