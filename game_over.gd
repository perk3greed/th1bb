extends Node

@onready var boss_test1 = load("res://objects/bosses/boss1.tscn")
@onready var boss_test2 = load("res://objects/bosses/boss2.tscn")
@onready var boss_test3 = load("res://objects/bosses/boss3.tscn")
@onready var boss_test4 = load("res://objects/bosses/boss4.tscn")
@onready var boss_test5 = load("res://objects/bosses/boss5.tscn")
@onready var boss_test6 = load("res://objects/bosses/boss6.tscn")
@onready var boss_test7 = load("res://objects/bosses/boss7.tscn")
@onready var boss_test8 = load("res://objects/bosses/boss8.tscn")
@onready var left_coll = $"2dworld/world_boundary/StaticBody2D/left_collision"
@onready var right_coll = $"2dworld/world_boundary/StaticBody2D/right_collision"
@onready var top_coll = $"2dworld/world_boundary/StaticBody2D3/top_collision"

var defolt_boundaries : Array = [145,1135,10]
var boss_inst
var inst_position : Vector2
var player_health : int 
var player_invul_timer : float
var player_invul : bool

signal player_touched_right_col
signal player_touched_left_col


func _ready() -> void:
	Events.connect("spawn_boss", spawn_boss_func)
	Events.connect("player_hit_by_bullet", calculate_player_health)
	$interfacemain/player_health.text = str(player_health)
	player_health = Events.player_health
	Events.attack_currently_active = false
	calculate_player_health()


func spawn_boss_func(number):
	match number+1:
		1:
			boss_inst = boss_test1.instantiate()
			inst_position = Vector2(525,100)
			Events.current_boss = 1
			left_coll.position.x = 175
			right_coll.position.x = 1025
			top_coll.position.y = defolt_boundaries[2]

			
		2:
			boss_inst = boss_test2.instantiate()
			inst_position = Vector2(525,250)
			Events.current_boss = 2
			left_coll.position.x = 175
			right_coll.position.x = 1025
			top_coll.position.y = defolt_boundaries[2]


		3:
			boss_inst = boss_test3.instantiate()
			inst_position = Vector2(525,250)
			Events.current_boss = 3
			left_coll.position.x = defolt_boundaries[0]
			right_coll.position.x = defolt_boundaries[1]
			top_coll.position.y = defolt_boundaries[2]

			

		4:
			boss_inst = boss_test4.instantiate()
			inst_position = Vector2(600,150)
			Events.current_boss = 4
			left_coll.position.x = 350
			right_coll.position.x = 850
			top_coll.position.y = defolt_boundaries[2]
			
			
			
			
			

		5:
			boss_inst = boss_test5.instantiate()
			inst_position = Vector2(625,400)
			Events.current_boss = 5
			left_coll.position.x = 175
			right_coll.position.x = 1025
			top_coll.position.y = defolt_boundaries[2]
			

		6:
			boss_inst = boss_test6.instantiate()
			inst_position = Vector2(640,155)
			Events.current_boss = 6
			left_coll.position.x = defolt_boundaries[0]
			right_coll.position.x = defolt_boundaries[1]
			top_coll.position.y = defolt_boundaries[2]
			

		7: 
			boss_inst = boss_test7.instantiate()
			inst_position = Vector2(600,200)
			Events.current_boss = 7 
			left_coll.position.x = defolt_boundaries[0]
			right_coll.position.x = defolt_boundaries[1]
			top_coll.position.y = defolt_boundaries[2]

		8:
			boss_inst = boss_test8.instantiate()
			inst_position = Vector2(600,200)
			Events.current_boss = 8
			left_coll.position.x = defolt_boundaries[0]
			right_coll.position.x = defolt_boundaries[1]
			top_coll.position.y = defolt_boundaries[2]

	boss_inst.position = inst_position
	$"2dworld/boss_holder".add_child(boss_inst)
	Events.world_boundaries[0] = left_coll.position.x
	Events.world_boundaries[1] = right_coll.position.x
	Events.world_boundaries[2] = top_coll.position.y
	Events.world_boundaries[3] = $"2dworld/world_boundary/StaticBody2D2/bottom_collision".position.y
	Events.attack_currently_active = false



func _process(delta: float) -> void:
	if player_invul == true:
		player_invul_timer += delta*1
		if player_invul_timer >= 1:
			player_invul = false
			player_invul_timer = 0
	
	

func calculate_player_health():
	if Events.player_immortal == true:
		return
	if player_invul == true:
		return
	player_health -= 1
	$interfacemain/player_health.text = str(player_health)
	player_invul = true
	
	if player_health < 1:
		get_tree().reload_current_scene()


func _on_right_colis_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Events.emit_signal("player_touched_right_col")




func _on_left_colis_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Events.emit_signal("player_touched_left_col")


func _on_button_pressed() -> void:
	var boss_count = $"2dworld/boss_holder".get_child_count()
	for child in boss_count:
		var children = $"2dworld/boss_holder".get_child(child)
		children.queue_free()
	player_health = 4
	Events.emit_signal("boss1testkilled")
	Events.attack_currently_active = false
	Events.emit_signal("clear_attack")
	
	
	
	
	
	
