extends Node2D


var health_points : float = 26
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
signal plot_points_on_the_graph


func _ready() -> void:
	Events.connect("fourth_aoe_finished", change_position)
	$Timer.start()

func change_position():
	if Events.attack_currently_active == true:
		pos_change_in_que = true
		return
	
	player_snapshot_pos = Events.player_position + Vector2(0,-450) + Vector2(rng.randi_range(-200,200),rng.randi_range(0,150))
	if player_snapshot_pos.x > 900:
		player_snapshot_pos.x = rng.randi_range(300,700)
	elif player_snapshot_pos.x < 300:
		player_snapshot_pos.x = rng.randi_range(300,700)
	if player_snapshot_pos.x > 650:
		play_snap_mir = player_snapshot_pos - Vector2(650,0)
	elif player_snapshot_pos.x <= 650:
		play_snap_mir = player_snapshot_pos + Vector2(650,0)
	
	
	amount_of_aoue_attacks = 0
	snapshot_position = position + Vector2(rng.randi_range(-50,50),rng.randi_range(0,100))
	pos_change_in_que = false
	pos_changed = false
	


func _on_timer_timeout() -> void:
	if rng.randi()%2 == 0:
		if Events.attack_currently_active == true:
			return
		Events.emit_signal("boss_attack", 11)
	else :
		if Events.attack_currently_active == true:
			return
		Events.emit_signal("boss_attack", 11)
	if amount_of_aoue_attacks < 2:
		amount_of_aoue_attacks += 1
		$Timer.start()
	elif amount_of_aoue_attacks == 2 :
		
		change_position()
	


func _process(delta: float) -> void:
	if Events.attack_currently_active == false and pos_change_in_que == true:
		
		change_position()
	
	var pos_change_max : int = 120
	if pos_changed == false:
		modulate = Color(0.8,0.8,1,0.5)

		Events.pos_changing = true
		position = position.cubic_interpolate(player_snapshot_pos, snapshot_position - Vector2(0,300) ,play_snap_mir, pos_change_timer/150)
		pos_change_timer += 1
		if pos_change_timer >= pos_change_max:
			$Area2D.set_deferred("monitorable", true)
			$Area2D.set_deferred("monitoring", true)
			
			modulate = Color(1,1,1,1)
			pos_changed = true
			Events.pos_changing = false
			pos_change_timer = 0

	Events.boss_position = position
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if pos_changed == false:
		return
		
	
	if body.is_in_group("ball"):
		var ball_charge = Events.ball_charge
		if ball_charge < 4:
			health_points -= 4-ball_charge
			modulate = Color(0.1,0.1,0.8,0.8)
			$modulator.start()
			Events.boss_hp = health_points
			Events.emit_signal("target_hit")
			$Area2D.set_deferred("monitorable", false)
			$Area2D.set_deferred("monitoring", false)
			change_position()
			
			if health_points <= 0:
				Events.emit_signal("boss1testkilled")
				self.queue_free()
			


func _on_modulator_timeout() -> void:
	modulate = Color(1,1,1,1)
	$Area2D.set_deferred("monitorable", true)
	$Area2D.set_deferred("monitoring", true)
			
