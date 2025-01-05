extends Node

var player_position : Vector2
var boss_position : Vector2
var boss_hp : float
var current_pattern : Vector2
var player_health : int = 5 
var player_immortal : bool
var current_boss : int
var ball_charge : float
var player_snap_mit : Vector2
var player_snap : Vector2
var player_snap_high : Vector2
var pos_changing : bool 
var attack_currently_active : bool 
var random_number_of_two : int
var second_attack_active : bool
var ball_killing_bullets : bool = false
var boss_left_position : Vector2 
var boss_righ_position : Vector2


signal attack
signal left_slide_attack
signal right_slide_attack
signal player_hit_by_ball
signal target_hit
signal player_hit_by_bullet 
signal boss1testkilled
signal spawn_boss
signal third_boss_attack_finished
signal boss_attack
signal fourth_aoe_finished
signal power_up_poiman
signal attack_finished
signal boss_secondary_attack
signal secondary_attack_finished
signal update_noflor_signal

signal plot_points_on_the_graph
