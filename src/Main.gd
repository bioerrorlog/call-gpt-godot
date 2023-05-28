extends Node2D

var dialogues = []
var dialogue_index = 0

onready var dialogue_label = $CanvasLayer/Dialogue
onready var user_input = $CanvasLayer/UserInput
onready var save_input = $CanvasLayer/SaveInput

onready var save_manager = preload("res://src/SaveManager.gd").new()
onready var openai_api = preload("res://src/OpenAIApi.gd").new()

func _ready():
	add_child(openai_api)
	openai_api.connect("response_received", self, "_on_response_received")

	display_dialogue()

func display_dialogue():
	if dialogue_index < dialogues.size():
		dialogue_label.text = dialogues[dialogue_index]
	else:
		print("End of the dialogue")

func talk(user_text: String):
	var api_key = save_manager.load_api()
	openai_api.call_api(api_key, user_text)

func _on_TalkButton_pressed():
	talk(user_input.text)

func _on_SaveButton_pressed():
	save_manager.save_api(save_input.text)

func _on_response_received(response: Array):
	dialogues = response
	dialogue_index = 0
	display_dialogue()
