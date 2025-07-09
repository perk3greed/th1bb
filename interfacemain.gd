extends Control

signal spawn_boss
signal add_block

func _ready() -> void:
	Events.connect("player_hit_by_ball", show_text)
	Events.connect("target_hit", update_boss_health)
	Events.connect("boss1testkilled", show_boss_selection)
	Events.connect("update_noflor_signal", update_noflor)
	


func show_text():
	$player_hit_rich.visible = true
	$"../Timer".start()

func _on_timer_timeout() -> void:
	$player_hit_rich.visible = false


func update_boss_health():
	$bossHP.text = str(Events.boss_hp)


func show_boss_selection():
	$ItemList.visible = true




func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	Events.player_immortal = $ItemList/CheckButton.button_pressed
	$ItemList.visible = false
	Events.emit_signal("spawn_boss", index)
	
	if $ItemList/ballkiller.button_pressed == true:
		Events.ball_killing_bullets = true




func update_noflor(amount):
	if amount > 0:
		$ball_noflor.visible = true
		$ball_noflor.text = str(amount)
	if amount == 0:
		$ball_noflor.visible = false


func _on_inf_block_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		Events.emit_signal("add_block")
