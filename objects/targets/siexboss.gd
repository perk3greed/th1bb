extends Node2D


var health_points : float = 7
var modulated_timer : float = 0
var modulated_state : bool = false
var this_boss_patter : Vector2 
var current_position : int = 0
var pos_changed : bool = true
var snapshot_position : Vector2 
var pos_change_timer : float = 0
var boss_internal_timer : float = 0
var amount_of_aoue_attacks : int 
var prea : Vector2
var preb : Vector2
var prex : Vector2
var player_snapshot_pos : Vector2
var play_snap_mir : Vector2
var rng = RandomNumberGenerator.new()
var pos_change_in_que : bool

signal target_hit
signal boss1testkilled
signal boss_attack
signal boss_secondary_attack


func _ready() -> void:
	$Timer.start()
	Events.connect("attack_finished", react_to_finished_attack)
	Events.boss_position = position

func react_to_finished_attack():
	$Timer.start()




func _on_timer_timeout() -> void:
	if rng.randi()%2 == 0:
		if Events.attack_currently_active == true:
			return
		Events.emit_signal("boss_attack", 8)
		var random_place = rng.randi()%2
		if random_place == 1:
			Events.random_number_of_two = 1
		else:
			Events.random_number_of_two = 2

	else :
		if Events.attack_currently_active == true:
			return
		Events.emit_signal("boss_attack", 8)
	if amount_of_aoue_attacks < 2:
		amount_of_aoue_attacks += 1
		$Timer.start()
	elif amount_of_aoue_attacks == 2 :
		
		$Timer.start()
	


func _process(delta: float) -> void:
	
	
	
	if modulated_state == true:
		
		modulated_timer += 1*delta
		if modulated_timer >= 0.6:
			modulated_state == false
			$Sprite2D.modulate = Color(1,1,1)
			$Area2D.set_deferred("monitorable", true)
			$Area2D.set_deferred("monitoring", true)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		var ball_charge = Events.ball_charge
		if ball_charge < 4:
			health_points -= 1/ball_charge
			$Sprite2D.modulate = Color(0.1,0.1,0.1)
			modulated_state = true
			modulated_timer = 0
			Events.boss_hp = health_points
			Events.emit_signal("target_hit")
			$Area2D.set_deferred("monitorable", false)
			$Area2D.set_deferred("monitoring", false)
			
			if health_points <= 0:
				Events.emit_signal("boss1testkilled")
				self.queue_free()
			
