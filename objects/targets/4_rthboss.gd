extends Node2D


var health_points : float = 10
var modulated_timer : float = 0
var modulated_state : bool = false
var this_boss_patter : Vector2 
var current_position : int = 0
var pos_changed : bool = true
var snapshot_position : Vector2 
var pos_change_timer : int = 0
var boss_internal_timer : float = 0
var amount_of_aoue_attacks : int 

var rng = RandomNumberGenerator.new()


signal target_hit
signal boss1testkilled
signal boss_attack


func _ready() -> void:
	#Events.connect("third_boss_attack_finished", change_position)
	$Timer.start(2)
	#Events.connect("fourth_aoe_finished", change_position)



			#X		Y
var boss_movement_grid : Dictionary = {
	0 : Vector2(700,400),
	1 : Vector2(501,150),
	2 : Vector2(200,400),
	3 : Vector2(499,150),
	4 : Vector2(700,300),
	5 : Vector2(501,150),
	6 : Vector2(200,300)
}

func change_position():
		amount_of_aoue_attacks = 0
		snapshot_position = position
		pos_changed = false
		if current_position < 6:
			current_position += 1
		else :
			current_position = 0
		



func _on_timer_timeout() -> void:
	Events.emit_signal("boss_attack", 4)
	if amount_of_aoue_attacks < 4:
		amount_of_aoue_attacks += 1
		$Timer.start()
	elif amount_of_aoue_attacks == 4 :
		change_position()
	


func _process(delta: float) -> void:
	var pos_change_max : int = 30
	if pos_changed == false:
		
		var new_position = boss_movement_grid[current_position]
		position += (new_position - snapshot_position)/pos_change_max
		pos_change_timer += 1
		if pos_change_timer >= pos_change_max:
			$Area2D.set_deferred("monitorable", true)
			$Area2D.set_deferred("monitoring", true)
			if current_position%2 == 1:
				print("even", "curpos =", current_position)
				$Timer.start()
				Events.emit_signal("boss_attack",4)
			else:
				$Timer.stop()
				Events.emit_signal("boss_attack",3)
			
			pos_changed = true
			pos_change_timer = 0
	
	Events.boss_position = position
	if modulated_state == true:
		
		modulated_timer += 1*delta
		if modulated_timer >= 0.3:
			modulated_state == false
			$Sprite2D.modulate = Color(0,0,0)
			


func _on_area_2d_body_entered(body: Node2D) -> void:
	if pos_changed == false:
		return
		
	
	if body.is_in_group("ball"):
		var ball_charge = Events.ball_charge
		if ball_charge < 4:
			health_points -= 1/ball_charge
			$Sprite2D.modulate = Color(15,225,55)
			modulated_state = true
			modulated_timer = 0
			Events.boss_hp = health_points
			Events.emit_signal("target_hit")
			change_position()
			$Area2D.set_deferred("monitorable", false)
			$Area2D.set_deferred("monitoring", false)
			
			
			if health_points <= 0:
				Events.emit_signal("boss1testkilled")
				self.queue_free()
			
