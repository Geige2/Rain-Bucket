extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 500

export(bool) var fall

var velocity = Vector2.ZERO


func _physics_process(delta: float) -> void:
	if fall:
		velocity = velocity.move_toward(Vector2.DOWN * MAX_SPEED, ACCELERATION * delta)
		velocity = move_and_slide(velocity)
