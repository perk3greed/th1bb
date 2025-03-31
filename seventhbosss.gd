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
var rot_angle_one : float = 0.017
var rot_angle_two : float = -0.01
var reverse_up : bool
var reverse_side : bool
var direction : Vector2
var boss_speed : float

signal target_hit
signal boss1testkilled
signal boss_attack
signal plot_points_on_the_graph


func _ready() -> void:
	Events.connect("fourth_aoe_finished", change_position)
	$Timer.start()

func change_position():
	#if Events.attack_currently_active == true:
		#pos_change_in_que = true
		#return
	#pos_change_in_que = false
	pos_changed = false



func _on_timer_timeout() -> void:
	if rng.randi()%2 == 0:
		if Events.attack_currently_active == true:
			return
		Events.emit_signal("boss_attack", 10)
	else :
		if Events.attack_currently_active == true:
			return
		Events.emit_signal("boss_attack", 12)

	


func _process(delta: float) -> void:
	if Events.attack_currently_active == false and pos_change_in_que == true:
		
		change_position()
	
	$right.position = $right.position.rotated(rot_angle_one)
	$Area2D/right.position = $Area2D/right.position.rotated(rot_angle_one)
	Events.boss_righ_position = $Area2D/right.position + position
	
	$left.position = $left.position.rotated(rot_angle_two)
	$Area2D/left.position = $Area2D/left.position.rotated(rot_angle_two)
	Events.boss_left_position = $Area2D/left.position + position
	
	
	var pos_change_max : int = 120
	
	position += (Events.boss_left_position - Events.boss_righ_position)/180
	
	if position.y < 150:
		position.y += (150 - position.y)/10
	if position.y > 400:
		position.y += (400 - position.y)/10
	if position.x < 350:
		position.x += (350 - position.x)/10
	if position.y > 450:
		position.x += (450 - position.x)/10
			
			
		
	pos_change_timer += 1
	if pos_change_timer >= pos_change_max:
		
		reverse_up = false
		reverse_up = false
		
		pos_changed = true
		Events.pos_changing = false
		pos_change_timer = 0

	Events.boss_position = position
	if modulated_state == true:
		
		modulated_timer += 1*delta
		if modulated_timer >= 0.3:
			modulated_state == false
			$Sprite2D.modulate = Color(1,1,1)
			$Area2D.set_deferred("monitorable", true)
			$Area2D.set_deferred("monitoring", true)


func _on_area_2d_body_entered(body: Node2D) -> void:

	if body.is_in_group("ball"):
		var ball_charge = Events.ball_charge
		if ball_charge < 4:
			health_points -= 1/ball_charge
			$Sprite2D.modulate = Color(0.1,0.1,0.8)
			modulated_state = true
			modulated_timer = 0
			Events.boss_hp = health_points
			Events.emit_signal("target_hit")
			$Area2D.set_deferred("monitorable", false)
			$Area2D.set_deferred("monitoring", false)
			change_position()
			
			if health_points <= 0:
				Events.emit_signal("boss1testkilled")
				self.queue_free()
			
