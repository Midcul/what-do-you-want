#Pause Menu
#Initialisation
extends CanvasLayer

#Gets the Audio Bus in order to adjust volume.
var volume = AudioServer.get_bus_index("Master")

#Pause Menu Functions
#Resume the game.
func UnPause():
	get_tree().paused = false
	hide()

#Restart the game.
func Restart():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/level.tscn")
	
#Quit the game back to the title screen.
func Quit():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/TitleScreen.tscn")

#Pause Menu Buttons
#Volume Slider - Convert slider value to dB equivalent before applying for new volume.
func _on_pause_volume_slider_value_changed(value: float):
	AudioServer.set_bus_volume_db(volume,linear_to_db(value))

#Resume Button
func _on_pause_resume_button_pressed() -> void:
	UnPause()

#Restart Button
func _on_pause_restart_button_pressed() -> void:
	Restart()

#Quit Button
func _on_pause_quit_button_pressed():
	Quit()

#Startup Functionality
func _ready():
	hide() #Pause menu is hidden on startup.

#Reciving Pause Signal
func _on_player_pause_request():
	show()
