extends Node2D

@onready var player : Player = $Player
@onready var player_bubble : GumBubble = player.bubble
@onready var scrolling : Node2D = $Dynamic

var virtual_elevation : float = 0.0 ## Used for spawning enemies, keeping track of score
var player_levity : float = 1.0
var speed_of_ascent = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var speed_of_ascent : float = player_bubble.volume * player_levity
	var delta_ascent = speed_of_ascent * delta
	virtual_elevation += delta_ascent
	scrolling.global_position.y += delta_ascent
	_resync_scrolling()


func _resync_scrolling():
	var offset = scrolling.global_position
	var children = scrolling.get_children()
	for child in children:
		#children.append_array(child.get_children())
		child.global_position -= offset
	scrolling.global_position = Vector2.ZERO
