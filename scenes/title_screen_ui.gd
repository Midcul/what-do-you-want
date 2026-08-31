extends CanvasLayer


func _ready() -> void:
	InitDishes.in_tutorial = true
	AudioManager.play_music(AudioManager.title)
#Title Screen Functions
#Switch from Title Screen to Main Game Scene.
func SwitchToGame():
	InitDishes.tutorial_marker = 0
	InitDishes.level = 0
	get_tree().change_scene_to_file("res://scenes/level.tscn")
	AudioManager.stop_music()
	AudioManager.randomize_music()
#Individual Button Functions

#Title Screen Quit Button - Quits the Game.
func _on_title_quit_button_pressed():
	get_tree().quit()

#Title Screen Play Button - Starts the Game.
func _on_title_play_button_pressed():
	SwitchToGame()

func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		InitDishes.in_tutorial = false
	else:
		InitDishes.in_tutorial = true
