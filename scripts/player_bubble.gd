extends Node2D
class_name GumBubble

signal popped()

const MAX_RADIUS = 100
const MAX_VOLUME = 100
const POP_VOLUME_THRESHOLD = 2
const SCALING_FACTOR := 0.5
@export var volume = 0
var deflate_factor = 0.75 ## Multiplicative rate of decay per second
const SWALLOW_THRESHOLD = 0.001
const LEVITY : float = 4000.0

var state := State.START
enum State {
	START,
	STABLE,
	POPPED,
	SWALLOWED,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if volume > 0:
		volume -= (volume * (1-deflate_factor) * delta)
		volume = max(0, volume)
	volume = min(MAX_VOLUME, volume)
	
	_update_state()
	print(volume)
	
	#var radius = min(MAX_RADIUS, pow(3 * volume / (4 * PI), 1.0/3.0)) * SCALING_FACTOR
	scale = Vector2.ONE * radius()


func radius():
	return min(MAX_RADIUS, pow(3 * volume / (4 * PI), 1.0/3.0)) * SCALING_FACTOR


func pop():
	_set_state(State.POPPED)
	print("I got popped!")


func activate():
	_set_state(State.STABLE)


func get_lift(delta:float=1.0):
	if state == State.SWALLOWED or state == State.POPPED:
		return Vector2.ZERO
	var levity = -1 * volume * LEVITY
	return Vector2(0, levity * delta)


func _set_state(new_state:State):
	match new_state:
		State.POPPED:
			popped.emit()
			visible = false
		_:
			pass
	state = new_state


func _update_state():
	match state:
		State.STABLE:
			if volume < SWALLOW_THRESHOLD:
				volume = SWALLOW_THRESHOLD
			elif volume > POP_VOLUME_THRESHOLD:
				pop()
		State.POPPED:
			pass
		State.SWALLOWED:
			pass
		_:
			if volume <= SWALLOW_THRESHOLD:
				_set_state(State.SWALLOWED)
			elif volume > POP_VOLUME_THRESHOLD:
				pop()
	pass


func _on_area_entered(area:Area2D):
	if area.is_in_group("GumBubble"):
		print("Trying to pop")
		area.pop()
	print("Area ", area, " entered obstacle ", self)
