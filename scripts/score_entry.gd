extends Node2D

# Components used to make a score entry
const ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
const NAME_LENGTH = 3

# Components being display
@export var p_name: Label
@export var p_score: Label

# Current position in the name being edited
var name_pos = 0
# Current letter in the alphabet being selected
var alphabet_pos = 0

# Set the references to the labels and their default values
func _ready() -> void:
	p_name = $Name
	p_score = $Score
	update_name("AAA")
	update_score(000000)
	
func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_down")): # Next letter
		change_letter(1)
	elif (event.is_action_pressed("ui_up")): # Previous letter
		change_letter(-1)
	elif (event.is_action_pressed("ui_right")): # Next letter name
		change_name(1)
	elif (event.is_action_pressed("ui_left")): # Previous letter name
		change_name(-1)
	elif (event.is_action_pressed("ui_accept")): # Confirm pressed
		if (name_pos != NAME_LENGTH-1): # Not selected last letter
			change_name(1)
		else: # Confirming last letter
			pass

# Calculates new alphabet index when selecting letters
func change_letter(dir: int):
	alphabet_pos = (alphabet_pos + dir) % ALPHABET.length()
	p_name.text[name_pos] = ALPHABET[alphabet_pos]

# Calculates new letter index in the name
func change_name(dir: int):
	name_pos = (name_pos + dir) % NAME_LENGTH
	alphabet_pos = ALPHABET.find(p_name.text.chr(name_pos))

func update_name(new_name: String):
	p_name.text = new_name

func update_score(new_score: int):
	p_score.text = str(new_score)
