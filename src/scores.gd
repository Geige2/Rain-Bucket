extends Control

signal exit_pressed

var high_scores = [[], [], [], []] setget set_high_scores
var difficulty_scores = [] setget set_difficulty_scores

onready var scores = $CenterContainer/Buttons/Scores
onready var difficulty = $CenterContainer/Buttons/Difficulty


func set_high_scores(value: Array) -> void:
	high_scores = value
	self.difficulty_scores = high_scores[difficulty.selected]


func set_difficulty_scores(value: Array) -> void:
	difficulty_scores = value
	update_scores()


func update_scores() -> void:
	scores.clear()
	
	for score in difficulty_scores:
		scores.add_item(str(score), null, false)


func _on_Difficulty_item_selected(index: int) -> void:
	self.difficulty_scores = high_scores[index]


func _on_Exit_pressed() -> void:
	emit_signal("exit_pressed")
