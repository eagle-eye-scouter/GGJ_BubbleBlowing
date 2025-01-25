extends Control

func _ready() -> void:
	get_node("ButtonPlay").grab_focus()

func _on_button_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/scroll_world.tscn")

func _on_button_leaderboard_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/scoreboard.tscn")

func _on_button_exit_pressed() -> void:
	get_tree().quit()
