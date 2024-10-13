extends Node2D


var reached_left_border : bool = true
var reached_right_border : bool = false
var health_points : int = 10
var modulated_timer : float = 0
var modulated_state : bool = false

signal target_hit
signal boss1testkilled

func _process(delta: float) -> void:
	Events.boss_position = position
	if position.x <= 100:
		reached_left_border = true
		reached_right_border = false
	elif position.x >= 780:
		reached_right_border = true
		reached_left_border = false
	
	if reached_left_border == true:
		self.position.x += 3
	if reached_right_border == true:
		self.position.x -= 3
	
	if modulated_state == true:
		
		modulated_timer += 1*delta
		if modulated_timer >= 0.3:
			modulated_state == false
			$Sprite2D.modulate = Color(255,255,255)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		health_points -= 1
		$Sprite2D.modulate = Color(200,0,90)
		modulated_state = true
		modulated_timer = 0
		Events.boss_hp = health_points
		Events.emit_signal("target_hit")
		if health_points <= 0:
			Events.emit_signal("boss1testkilled")
			self.queue_free()
		
