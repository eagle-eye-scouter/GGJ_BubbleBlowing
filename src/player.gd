extends Node2D

const HORIZONTAL_SPEED : float = 1000.0
const VERTICAL_SPEED : float = 900.0
const INFLATE_SPEED : float = 90.0
const DEFLATE_SPEED : float = 45.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var vector : Vector2 = Input.get_vector("player_left", "player_right", "player_up", "player_down")
	
	self.position = vector * Vector2(HORIZONTAL_SPEED, VERTICAL_SPEED) * delta
	#print("delta", delta, ";vector", vector)
	
	
	
	pass
