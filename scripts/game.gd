extends Node2D


var state := State.PLAY

enum State {
	PLAY,
	FAILURE,
	LEADERBOARD_ENTRY,
	LEADERBOARD_DISPLAY,
	TITLE_SCREEN
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_state(new_state:State) -> void:
	pass
