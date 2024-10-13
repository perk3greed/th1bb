extends Control

signal spawn_boss

func _ready() -> void:
	Events.connect("player_hit_by_ball", show_text)
	Events.connect("target_hit", update_boss_health)
	Events.connect("boss1testkilled", show_boss_selection)


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
	
