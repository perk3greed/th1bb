extends Node2D


var health_points : int = 10
var modulated_timer : float = 0
var modulated_state : bool = false
var this_boss_patter : Vector2 
var current_position : int = 0

var rng = RandomNumberGenerator.new()

var boss_movement_grid : Dictionary = {
	1 : Vector2(100,200),
	2 : Vector2(300,400),
	3 : Vector2(600,300)
}

signal target_hit
signal boss1testkilled


func _ready() -> void:
	Events.connect("third_boss_attack_finished", change_position)

func change_position():
	if current_position < 3:
		current_position += 1
		position = boss_movement_grid[current_position]
	else :
		current_position = 0


func _process(delta: float) -> void:
	
	
	Events.boss_position = position
	
	
	
	if modulated_state == true:
		
		modulated_timer += 1*delta
		if modulated_timer >= 0.3:
			modulated_state == false
			$Sprite2D.modulate = Color(125,0,90)



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		health_points -= 1
		$Sprite2D.modulate = Color(15,225,55)
		modulated_state = true
		modulated_timer = 0
		Events.boss_hp = health_points
		Events.emit_signal("target_hit")
		if health_points <= 0:
			Events.emit_signal("boss1testkilled")
			self.queue_free()
		
