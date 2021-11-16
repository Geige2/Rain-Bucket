extends Area2D


func _on_DropDespawner_body_entered(body: PhysicsBody2D) -> void:
	body.queue_free()
