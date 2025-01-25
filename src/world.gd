extends Node2D

@onready var player : Player = $Dynamic/Player
@onready var player_bubble : GumBubble = $Dynamic/Player/Bubble
#@onready var gravity_field : Area2D = $Fixed/GravityZone

var virtual_elevation : float = 0.0 ## Used for spawning enemies, keeping track of score
var player_levity : float = 1.0
var speed_of_ascent = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var speed_of_ascent : float = player_bubble.volume * player_levity
	#gravity_field.gravity_direction = Vector2(0, speed_of_ascent)
	virtual_elevation += speed_of_ascent * delta
