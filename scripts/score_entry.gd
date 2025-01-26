extends Node2D
class_name ScoreEntry

# Internal values
@export var p_name: String = "AAA"
@export var p_score: int = 0

# Components being displayed
var disp_name: Label
var disp_score: Label

func _ready() -> void:
	disp_name = $Name
	disp_score = $Score
	update_display()


func get_p_name():
	return p_name


func get_p_score():
	return p_score


func update_name(new_name):
	p_name = new_name


func update_score(new_score):
	p_score = new_score


func update_display():
	disp_name.text = p_name
	disp_score.text = "%05d" % p_score
