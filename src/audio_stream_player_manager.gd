class_name AudioStreamPlayerManager
extends AudioStreamPlayer


func play_sound(sound: AudioStream) -> void:
	stream = sound
	play()
	connect("finished", self, "queue_free")
