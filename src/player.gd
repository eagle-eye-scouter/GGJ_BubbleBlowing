extends RigidBody2D

const HORIZONTAL_ACCELERATION : float = 2000.0
const VERTICAL_ACCELERATION : float = 1800.0
const ACCELERATION_RATE := Vector2(HORIZONTAL_ACCELERATION, VERTICAL_ACCELERATION)
const HORI_SPEED_MAX : float = 2000
const VERT_SPEED_MAX : float = 2000
const SPEED_MAX := Vector2(HORI_SPEED_MAX, VERT_SPEED_MAX)
const INFLATE_SPEED : float = 90.0
const DEFLATE_SPEED : float = 45.0
const DECELLERATION : float = 0.90
const DECCELERATION_RATE := Vector2(DECELLERATION, DECELLERATION)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	## First, slow down the speed, so that we can push it to the max.
	linear_velocity *= DECCELERATION_RATE
	
	## Get the raw input direction
	var vector : Vector2 = Input.get_vector("player_left", "player_right", "player_up", "player_down")
	
	## Scale the input direction by delta (which is the difference in time between cycles)
	vector = vector * delta
	
	## Piecewise multiply the vectors, to enable smoother transition to the desired direction
	## Clamp the result to prevent excessive speed
	linear_velocity = (linear_velocity + vector * ACCELERATION_RATE).clamp(-SPEED_MAX, SPEED_MAX)
	
	
	pass
