extends Node

var player_position : Vector2
var boss_position : Vector2
var boss_hp : int
var current_pattern : Vector2
var bullet_speed : float 
var player_health : int = 5 
var player_immortal : bool

signal attack
signal left_slide_attack
signal right_slide_attack
signal player_hit_by_ball
signal target_hit
signal player_hit_by_bullet 
signal boss1testkilled
signal spawn_boss
