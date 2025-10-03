extends Node2D


var health_points : int = 30
var modulated_timer : float = 0
var modulated_state : bool = false
var snapshot_position : Vector2 
var boss_internal_timer : float = 0
var amount_attacks : int 
var current_attack : String
var current_phaze : int = 1 
var phaze_changed : bool = true
var health_threshlod : int = 25
var invul_state : bool = false

var rng = RandomNumberGenerator.new()


signal target_hit
signal boss1testkilled
signal boss_attack
signal clear_attack


func _ready() -> void:
	Events.boss_fight_faze = 1
	Events.connect("attack_finished", phaze_change)



func _process(delta: float) -> void:
	
	Events.boss_position = position
	if modulated_state == true:
		if invul_state == true:
			return
		else:
			modulated_timer += 1*delta
			if modulated_timer >= 0.8:
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
				if health_points < health_threshlod:
					phaze_changed = false
					
					
			if health_points <= 0:
				Events.emit_signal("boss1testkilled")
				self.queue_free()
			


func phaze_change():
	if phaze_changed == false:
		$atack_start_timer.stop()
		$"rotating attack timer".start()
		invul_state = true


func close_phase_change():
	$atack_start_timer.start()
	$"rotating attack timer".stop()
	phaze_changed = true
	current_phaze += 1
	Events.boss_fight_faze = current_phaze
	amount_attacks = 0
	Events.emit_signal("clear_attack")
	invul_state = false
	health_threshlod -= 5



func _on_atack_start_timer_timeout() -> void:
	if rng.randi()%2 == 0:
		Events.emit_signal("boss_attack", "8th boss spinning lazer attack topdown")
	else:
		Events.emit_signal("boss_attack", "8th boss spinning lazer attack ")



func _on_rotating_attack_timer_timeout() -> void:
	amount_attacks += 1
	if amount_attacks < 7:
		Events.emit_signal("boss_attack","8thboss_rotatuing in the middle attack")
	if amount_attacks > 7:
		close_phase_change()
	


func _on_phaze_await_timeout() -> void:
	phaze_change()
