extends Node2D


var health_points : float = 26
var amount_of_aoue_attacks : int 
var rng = RandomNumberGenerator.new()

var head_one_open : bool = false
var head_two_open : bool = false
var head_tri_open : bool = false
var head_for_open : bool = false
var head_fiv_open : bool = false

var phaze1pattern : Array = [1,2,3,4,5]
var current_head : int = 0
var head_positions : Array = [Vector2(-500,150),Vector2(-250,50),Vector2(0,0),Vector2(250,50),Vector2(500,150),]
var modulating : bool = false



signal target_hit
signal boss1testkilled
signal boss_attack
signal plot_points_on_the_graph


func _ready() -> void:
	$Timer.start()
	regulate_heads()
	

func regulate_heads():
	
	
	head_one_open = false
	head_two_open = false
	head_tri_open = false
	head_for_open = false
	head_fiv_open = false
	
	if phaze1pattern[current_head] == 1:
		head_one_open = true
	elif phaze1pattern[current_head] == 2:
		head_two_open = true
	elif phaze1pattern[current_head] == 3:
		head_tri_open = true
	elif phaze1pattern[current_head] == 4:
		head_for_open = true
	elif phaze1pattern[current_head] == 5:
		head_fiv_open = true
	

	Events.boss_position = head_positions[phaze1pattern[current_head]-1]+Vector2(625,100)





func _on_timer_timeout() -> void:
	if rng.randi()%2 == 0:
		if Events.attack_currently_active == true:
			return
		Events.emit_signal("boss_attack", "boss5_radiating_circles")
	else :
		if Events.attack_currently_active == true:
			return
		Events.emit_signal("boss_attack", "boss5_radiating_circles")
	if amount_of_aoue_attacks < 2:
		amount_of_aoue_attacks += 1
		$Timer.start()
	


func _process(delta: float) -> void:
	$head3/Label.text = str(head_tri_open)
	$head1/Label.text = str(head_one_open)
	$head5/Label.text = str(head_fiv_open)
	$head4/Label.text = str(head_for_open)
	$head2/Label.text = str(head_two_open)
	change_heads()
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if modulating == true:
		return

	if body.is_in_group("ball"):
		var ball_charge = Events.ball_charge
		if ball_charge < 4:
			health_points -= 4-ball_charge
			modulate = Color(0.102, 0.102, 0.8, 0.259)
			$modulator.start()
			modulating = true
			Events.boss_hp = health_points
			Events.emit_signal("target_hit")
			if current_head < 4:
				current_head += 1
			else :
				current_head = 0
			
			regulate_heads()
			
			if health_points <= 0:
				Events.emit_signal("boss1testkilled")
				self.queue_free()
			


func _on_modulator_timeout() -> void:
	modulate = Color(1,1,1,1)
	modulating = false




func change_heads():
	if head_one_open == true:
		$head1.monitoring = true
		$head1/Sprite2D.set_modulate(Color(1.0, 1.0, 1.0, 1.0))
	else:
		$head1.set_monitoring(false)
		$head1/Sprite2D.set_modulate(Color(0.549, 0.541, 0.518, 0.549))
	if head_two_open == true:
		$head2.monitoring = true
		$head2/Sprite2D.set_modulate(Color(1.0, 1.0, 1.0, 1.0))
	else:
		$head2.set_monitoring(false)
		$head2/Sprite2D.set_modulate(Color(0.186, 0.199, 0.717, 0.549))
	if head_tri_open == true:
		$head3.monitoring = true
		$head3/CollisionShape2D.disabled = false
		$head3/Sprite2D.set_modulate(Color(1.0, 1.0, 1.0, 1.0))
	else:
		$head3.set_monitoring(false)
		$head3/Sprite2D.set_modulate(Color(0.685, 0.325, 0.119, 0.549))
	if head_for_open == true:
		$head4.monitoring = true
		$head4/Sprite2D.set_modulate(Color(1.0, 1.0, 1.0, 1.0))
	else:
		$head4.set_monitoring(false)
		$head4/Sprite2D.set_modulate(Color(0.155, 0.355, 0.0, 0.549))
	if head_fiv_open == true:
		$head5.monitoring = true
		$head5/Sprite2D.set_modulate(Color(1.0, 1.0, 1.0, 1.0))
	else:
		$head5.set_monitoring(false)
		$head5/Sprite2D.set_modulate(Color(0.545, 0.073, 0.241, 0.549))
		
		
		
		
		
		
		


func _on_head_4_body_entered(body: Node2D) -> void:
	_on_area_2d_body_entered(body)


func _on_head_3_body_entered(body: Node2D) -> void:
	_on_area_2d_body_entered(body)
