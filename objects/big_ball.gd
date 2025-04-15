extends Node2D

var life_long : float
var pattern_snapshot : Vector2
var pattern_transfered : Vector2
var boss_snapshot
var bullet_speed : float
var patter_real : Vector2
var reflect : bool
var was_hit_by_player : bool
var pos_change_timer :float = 0
var slow_down_start : bool = false
var slow_counter : float 

signal player_hit_by_bullet 

func _ready() -> void:
	
	Events.connect("big_ball_sent",send_the_balls)
	boss_snapshot = Events.current_boss
	pattern_snapshot = Events.current_pattern
	
	match Events.current_boss:
		1:
			print("i am rarted frfr")
		2:
			patter_real = pattern_snapshot




func _physics_process(delta: float) -> void:
	
	if slow_down_start == true:
		#slow_counter += delta
		#if slow_counter < 0.7:
		look_at(Events.player_position)
		return
		#if slow_counter >= 0.7:
	
	
	pattern_transfered += (Events.player_position - position).normalized()/20
	position += pattern_transfered*bullet_speed
	
	if position.y > 740 :
		self.queue_free()
	

func _process(delta: float) -> void:
	life_long += 1*delta
	if life_long >= 16:
		self.queue_free()

func send_the_balls():
	slow_down_start = false




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Events.emit_signal("player_hit_by_bullet")
	if body.is_in_group("ball"):
		if Events.ball_killing_bullets == true:
			self.queue_free()
