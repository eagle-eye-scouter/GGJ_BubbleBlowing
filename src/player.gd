extends Node2D

const HORIZONTAL_SPEED : float = 1000.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var vector : Vector2 = Input.get_vector("player_left", "player_right", "ui_up", "ui_down")
	
	self.position.x += delta * vector.x * HORIZONTAL_SPEED
	#print("delta", delta, ";vector", vector)
	
	pass
