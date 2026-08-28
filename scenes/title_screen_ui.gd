extends CanvasLayer

#Title Screen Functions
#Switch from Title Screen to Main Game Scene.
func SwitchToGame():
	get_tree().change_scene_to_file("res://scenes/level.tscn")

#Individual Button Functions

#Title Screen Quit Button - Quits the Game.
func _on_title_quit_button_pressed():
	get_tree().quit()

#Title Screen Play Button - Starts the Game.
func _on_title_play_button_pressed():
	SwitchToGame()
