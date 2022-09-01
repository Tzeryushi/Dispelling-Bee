extends Node

var camera = null

func reverse_string(text:String) -> String:
	var rev_array = ""
	var digit = text.length() - 1
	for i in text:
		rev_array += text.substr(digit, 1)
		digit -= 1
	return rev_array
