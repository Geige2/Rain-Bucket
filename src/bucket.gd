class_name Bucket
extends KinematicBody2D

signal collected_changed(value)

const FULL = 20

var collected = 0 setget set_collected

onready var sprite = $Sprite


func set_collected(value: int) -> void:
	collected = value
	var overflow = min(max((collected - FULL) / 10, 0), sprite.hframes - 1)
	sprite.frame = overflow
	emit_signal("collected_changed", collected)


func _on_WaterCollector_body_entered(body: PhysicsBody2D) -> void:
	body.queue_free()
	self.collected += 1
