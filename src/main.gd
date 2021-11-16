extends Node2D

const GAME = preload("res://src/Game.tscn")
const MAIN_MENU = preload("res://src/MainMenu.tscn")
const SCORES = preload("res://src/Scores.tscn")
const CREDITS = preload("res://src/Credits.tscn")
const SCORES_PATH = "user://save.dat"
const BACKGROUND_RAIN = preload("res://audio/background_rain.mp3")
const PLOP_EFFECT = preload("res://audio/plop_effect.mp3")
const SPLOSH_EFFECT = preload("res://audio/splosh_effect.mp3")

var difficulty_level = 2
var high_scores = [[], [], [], []]
var volume = 3.0 setget set_volume
var audio_streams = []
var vfx_enabled = true
var has_played = false

onready var current_scene = $MainMenu
onready var music_cooldown = $MusicCooldown


func _ready() -> void:
	get_tree().set_auto_accept_quit(false)
	load_game()
	play_background_noise()
	current_scene.set_volume_slider(volume * 5)
	current_scene.set_vfx_enabled(vfx_enabled)
	
	if not has_played:
		current_scene.show_guide()
	
	has_played = true


func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_game()
		get_tree().quit()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		if current_scene.name != "MainMenu":
			switch_to_main_menu()


func set_volume(value: float) -> void:
	volume = value
	
	for i in len(audio_streams):
		var audio_stream = audio_streams[i]
		
		if not is_instance_valid(audio_stream):
			continue
		
		audio_stream.volume_db = volume


func save_game() -> void:
	var scores = File.new()
	scores.open(SCORES_PATH, File.WRITE)
	scores.store_line(to_json({"high_scores": high_scores, "volume": volume, "use_vfx": vfx_enabled}))
	scores.close()


func load_game() -> void:
	var scores = File.new()
	if not scores.file_exists(SCORES_PATH):
		return
	
	scores.open(SCORES_PATH, File.READ)
	var data = parse_json(scores.get_line())
	
	high_scores = data["high_scores"]
	volume = data["volume"]
	vfx_enabled = data["use_vfx"]
	
	has_played = true
	scores.close()


func switch_to_main_menu() -> void:
	if current_scene.name == "Game":
		var difficulty_scores = high_scores[current_scene.difficulty_level - 1]
		difficulty_scores.append(current_scene.score)
		difficulty_scores.sort()
		difficulty_scores.invert()
		high_scores[current_scene.difficulty_level - 1] = difficulty_scores
	
	switch_to_scene(MAIN_MENU)
	current_scene.set_volume_slider(volume * 5)
	current_scene.set_vfx_enabled(vfx_enabled)
	current_scene.set_difficulty_level(difficulty_level)
	
	current_scene.connect("changed_volume", self, "_on_MainMenu_changed_volume")
	current_scene.connect("selected_difficulty_level", self, "_on_MainMenu_selected_difficulty_level")
	current_scene.connect("play_pressed", self, "_on_MainMenu_play_pressed")
	current_scene.connect("quit_pressed", self, "_on_MainMenu_quit_pressed")
	current_scene.connect("scores_pressed", self, "_on_MainMenu_scores_pressed")
	current_scene.connect("credits_pressed", self, "_on_MainMenu_credits_pressed")
	current_scene.connect("vfx_pressed", self, "_on_MainMenu_vfx_pressed")


func switch_to_scores() -> void:
	switch_to_scene(SCORES)
	current_scene.high_scores = high_scores
	current_scene.connect("exit_pressed", self, "_on_Scores_exit_pressed")


func switch_to_credits() -> void:
	switch_to_scene(CREDITS)
	current_scene.connect("exit_pressed", self, "_on_Credits_exit_pressed")


func switch_to_game() -> void:
	switch_to_scene(GAME)
	current_scene.difficulty_level = difficulty_level
	current_scene.vfx_enabled = vfx_enabled
	current_scene.connect("dead", self, "_on_Game_dead")
	current_scene.connect("score_changed", self, "_on_Game_score_changed")


func switch_to_scene(scene: PackedScene) -> void:
	current_scene.queue_free()
	var scene_instance = scene.instance()
	add_child(scene_instance)
	current_scene = scene_instance


func play_background_noise() -> void:
	var audio_player = get_audio_player()
	audio_player.play_sound(BACKGROUND_RAIN)
	audio_player.connect("finished", self, "_on_AudioPlayer_finished")


func get_audio_player() -> AudioStreamPlayerManager:
	var audio_player = AudioStreamPlayerManager.new()
	audio_player.volume_db = volume
	
	add_child(audio_player)
	audio_streams.append(audio_player)
	
	return audio_player


func _on_MainMenu_changed_volume(percent: float) -> void:
	self.volume = percent / 5
	self.volume = percent / 5


func _on_MainMenu_selected_difficulty_level(difficulty_level_: int) -> void:
	difficulty_level = difficulty_level_


func _on_MainMenu_play_pressed() -> void:
	switch_to_game()


func _on_MainMenu_quit_pressed() -> void:
	save_game()
	get_tree().quit()


func _on_MainMenu_scores_pressed() -> void:
	switch_to_scores()


func _on_MainMenu_credits_pressed() -> void:
	switch_to_credits()


func _on_Credits_exit_pressed() -> void:
	switch_to_main_menu()


func _on_Scores_exit_pressed() -> void:
	switch_to_main_menu()


func _on_Game_score_changed(_value: int) -> void:
	get_audio_player().play_sound(PLOP_EFFECT)


func _on_Game_dead() -> void:
	switch_to_main_menu()


func _on_MainMenu_vfx_pressed() -> void:
	vfx_enabled = not vfx_enabled
