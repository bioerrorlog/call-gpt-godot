extends HTTPRequest

signal response_received(response)

var openai_url = "https://api.openai.com/v1/chat/completions"

func _init():
	connect("request_completed", self, "_on_request_completed")

func call_api(api_key: String, message: String, max_tokens: int = 100):
	var headers = [
		"Authorization: Bearer " + api_key,
		"Content-Type: application/json",
	]

	var postData = {
		"model": "gpt-3.5-turbo",
		"messages": [{"role": "user", "content": message}],
		"max_tokens": max_tokens
	}

	var error = self.request(openai_url, headers, false, HTTPClient.METHOD_POST, JSON.print(postData))
	if error != OK:
		print("HTTP request failed with error: ", error)

func _on_request_completed(result, response_code, headers, body):
	var response = JSON.parse(body.get_string_from_utf8())
	if "choices" in response.result and response.result["choices"].size() > 0:
		emit_signal("response_received", response.result.choices[0].message.content.split("\n"))
	else:
		emit_signal("response_received", [])
