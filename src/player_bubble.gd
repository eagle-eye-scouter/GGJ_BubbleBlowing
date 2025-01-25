extends Node2D
class_name GumBubble

const MAX_RADIUS = 100
const MAX_INFLATION = 100
const RADIUS_PER_INFLATION = MAX_RADIUS / MAX_INFLATION
var inflation = 20
var deflation_rate = 0.99 ## Subtractive rate of decay per second

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if inflation > 0:
		inflation -= (deflation_rate * delta)
		inflation = max(0, inflation)
	
	scale = Vector2.ONE * inflation
