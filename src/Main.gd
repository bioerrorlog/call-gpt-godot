extends Node2D

var DIR = OS.get_executable_path().get_base_dir()
var interpreter_path = DIR.plus_file("python/venv/bin/python3.10")
var script_path = DIR.plus_file("python/src/talk.py")

var dialogues = []
var dialogue_index = 0

onready var dialogue_label = $CanvasLayer/Dialogue
onready var user_input = $CanvasLayer/UserInput
onready var save_input = $CanvasLayer/SaveInput
onready var save_manager = preload("res://src/SaveManager.gd").new()

func _ready():
	if !OS.has_feature("standalone"): # if NOT exported version
		interpreter_path = ProjectSettings.globalize_path("python/venv/bin/python3.10")
		script_path = ProjectSettings.globalize_path("res://python/src/talk.py")

	display_dialogue()

func _on_TalkButton_pressed():
	talk(user_input.text)

func _on_SaveButton_pressed():
	save_manager.save_api(save_input.text)

func display_dialogue():
	if dialogue_index < dialogues.size():
		dialogue_label.text = dialogues[dialogue_index]
	else:
		print("End of the dialogue")

func talk(user_text: String):
	print("talk started")
	var output = []
	var api_key = save_manager.load_api()

	var exit_code = OS.execute(interpreter_path, [script_path, user_text, api_key], true, output)
	if exit_code == 0:
		print("Python talk script output: ", output)
		dialogues = output
		dialogue_index = 0
		display_dialogue()
	else:
		print("Python talk script error. Exit code: ", exit_code)
