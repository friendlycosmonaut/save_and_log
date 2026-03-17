class_name Save

## The following class functions provide:
## 1. Read/Write to the player's Save folder
## 2. Read Resources from project folder
## Godot supplies JSON encoding and parsing, used here for save/load
## You may want to explore encryption & other formats for large or sensitive data

## This will be the default save path - change at will!
const PATH = "user://saves/"

## You do not need to include ".json" in the path name; this is appended 
## Following example will create items.json containing an inventory dictionary
## save_property("inventory", "item", "banana")
static func save_property(file_name: String, property_name: String, property: Variant) -> void:
	var path = PATH + file_name
	var data = _load_from_json(path)
	data[property_name] = JSON.from_native(property)
	_save_to_json(path, data)

## As above, you do not need to include ".json" in the path name
## Example: var health = load_property("game", "health", 10)
## If the property does not exist, function returns default (10)
static func load_property(file_name: String, property_name: String, default: Variant = null) -> Variant:
	var path = PATH + file_name
	var data = _load_from_json(path)
	if property_name in data:
		return JSON.to_native(data[property_name])
	else:
		return default


## Wipes everything in the user's save area
static func global_wipe() -> void:
	if DirAccess.dir_exists_absolute(PATH):
		_remove_recursive(PATH)


## The following functions are not recommended for use by the user
## as you may accidentally overwrite an entire file
## and/or save it outside the intended User PATH.
## Use the _property functions to save each property

## Creates a file at the given path containing dictionary data
static func _save_to_json(path: String, dict: Dictionary) -> void:
	path += ".json"
	if not DirAccess.dir_exists_absolute(PATH):
		DirAccess.make_dir_recursive_absolute(PATH)
	
	var data = JSON.stringify(dict, "\t")
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data)

## Loads a dictionary from the given path
## Consider using load_property for gameplay to ensure consistency
## Will return an empty dictionary if no file is found
## If you do not specify full path, it will default to the project path
static func _load_from_json(path: String) -> Dictionary:
	path += ".json"
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var text = file.get_as_text()
		return JSON.parse_string(text)
	else:
		return {}

## Recursively removes all content from a given folder/path
static func _remove_recursive(path: String) -> void:
	var directory = DirAccess.open(path)
	
	## List directory content
	directory.list_dir_begin()
	var file_name = directory.get_next()
	while file_name != "":
		if directory.current_is_dir():
			_remove_recursive(path + "/" + file_name)
		else:
			directory.remove(file_name)
			print("Removed: " + file_name)
		file_name = directory.get_next()
	directory.remove(path)
