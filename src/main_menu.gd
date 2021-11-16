extends Control

signal changed_volume(percent)
signal selected_difficulty_level(difficulty_level)
signal play_pressed
signal scores_pressed
signal quit_pressed
signal credits_pressed
signal vfx_pressed

onready var volume_slider = $CenterContainer/Buttons/Settings/Volume
onready var use_vfx_enabled = $CenterContainer/Buttons/Settings/Enabled
onready var difficulty_level = $CenterContainer/Buttons/Play/Difficulty
onready var guide = $GuideElements


func set_volume_slider(value: float) -> void:
	volume_slider.value = value


func set_vfx_enabled(value: bool) -> void:
	use_vfx_enabled.pressed = value


func set_difficulty_level(value: int) -> void:
	difficulty_level.selected = value - 1


func show_guide() -> void:
	guide.show()


func _on_Volume_value_changed(value: float) -> void:
	emit_signal("changed_volume", value)


func _on_Difficulty_item_selected(index: int) -> void:
	emit_signal("selected_difficulty_level", index + 1)


func _on_Play_pressed() -> void:
	emit_signal("play_pressed")


func _on_Scores_pressed() -> void:
	emit_signal("scores_pressed")


func _on_Quit_pressed() -> void:
	emit_signal("quit_pressed")


func _on_Credits_pressed() -> void:
	emit_signal("credits_pressed")


func _on_Enabled_pressed() -> void:
	emit_signal("vfx_pressed")
