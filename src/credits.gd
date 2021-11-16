extends Control

signal exit_pressed


func _on_Exit_pressed() -> void:
	emit_signal("exit_pressed")
