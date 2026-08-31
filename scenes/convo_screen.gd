extends Parallax2D

@export var scroll_speed: float = -100.0

func _process(delta: float) -> void:
	# Progressively shift the position offset over time
	scroll_offset.x += scroll_speed * delta
