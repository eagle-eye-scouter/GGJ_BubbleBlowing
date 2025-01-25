extends Node2D
class_name Obstacle

var hurtbox : Area2D
var starting_position : Vector2

@export var velocity : float = 10
@export var direction := Vector2.ONE
var state := State.IDLE 
enum State {
	IDLE,
	ACTIVE,
	RESET
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hurtbox.area_entered.connect(_on_area_entered)
	starting_position = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == State.ACTIVE:
		global_position += direction.normalized() * velocity * delta
		_active_process(delta)
	elif state == State.RESET:
		global_position = starting_position
	
	if abs(global_position.x) > 1000:
		state = State.RESET


func _on_area_entered(area:Node2D):
	if area is GumBubble:
		area.pop()


func _active_process(delta: float) -> void:
	pass
