extends Node

var save_file: ConfigFile = ConfigFile.new()

func save_api(key: String) -> void:
	print("Start saving api key")
	save_file.set_value("credentials", "api_key", key)
	save_file.save("user://credentials.cfg")
	print("Save api key finished")

func load_api() -> String:
	print("Start loading api key")	
	var error = save_file.load("user://credentials.cfg")
	if error == OK:
		var api_key = save_file.get_value("credentials", "api_key")
		print("Load api key finished")
		return api_key
	else:
		print("Error: Loading api key failed")
		return ""
