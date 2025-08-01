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
var block_counter : int = 1
var block_active : bool = false
var reflect_happened : bool = false

signal attack
signal left_slide_attack
signal right_slide_attack
signal move_ball_a_little

@onready var left_slide_area : Area2D = $left_slide_attack
@onready var right_slide_area : Area2D = $right_slide_attack
@onready var left_slide_collision : CollisionShape2D = $left_slide_attack/CollisionShape2D
@onready var right_slide_collision : CollisionShape2D = $right_slide_attack/CollisionShape2D
@onready var overhead_attack_area : Area2D = $overhead_attack
@onready var overhead_attack_collision : CollisionShape2D = $overhead_attack/CollisionShape2D


func _ready() -> void:
	Events.connect("player_hit_by_ball", stun_player)
	Events.connect("player_hit_by_bullet", emit_hit)
	Events.connect("bullet_reflected", react_to_reflect)
	Events.connect("power_up_poiman", add_blocks)
	Events.connect("add_block",add_additional_block)
	Events.connect("player_touched_right_col", move_to_the_left)
	Events.connect("player_touched_left_col", move_to_the_right)


func add_blocks():
	block_counter += 1

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
		velocity.x = -350
		if left_slide_active == true:
			attack_timer = 0.4
	if Input.is_action_pressed("d"):
		velocity.x = 350
		if right_slide_active == true:
			attack_timer = 0.4
			
	if Input.is_action_just_pressed("w"):
		#print(Events.world_boundaries)
		if jump_counter > 0:
			return
		else:
			velocity -= Vector2(0, 450)
			jump_counter += 1
	
	if Input.is_action_just_pressed("shift"):
		if attack_timer == 0:
			if velocity.x > 0:
				left_slide_active = true
			else:
				right_slide_active = true
				
	
	if left_slide_active: 
		velocity.x = 850
	elif right_slide_active:
		velocity.x = -850
	
	if Input.is_action_just_pressed("space"):
		if attack_timer == 0:
			if coold_down_timer <= 0 :
				attack_active = true
				if block_counter > 0:
					block_active = true

	if block_active == true:
		$bullet_reflector.monitorable = true
		$bullet_reflector.monitoring = true
		$bullet_reflector/CollisionPolygon2D.visible = true


	if attack_active == true:
		attack_timer += 1*delta
		overhead_attack_area.monitoring = true 
		$top_sprite.visible = true
		overhead_attack_area.monitorable = true 
		velocity.x = 0
		
		
		
		if attack_timer >= 0.4:
			attack_active = false
			overhead_attack_area.monitoring = false
			$top_sprite.visible = false
			overhead_attack_area.monitorable = false 
			$bullet_reflector.monitorable = false
			$bullet_reflector.monitoring = false
			attack_timer = 0
			coold_down_timer = 0.4
			block_active = false
			$bullet_reflector/CollisionPolygon2D.visible = false
			if reflect_happened == true:
				block_counter -= 1
			
			reflect_happened = false


	if left_slide_active == true:
		attack_timer += 1*delta
		left_slide_area.monitoring = true 
		$left.visible = true
		if attack_timer >= 0.4:
			left_slide_active = false
			left_slide_area.monitoring = false
			$left.visible = false
			attack_timer = 0



	if right_slide_active == true:
		attack_timer += 1*delta
		right_slide_area.monitoring = true 
		$right.visible = true
		if attack_timer >= 0.4:
			right_slide_active = false
			right_slide_area.monitoring = false
			$right.visible = false
			attack_timer = 0
			

	if player_stunned == true:
		velocity = Vector2.ZERO
		player_stun_timer += 1*delta
		if player_stun_timer >= 0.5:
			player_stunned = false
	
	move_and_slide()



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
		

func emit_hit():
	$CPUParticles2D.emitting = true
	$debugsprite.modulate = (Color(1,0.3,0.3,0.7))
	
	

func _on_cpu_particles_2d_finished() -> void:
	$debugsprite.modulate = (Color(0.1,0.3,0.6,0.5))


func react_to_reflect():
	reflect_happened = true



func add_additional_block():
	block_counter += 9999



func move_to_the_left():
	position.x = Events.world_boundaries[0] + 20


func move_to_the_right():
	position.x = Events.world_boundaries[1] - 20


func _on_antiballfield_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		Events.player_position = position
		Events.emit_signal("move_ball_a_little")
