extends Node2D

@onready var player : Player = $Player
@onready var player_bubble : GumBubble = player.bubble
@onready var scrolling : Node2D = $Dynamic
@onready var fixed : Node2D = $Fixed

var virtual_elevation : float = 0.0 ## Used for spawning enemies, keeping track of score
var speed_of_ascent = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fixed.global_position.y = player.global_position.y


func _resync_dynamic_scrolling() -> void:
	var offset = scrolling.global_position
	var children = scrolling.get_children()
	for child in children:
		child.global_position -= offset
	scrolling.global_position = Vector2.ZERO
