extends RigidBody2D

var player_Pos : Vector2
var boss_Pos : Vector2
var charge_negative_amount : float
var rng = RandomNumberGenerator.new()
var antiflor_charge : int 

signal player_hit_by_ball
signal update_noflor_signal

func _process(delta: float) -> void:
	Events.ball_position = position

func _ready() -> void:
	Events.connect("attack", be_moved_by_attack)
	Events.connect("left_slide_attack", be_moved_by_left_attack)
	Events.connect("right_slide_attack", be_moved_by_right_attack)
	Events.connect("target_hit", be_moved_by_boss)
	Events.connect("move_ball_a_little", be_moved_by_body)
	charge_negative_amount = 3
	check_charge()

func be_moved_by_body():
	if charge_negative_amount > 4: 
		apply_impulse(-linear_velocity)
		player_Pos = Events.player_position
		var impulse_vectorX : float = position.x - player_Pos.x
		var impulse_vectorY : float = position.y - player_Pos.y
		apply_impulse(Vector2(impulse_vectorX,impulse_vectorY).normalized()*500)
		
	

func be_moved_by_attack():
	apply_impulse(-linear_velocity)
	player_Pos = Events.player_position
	var impulse_vectorX : float = position.x - player_Pos.x
	var impulse_vectorY : float = position.y - player_Pos.y
	apply_impulse(Vector2(impulse_vectorX,impulse_vectorY).normalized()*1600)
	charge_negative_amount = 1
	antiflor_charge += 1
	check_charge()

func be_moved_by_boss():
	#apply_impulse(-linear_velocity)
	boss_Pos = Events.boss_position
	var impulse_vectorX : float = position.x - boss_Pos.x
	var impulse_vectorY : float = 150
	apply_impulse(Vector2(impulse_vectorX/1.5, impulse_vectorY))
	$hitparts.set_emitting(true)


func be_moved_by_left_attack():
	apply_impulse(-linear_velocity)
	var impulse_vectorX : float = 5
	var impulse_vectorY : float = -3
	apply_impulse(Vector2(impulse_vectorX,impulse_vectorY).normalized()*1500)
	charge_negative_amount = 1
	antiflor_charge += 1
	check_charge()

func be_moved_by_right_attack():
	apply_impulse(-linear_velocity)
	var impulse_vectorX : float = -5
	var impulse_vectorY : float = -3
	apply_impulse(Vector2(impulse_vectorX,impulse_vectorY).normalized()*1500)
	charge_negative_amount = 1
	antiflor_charge += 1
	check_charge()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if charge_negative_amount <= 4: 
			Events.emit_signal("player_hit_by_ball")
	if body.is_in_group("wall"):
		charge_negative_amount += 1
		check_charge()
	if body.is_in_group("floor"):
		antiflor_charge = 0
		charge_negative_amount += 1
		check_charge()


func check_charge():
	Events.ball_charge = charge_negative_amount
	self.gravity_scale = -0.1 + charge_negative_amount/5
	self.set_linear_damp( charge_negative_amount/15)
	var color_set : Array = [ Color(0.9,0.9,0.9), Color(0.9,0,0),Color(0.1,0.1,0.9), Color(0,0.6,0.2),Color(0,0.6,0.2),Color(0,0.6,0.2) ,Color(0,0.6,0.2) ,Color(0,0.6,0.2) ,Color(0,0.6,0.2) ,Color(0,0.6,0.2)  ] 
	if charge_negative_amount -1 < 6 :
		self.physics_material_override.bounce = 0.95
		$".".set_modulate(color_set[charge_negative_amount]) 
	elif charge_negative_amount - 1 >= 6:
		$".".set_modulate(Color(color_set[0]))
		self.physics_material_override.bounce = 0.1
		
	Events.emit_signal("update_noflor_signal",antiflor_charge)
	
