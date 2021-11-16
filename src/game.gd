extends Node2D

signal score_changed(value)
signal dead

const X_OFFSET = 320
const Y_POSITION = 38
const DROP = preload("res://src/Drop.tscn")
const BUCKET_SPEED = 10000

var time_between_drops = 1
var time_since_last_drop = time_between_drops / 2
var rng = RandomNumberGenerator.new()
var health = 8 setget set_health
var max_health = 8 setget set_max_health
var difficulty_level = 1 setget set_difficulty_level
var time_between_regens = 4 * difficulty_level
var time_since_last_regen = 0
var score setget set_score, get_score
var vfx_enabled setget set_vfx_enabled

onready var bucket = $Bucket
onready var gui = $CanvasLayer/GUI
onready var rain = $Rain


func _ready() -> void:
	rng.randomize()
	rain.material.set_shader_param("wind", float(rng.randi_range(-1, 1)))


func _physics_process(delta: float) -> void:
	time_since_last_drop += delta
	time_since_last_regen += delta
	
	if health == max_health:
		time_since_last_regen = 0
	
	if time_since_last_drop >= time_between_drops:
		var random_x_offset = rng.randf_range(0, X_OFFSET)
		var drop = DROP.instance()
		drop.global_position = Vector2(random_x_offset, Y_POSITION)
		add_child(drop)
		
		time_since_last_drop = 0
		if time_between_drops >= 0.8 / difficulty_level:
			time_between_drops -= 0.004 * time_between_drops * difficulty_level
	
	if time_since_last_regen >= time_between_regens:
		self.health += 1
		time_since_last_regen = 0
	
	move_bucket(delta)


func set_health(value: int) -> void:
	if health <= 0:
		emit_signal("dead")
		return
	
	health = min(value, max_health)
	gui.health = health


func set_max_health(value: int) -> void:
	max_health = value
	gui.max_health = max_health


func set_difficulty_level(value: int) -> void:
	difficulty_level = value
	gui.difficulty_level = difficulty_level
	rain.material.set_shader_param("fall_speed", difficulty_level / 2.0)


func set_score(value: int) -> void:
	bucket.collected = value


func get_score() -> int:
	return bucket.collected


func set_vfx_enabled(value: bool) -> void:
	vfx_enabled = value
	rain.material.set_shader_param("enabled", vfx_enabled)


func move_bucket(delta: float) -> void:
	var bucket_goal_position = Vector2(get_local_mouse_position().x, bucket.global_position.y)
	bucket.global_position = bucket.global_position.move_toward(bucket_goal_position, BUCKET_SPEED * delta)


func _on_DropDespawner_body_entered(body: PhysicsBody2D) -> void:
	body.queue_free()
	self.health -= 1


func _on_Bucket_collected_changed(value: int) -> void:
	gui.score = value
	emit_signal("score_changed", value)
