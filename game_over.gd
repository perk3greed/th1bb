extends Node

@onready var boss_test1 = load("res://objects/target_test1.tscn")
@onready var boss_test2 = load("res://objects/targets/second_target.tscn")
@onready var boss_test3 = load("res://objects/targets/third_boss.tscn")
@onready var boss_test4 = load("res://objects/targets/4_rthboss.tscn")
@onready var boss_test5 = load("res://objects/targets/petboss.tscn")
@onready var boss_test6 = load("res://objects/targets/siexboss.tscn")
var boss_inst
var inst_position : Vector2
var player_health : int 
var player_invul_timer : float
var player_invul : bool


func _ready() -> void:
	Events.connect("spawn_boss", spawn_boss_func)
	Events.connect("player_hit_by_bullet", calculate_player_health)
	$interfacemain/player_health.text = str(player_health)
	player_health = Events.player_health

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

		3:
			boss_inst = boss_test3.instantiate()
			inst_position = Vector2(525,250)
			Events.current_boss = 3

		4:
			boss_inst = boss_test4.instantiate()
			inst_position = Vector2(525,100)
			Events.current_boss = 4

		5:
			boss_inst = boss_test5.instantiate()
			inst_position = Vector2(625,400)
			Events.current_boss = 5

		6:
			boss_inst = boss_test6.instantiate()
			inst_position = Vector2(625,240)
			Events.current_boss = 6

	boss_inst.position = inst_position
	$"2dworld/targets".add_child(boss_inst)
	



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
