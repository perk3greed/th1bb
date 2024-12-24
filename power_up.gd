extends Node2D

signal power_up_poiman


func _process(delta: float) -> void:
	position += Vector2(0,1).normalized()*delta*180




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Events.emit_signal("power_up_poiman")
		$CPUParticles2D.set_emitting(true)
		$Sprite2D.set_visible(false)
		$Timer.start()
		





func _on_timer_timeout() -> void:
	self.queue_free()
