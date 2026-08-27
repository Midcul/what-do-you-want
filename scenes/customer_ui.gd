extends Node2D
signal reduce_patience(time)

@onready var ui = %CanvasLayer
@onready var bar = %ProgressBar
const GREEN = Color("00ff00")
const YELLOW = Color("ffff00")
const RED = Color("ff0000")
var dialogue_started = false
var paused_timer

func _ready() -> void:
	hide_ui()

func _physics_process(_delta: float) -> void:
	%Clue1.visible_ratio = (%Timer.wait_time - %Timer.time_left) / %Timer.wait_time
	%Clue2.visible_ratio = (%Timer2.wait_time - %Timer2.time_left) / %Timer2.wait_time
	%Clue3.visible_ratio = (%Timer3.wait_time - %Timer3.time_left) / %Timer3.wait_time

func update_patience(val) -> void:
	bar.value = val
	if bar.value < 33.3:
		bar.modulate = RED
	elif bar.value < 66.7:
		bar.modulate = YELLOW

func hide_ui() -> void:
	ui.visible = false
	if %Timer.time_left > 0:
		%Timer.paused = true
		paused_timer = %Timer
	elif %Timer2.time_left > 0:
		%Timer2.paused = true
		paused_timer = %Timer2
	elif %Timer3.time_left > 0:
		%Timer3.paused = true
		paused_timer = %Timer3
	
func show_ui() -> void:
	ui.visible = true
	if not dialogue_started:
		dialogue_started = true
		%Clue1.show()
		%Timer.start()
	if paused_timer:
		paused_timer.paused = false

func _on_timer_timeout() -> void:
	%Pic1.show()
	%Elaborate1.show()
	await get_tree().create_timer(1.0).timeout
	%Timer2.start()
	await get_tree().physics_frame
	%Clue2.show()

func _on_timer_2_timeout() -> void:
	%Pic2.show()
	%Elaborate2.show()
	await get_tree().create_timer(1.0).timeout
	%Timer3.start()
	await get_tree().physics_frame
	%Clue3.show()

func _on_timer_3_timeout() -> void:
	%Pic3.show()
	%Elaborate3.show()

func _on_elaborate_1_pressed() -> void:
	%Elaborate1.hide()
	%Answer1.show()
	emit_signal("reduce_patience", 10)

func _on_elaborate_2_pressed() -> void:
	%Elaborate2.hide()
	%Answer2.show()
	emit_signal("reduce_patience", 10)

func _on_elaborate_3_pressed() -> void:
	%Elaborate3.hide()
	%Answer3.show()
	emit_signal("reduce_patience", 10)
