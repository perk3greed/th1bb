extends Node2D


var health_points : float = 12
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
const rot_angle_two_defolt : float = -0.01
const rot_angle_one_defolt : float = 0.017 
var rot_angle_one : float = 0.017
var rot_angle_two : float = -0.01
var reverse_up : bool
var reverse_side : bool
var direction : Vector2
var boss_speed : float
var boss_fight_faze : int = 1
var faze_changing_timer : float
var faze_changing : bool = false
const screen_center : Vector2 = Vector2(640,270)
var distance_from_center : float


signal target_hit
signal boss1testkilled
signal boss_attack
signal plot_points_on_the_graph


func _ready() -> void:
	Events.connect("attack_finished",react)
	$Timer.start()
	Events.boss_fight_faze = boss_fight_faze


func react():
	if health_points < 12 and boss_fight_faze < 2:
		boss_fight_faze = 2
		change_faze(boss_fight_faze)
	elif health_points < 7 and boss_fight_faze < 3: 
		boss_fight_faze = 3
		change_faze(boss_fight_faze)
	elif health_points < 4 and boss_fight_faze < 4:
		boss_fight_faze = 4
		change_faze(boss_fight_faze)


func change_faze(boss_faze):
	faze_changing = true
	rot_angle_one = rot_angle_one_defolt*(-1**boss_faze)*boss_fight_faze
	rot_angle_two = rot_angle_two_defolt*(-1**boss_faze)*boss_fight_faze
	$Area2D.set_deferred("monitorable", false)
	$Area2D.set_deferred("monitoring", false)
	
	Events.boss_fight_faze = boss_fight_faze



func _on_timer_timeout() -> void:
	if faze_changing == true:
		return
	
	if rng.randi()%2 == 0:
		if Events.attack_currently_active == true:
			return
		Events.emit_signal("boss_attack", 12)
	else :
		if Events.attack_currently_active == true:
			return
		Events.emit_signal("boss_attack", 13)

	


func _process(delta: float) -> void:
	
	distance_from_center = (position.x - screen_center.x)**2 + (position.y - screen_center.y)**2
	
	
	if faze_changing == false:
		$right.position = $right.position.rotated(rot_angle_one)
		$Area2D/right.position = $Area2D/right.position.rotated(rot_angle_one)
		
		$left.position = $left.position.rotated(rot_angle_two)
		$Area2D/left.position = $Area2D/left.position.rotated(rot_angle_two)
		position += (Events.boss_left_position - Events.boss_righ_position)/90
		if distance_from_center > 25000:
			position += (screen_center - position)/60
	
	
	Events.boss_position = position
	
	if modulated_state == true:
		
		modulated_timer += 1*delta
		if modulated_timer >= 1:
			modulated_state == false
			modulated_timer = 0
			$Sprite2D.modulate = Color(1,1,1)
			$Area2D.set_deferred("monitorable", true)
			$Area2D.set_deferred("monitoring", true)
	
	if faze_changing == true:
		faze_changing_timer += 1*delta
		$Sprite2D.rotate(delta*PI*boss_fight_faze*2/5)
		$right.position = $right.position.rotated(rot_angle_one*boss_fight_faze)
		$Area2D/right.position = $Area2D/right.position.rotated(rot_angle_one*boss_fight_faze)
		$left.position = $left.position.rotated(rot_angle_two*boss_fight_faze)
		$Area2D/left.position = $Area2D/left.position.rotated(rot_angle_two*boss_fight_faze)
		position += (Events.boss_left_position - Events.boss_righ_position)/240
		if distance_from_center > 30000:
			position += (screen_center - position)/60
		
		
		var glob_rot = $Sprite2D.global_rotation/PI
		
		if glob_rot <= 0:
			glob_rot = -glob_rot
		
		$right.modulate = Color(glob_rot,1 - glob_rot, 3 - glob_rot*3)
		$left.modulate = Color(1 - glob_rot, 5 - glob_rot*5 ,glob_rot)
		
		if faze_changing_timer >= 5:
			faze_changing = false
			faze_changing_timer = 0
			$Area2D.set_deferred("monitorable", true)
			$Area2D.set_deferred("monitoring", true)
			$Sprite2D.modulate = Color(1,1,1)
			
		
		
	
	
	Events.boss_righ_position = $Area2D/right.position + position
	Events.boss_left_position = $Area2D/left.position + position
	



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
			if health_points <= 0:
				Events.emit_signal("boss1testkilled")
				self.queue_free()
			
