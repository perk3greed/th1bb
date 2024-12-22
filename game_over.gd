extends Node

@onready var boss_test1 = load("res://objects/target_test1.tscn")
@onready var boss_test2 = load("res://objects/targets/second_target.tscn")
@onready var boss_test3 = load("res://objects/targets/third_boss.tscn")
@onready var boss_test4 = load("res://objects/targets/4_rthboss.tscn")
var boss_inst
var inst_position : Vector2
var player_health : int 

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
			inst_position = Vector2(525,150)
			Events.current_boss = 2

		3:
			boss_inst = boss_test3.instantiate()
			inst_position = Vector2(525,250)
			Events.current_boss = 3

		4:
			boss_inst = boss_test4.instantiate()
			inst_position = Vector2(525,100)
			Events.current_boss = 4


	boss_inst.position = inst_position
	$"2dworld/targets".add_child(boss_inst)
	


func calculate_player_health():
	if Events.player_immortal == true:
		return
	player_health -= 1
	$interfacemain/player_health.text = str(player_health)
	
