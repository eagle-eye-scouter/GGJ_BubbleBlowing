extends Node2D
class_name GumBubble

const MAX_RADIUS = 100
const MAX_VOLUME = 100
var volume = 2
var deflate_factor = 0.75 ## Multiplicative rate of decay per second
const SWALLOW_THRESHOLD = 0.001

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if volume > 0:
		volume -= (volume * (1-deflate_factor) * delta)
		volume = max(0, volume)
	volume = min(MAX_VOLUME, volume)
	
	var radius = min(MAX_RADIUS, pow(3 * volume / (4 * PI), 1.0/3.0))
	scale = Vector2.ONE * radius

## Volume = r^3
## V
