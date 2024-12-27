extends CharacterBody2D


var speed : float = 35
var accel : float = 3 
var attack_active : bool = false
var attack_timer : float = 0
var right_slide_active : bool = false
var left_slide_active : bool = false
var jump_counter : int = 0
var player_stunned : bool = false
var player_stun_timer : float = 0
var player_health : int = 5
var coold_down_timer : float 
signal attack
signal left_slide_attack
signal right_slide_attack

@onready var left_slide_area : Area2D = $left_slide_attack
@onready var right_slide_area : Area2D = $right_slide_attack
@onready var left_slide_collision : CollisionShape2D = $left_slide_attack/CollisionShape2D
@onready var right_slide_collision : CollisionShape2D = $right_slide_attack/CollisionShape2D
@onready var overhead_attack_area : Area2D = $overhead_attack
@onready var overhead_attack_collision : CollisionShape2D = $overhead_attack/CollisionShape2D

func _ready() -> void:
	Events.connect("player_hit_by_ball", stun_player)
	


func stun_player():
	player_stun_timer = 0
	player_stunned = true

func _physics_process(delta):
	
	Events.player_position = position

	coold_down_timer -= delta
	if left_slide_active == false and right_slide_active == false:
		velocity.x = 0
	
	if position.y < 690:
		velocity.y += 10
	if position.y > 690:
		velocity.y = 0
		jump_counter = 0
	
	if Input.is_action_pressed("a"):
		velocity.x = -300
		#if velocity.x > 0:
			#velocity -= Vector2(speed*10, 0)
		#elif velocity.x <= 0:
			#velocity -= Vector2(speed, 0)
	if Input.is_action_pressed("d"):
		velocity.x = 300
		#if velocity.x > 0:
			#velocity += Vector2(speed, 0)
		#elif velocity.x <= 0:
			#velocity += Vector2(speed*10, 0)
	if Input.is_action_just_pressed("w"):
		if jump_counter > 0:
			return
		else:
			velocity -= Vector2(0, 450)
			jump_counter += 1
	
	if Input.is_action_just_pressed("shift"):
		if attack_timer == 0:
			if velocity.x > 0:
				#velocity.x = 800
				left_slide_active = true
			else:
				#velocity.x = -800
				right_slide_active = true
				
	
	if left_slide_active: 
		velocity.x = 700
	elif right_slide_active:
		velocity.x = -700
	
	if Input.is_action_just_pressed("space"):
		if attack_timer == 0:
			if coold_down_timer <= 0 :
				attack_active = true
		

	if attack_active == true:
		attack_timer += 1*delta
		overhead_attack_area.monitoring = true 
		overhead_attack_collision.visible = true
		overhead_attack_area.monitorable = true 
		velocity.x = 0
		if attack_timer >= 0.4:
			attack_active = false
			overhead_attack_area.monitoring = false
			overhead_attack_collision.visible = false
			overhead_attack_area.monitorable = false 
			attack_timer = 0
			coold_down_timer = 0.4

	if left_slide_active == true:
		attack_timer += 1*delta
		left_slide_area.monitoring = true 
		left_slide_collision.visible = true
		if attack_timer >= 0.4:
			left_slide_active = false
			left_slide_area.monitoring = false
			left_slide_collision.visible = false
			attack_timer = 0



	if right_slide_active == true:
		attack_timer += 1*delta
		right_slide_area.monitoring = true 
		right_slide_collision.visible = true
		if attack_timer >= 0.4:
			right_slide_active = false
			right_slide_area.monitoring = false
			right_slide_collision.visible = false
			attack_timer = 0


	#
	#
	#if velocity.x > 185:
		#velocity.x = velocity.x - 21 - velocity.x/21
	#elif velocity.x < -185:
		#velocity.x = velocity.x + 21 - velocity.x/21
	
	if player_stunned == true:
		velocity = Vector2.ZERO
		player_stun_timer += 1*delta
		if player_stun_timer >= 0.5:
			player_stunned = false
	
	move_and_slide()
#
#





func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		Events.player_position = position
		Events.emit_signal("attack")


func _on_lest_slide_attack_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		Events.player_position = position
		Events.emit_signal("left_slide_attack")
		


func _on_right_slide_attack_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		Events.player_position = position
		Events.emit_signal("right_slide_attack")
		
