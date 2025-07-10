extends Node2D


var health_points : float = 10
var modulated_timer : float = 0
var modulated_state : bool = false
var this_boss_patter : Vector2 
var snapshot_position : Vector2 
var boss_internal_timer : float = 0
var amount_attacks : int 


var rng = RandomNumberGenerator.new()


signal target_hit
signal boss1testkilled
signal boss_attack


func _process(delta: float) -> void:
	
	Events.boss_position = position
	if modulated_state == true:
		
		modulated_timer += 1*delta
		if modulated_timer >= 0.8:
			modulated_state = false
			$Sprite2D2.modulate = Color(1,1,1,1)
			


func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("ball"):
		var ball_charge = Events.ball_charge
		if ball_charge < 4:
			if modulated_state == false:
				health_points -= 1/ball_charge
				$Sprite2D2.modulate = Color(0.7,0.3,0.5,0.3)
				modulated_state = true
				modulated_timer = 0
				Events.boss_hp = health_points
				Events.emit_signal("target_hit")

			
			
			if health_points <= 0:
				Events.emit_signal("boss1testkilled")
				self.queue_free()
			


func _on_small_attak_timer_timeout() -> void:
	if amount_attacks <= 3:
		if Events.attack_currently_active == true:
			Events.emit_signal("boss_attack", 4)
			amount_attacks += 1
	else : 
		Events.attack_currently_active = false
		amount_attacks = 0

func _on_big_attak_timer_timeout() -> void:
	Events.attack_currently_active = true
