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

var sea_level := 0.0
var max_altitude := 0.0
var score = 0

var state := State.START
@onready var bubble : GumBubble = $Bubble
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

var bubble_stage_size = float(bubble.POP_VOLUME_THRESHOLD)/8
var _is_invulnerable : bool = false

enum State {
	START,
	ALIVE,
	DEAD,
	VICTORY,
	FINISHED,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bubble.popped.connect(_on_bubble_popped)
	_set_state(State.START)


func _process(delta: float) -> void:
	if Input.is_action_pressed("sacred_mode"):
		_is_invulnerable = true
		bubble._set_state(GumBubble.State.INVULNERABLE)
	if (sprite.get_animation() == "float"):
		sprite.set_frame(bubble.volume/bubble_stage_size)
	if (sprite.get_animation() == "abduction_begin"):
		linear_velocity = Vector2.ZERO
		gravity_scale = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("player_breath") or Input.is_action_pressed("player_up"):
		bubble.volume += INFLATE_SPEED
	match state:
		State.DEAD:
			_handle_death_animation(delta)
		State.VICTORY:
			_handle_victory_animation(delta)
		State.START:
			if bubble.volume >= BUBBLE_VOLUME_START_THRESHOLD:
				_set_state(State.ALIVE)
				bubble.activate()
		_:
			_handle_movement(delta)


func _handle_movement(delta: float) -> void:
	## First, slow down the speed, so that we can push it to the max.
	max_altitude = min(max_altitude, global_position.y)
	
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
	if (sprite.animation == "pop"):
		linear_velocity = Vector2(0, 0)
	else:
		gravity_scale = 1


func _handle_victory_animation(delta:float) -> void:
	pass


func kill() -> void:
	if _is_invulnerable:
		bubble.state = GumBubble.State.INVULNERABLE
		return
	if state != State.START:
		_set_state(State.DEAD)


func _on_bubble_popped():
	kill()


func _set_state(new_state:State):
	var new_animation = null
	match new_state:
		State.START:
			new_animation = "chew"
			sea_level = global_position.y
		State.ALIVE:
			timer.start()
			if state == State.ALIVE or state == State.DEAD or state == State.VICTORY:
				return
			new_animation = "float"
		State.DEAD:
			if state == State.DEAD or state == State.VICTORY or _is_invulnerable:
				return
			new_animation = "pop"
			print("Maximum elevation:", sea_level-max_altitude)
			calculate_score(false)
		State.VICTORY:
			if state == State.DEAD or state == State.VICTORY:
				return
			timer.stop()
			new_animation = "abduction_begin"
			gravity_scale = 0
		State.FINISHED:
			calculate_score(true)
			print("Victory elevation:", sea_level-max_altitude)
			print("Remaining Time: ", timer.time_left)
			end_game()
	if (new_animation != null && sprite.get_animation() != new_animation):
		sprite.play(new_animation)
		print("Current animation: " + sprite.get_animation())
	state = new_state


func _on_animated_sprite_2d_animation_finished() -> void:
	if (sprite.get_animation() == "chew"):
		sprite.play("float")
	if (sprite.get_animation() == "pop"):
		sprite.play("fall")
	if (sprite.get_animation() == "abduction_begin"):
		gravity_scale = 1
		sprite.play("abduction")
		get_tree().create_timer(2).timeout.connect(_finish)
	print("Current animation: " + sprite.animation)


func _finish():
	_set_state(State.FINISHED)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if (state == State.DEAD):
		end_game()


func end_game():
	var temp_score = "user://temp.cfg"
	var config_manager = ConfigFile.new()
	config_manager.set_value("P0", "score", score)
	config_manager.save(temp_score)
	get_tree().change_scene_to_file("res://scenes/scoreboard.tscn")


func _on_timer_timeout() -> void:
	_set_state(State.DEAD)


func calculate_score(victory: bool):
	var altitude = abs(max_altitude - sea_level)
	var new_score = altitude
	if (victory):
		new_score = altitude + (altitude * timer.time_left/10)
	if (score < new_score):
		score = new_score
	print("Calculated score: ", score)
	return score


func victory(egress:Node):
	_set_state(State.VICTORY)


func _on_timer_2_timeout() -> void:
	calculate_score(false)
