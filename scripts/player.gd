extends RigidBody2D
class_name Player

const HORIZONTAL_ACCELERATION : float = 2000.0
const VERTICAL_ACCELERATION : float = 1800.0
const ACCELERATION_RATE := Vector2(HORIZONTAL_ACCELERATION, VERTICAL_ACCELERATION)
const HORI_SPEED_MAX : float = 2000
const VERT_SPEED_MAX : float = 2000
const SPEED_MAX := Vector2(HORI_SPEED_MAX, VERT_SPEED_MAX)
const INFLATE_SPEED : float = 0.01
const DECELLERATION : float = 0.90
const DECCELERATION_RATE := Vector2(DECELLERATION, DECELLERATION)
const BUBBLE_VOLUME_START_THRESHOLD : float = 0.5

const SPRITE_GROUNDED := preload("res://assets/sprites/player_start_position.png") 
const SPRITE_FLOATING := preload("res://assets/guy_floating.png")


var state := State.START
@onready var bubble : GumBubble = $Bubble
@onready var sprite : Sprite2D = $Sprite


enum State {
	START,
	ALIVE,
	DEAD
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bubble.popped.connect(_on_bubble_popped)
	_set_state(State.START)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("player_breath"):
		bubble.volume += INFLATE_SPEED
	match state:
		State.DEAD:
			_handle_death_animation(delta)
		State.START:
			if bubble.volume >= BUBBLE_VOLUME_START_THRESHOLD:
				_set_state(State.ALIVE)
				bubble.activate()
		_:
			_handle_movement(delta)


func _handle_movement(delta: float) -> void:
	## First, slow down the speed, so that we can push it to the max.
	linear_velocity *= DECCELERATION_RATE
	
	## Get the raw input direction
	var vector : Vector2 = Input.get_vector("player_left", "player_right", "dummy", "player_down")
	
	## Scale the input direction by delta (which is the difference in time between cycles)
	vector = vector * delta
	
	## Piecewise multiply the vectors, to enable smoother transition to the desired direction
	## Clamp the result to prevent excessive speed
	linear_velocity = (linear_velocity + vector * ACCELERATION_RATE).clamp(-SPEED_MAX, SPEED_MAX)
	
	if state == State.ALIVE:
		linear_velocity += bubble.get_lift(delta)


func _handle_death_animation(delta: float) -> void:
	
	gravity_scale = 1


func kill() -> void:
	if state != State.START:
		_set_state(State.DEAD)


func _on_bubble_popped():
	kill()


func _set_state(new_state:State):
	match new_state:
		State.START:
			sprite.texture = SPRITE_GROUNDED
		State.ALIVE:
			sprite.texture = SPRITE_FLOATING
		State.DEAD:
			pass
	state = new_state
