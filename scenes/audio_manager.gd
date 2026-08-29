extends AudioStreamPlayer

@onready var music = %Music
@onready var sfx = %Sfx
@onready var steps = %Steps

@onready var title = preload("uid://d3owyaas5h1jx")
@onready var track1 = preload("uid://c8i4h2qhyu84m")
@onready var track1_thinking = preload("uid://dycsdwko6oy5h")
@onready var track2 = preload("uid://6kuul015x7bj")
@onready var track2_thinking = preload("uid://c6xkl5p12yc76")
@onready var track3 = preload("uid://sxud5rfndi8u")
@onready var track3_thinking = preload("uid://cs74lklkmqynh")
@onready var track4 = preload("uid://d1f0eqwxx8orq")
@onready var track4_thinking = preload("uid://bptabh5wsi7t7")
@onready var music_tracks = [track1, track2, track3, track4]
@onready var think_tracks = [track1_thinking, track2_thinking, track3_thinking, track4_thinking]
@onready var rand_int

func _ready() -> void:
	music.volume_db = linear_to_db(0.5)
	sfx.volume_db = linear_to_db(0.5)
	process_mode = Node.PROCESS_MODE_ALWAYS
	randomize_music()
	#play_music(title)
	
func play_music(stream: AudioStream, offset = 0) -> void:
	if music.get_child_count() > 0:
		music.get_children()[0].queue_free()
	music.stream = stream
	music.play(offset)

func randomize_music() -> void:
	rand_int = randi_range(0, 3)
	play_music(music_tracks[rand_int])

func switch_track() -> void:
	var offset = music.get_playback_position()
	if music.stream == music_tracks[rand_int]:
		play_music(think_tracks[rand_int], offset)
	else:
		play_music(music_tracks[rand_int], offset)

func play_sfx(stream: AudioStream) -> void:
	var player = AudioStreamPlayer.new()
	sfx.add_child(player)
	player.stream = stream
	player.volume_db = sfx.volume_db
	player.play()
	player.finished.connect(player.queue_free)

func stop_music() -> void:
	music.stop()
	for child in music.get_children():
		child.queue_free()
	
func stop_sfx() -> void:
	sfx.stop()
	for child in sfx.get_children():
		child.queue_free()

func set_music_volume(value: float) -> void:
	music.volume_db = linear_to_db(value)

func clear() -> void:
	stop_sfx()
	stop_music()

func play_steps() -> void:
	steps.play()
	
func stop_steps() -> void:
	steps.stop()

func set_sfx_volume(value: float) -> void:
	sfx.volume_db = linear_to_db(value)
	for children in sfx.get_children():
		children.volume_db = sfx.volume_db

func _on_music_finished() -> void:
	randomize_music()
