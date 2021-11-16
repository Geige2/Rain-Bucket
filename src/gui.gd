extends Control

var score = 0 setget set_score
var health = 8 setget set_health
var max_health = 8
var difficulty_level = 1

onready var score_value = $Score/Score
onready var heart = $Heart


func set_score(value: int) -> void:
	score = value
	score_value.text = str(score)


func set_health(value: int) -> void:
	health = value
	heart.frame = min(max(max_health - health, 0), heart.hframes - 1)
