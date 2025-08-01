extends Node

@onready var boss_test1 = load("res://objects/target_test1.tscn")
@onready var boss_test2 = load("res://objects/targets/second_target.tscn")
@onready var boss_test3 = load("res://objects/targets/third_boss.tscn")
@onready var boss_test4 = load("res://objects/targets/4_rthboss.tscn")
@onready var boss_test5 = load("res://objects/targets/petboss.tscn")
@onready var boss_test6 = load("res://objects/targets/siexboss.tscn")
@onready var boss_test7 = load("res://objects/targets/seventhbosss.tscn")
@onready var boss_test8 = load("res://objects/targets/8_th_boss.tscn")
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
	


func spawn_boss_func(number):
	match number+1:
		1:
			boss_inst = boss_test1.instantiate()
			inst_position = Vector2(525,275)
			Events.current_boss = 1
		2:
			boss_inst = boss_test2.instantiate()
			inst_position = Vector2(525,250)
			Events.current_boss = 2
			$"SubViewportContainer/SubViewport/2dworld/world_boundary/StaticBody2D/left_collision".position.x = 175
			$"SubViewportContainer/SubViewport/2dworld/world_boundary/StaticBody2D/right_collision".position.x = 1025
			$"SubViewportContainer/SubViewport/2dworld/world_boundary/StaticBody2D3/top_collision".position.y = 200


		3:
			boss_inst = boss_test3.instantiate()
			inst_position = Vector2(525,250)
			Events.current_boss = 3

		4:
			boss_inst = boss_test4.instantiate()
			inst_position = Vector2(600,150)
			Events.current_boss = 4
			$"SubViewportContainer/SubViewport/2dworld/world_boundary/StaticBody2D/left_collision".position.x = 350
			$"SubViewportContainer/SubViewport/2dworld/world_boundary/StaticBody2D/right_collision".position.x = 850
			$"SubViewportContainer/SubViewport/2dworld/world_boundary/StaticBody2D3/top_collision".position.y = 50
			
			
			
			
			

		5:
			boss_inst = boss_test5.instantiate()
			inst_position = Vector2(625,400)
			Events.current_boss = 5
			$"SubViewportContainer/SubViewport/2dworld/world_boundary/StaticBody2D/left_collision".position.x = 175
			$"SubViewportContainer/SubViewport/2dworld/world_boundary/StaticBody2D/right_collision".position.x = 1025
			$"SubViewportContainer/SubViewport/2dworld/world_boundary/StaticBody2D3/top_collision".position.y = 200
			

		6:
			boss_inst = boss_test6.instantiate()
			inst_position = Vector2(625,240)
			Events.current_boss = 6

		7: 
			boss_inst = boss_test7.instantiate()
			inst_position = Vector2(600,200)
			Events.current_boss = 7 

		8:
			boss_inst = boss_test8.instantiate()
			inst_position = Vector2(600,200)
			Events.current_boss = 8


	boss_inst.position = inst_position
	$"SubViewportContainer/SubViewport/2dworld/boss_holder".add_child(boss_inst)
	Events.world_boundaries[0] = $"SubViewportContainer/SubViewport/2dworld/world_boundary/StaticBody2D/left_collision".position.x
	Events.world_boundaries[1] = $"SubViewportContainer/SubViewport/2dworld/world_boundary/StaticBody2D/right_collision".position.x
	Events.world_boundaries[2] = $"SubViewportContainer/SubViewport/2dworld/world_boundary/StaticBody2D3/top_collision".position.y
	Events.world_boundaries[3] = $"SubViewportContainer/SubViewport/2dworld/world_boundary/StaticBody2D2/bottom_collision".position.y




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
