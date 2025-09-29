extends Node2D


var health_points : int = 10
var modulated_timer : float = 0
var modulated_state : bool = false
var this_boss_patter : Vector2 
var current_position : int = 0
var pos_changed : bool = true
var snapshot_position : Vector2 
var pos_change_timer : int = 0



var rng = RandomNumberGenerator.new()

var boss_movement_grid : Dictionary = {
	0 : Vector2(200,200),
	1 : Vector2(600,400),
	2 : Vector2(600,300),
	3 : Vector2(200,500),
	4 : Vector2(700,200),
	5 : Vector2(300,300),
}

signal target_hit
signal boss1testkilled


func _ready() -> void:
	Events.connect("third_boss_attack_finished", change_position)

func change_position():
	snapshot_position = position
	pos_changed = false
	if current_position < 3:
		current_position += 1
	else :
		current_position = 0


func _process(delta: float) -> void:
	print($Area2D.monitorable)
	var pos_change_max : int = 30
	if pos_changed == false:
		
		var new_position = boss_movement_grid[current_position]
		position += (new_position - snapshot_position)/pos_change_max
		pos_change_timer += 1
		if pos_change_timer >= pos_change_max:
			pos_changed = true
			pos_change_timer = 0
		

	Events.boss_position = position
	
	
	
	if modulated_state == true:
		
		modulated_timer += 1*delta
		if modulated_timer >= 1.3:
			modulated_state = false
			$Sprite2D.modulate = Color(1,1,1,1)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if  pos_changed == false:
		return
		
	
	if body.is_in_group("ball"):
		if modulated_state == false:
			health_points -= 1
			$Sprite2D.modulate = Color(0.9,0.3,0.1,0.4)
			modulated_state = true
			modulated_timer = 0
			Events.boss_hp = health_points
			Events.emit_signal("target_hit")
			change_position()
		
		if health_points <= 0:
			Events.emit_signal("boss1testkilled")
			self.queue_free()
		


func _on_timer_timeout() -> void:
	if pos_changed == true:
		if Events.attack_currently_active == false:
			Events.emit_signal("boss_attack","pattern2")
