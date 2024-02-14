class_name Save

## Godot supplies JSON encoding and parsing, used here for save/load
## You may want to explore encryption & other formats for large or sensitive data
## The following functions provide:
## 1. Read/Write to the player's Save folder
## 2. Read Resources from project folder

## The default user save location
## Change this if you would like to append eg. "save" to the root location
## NOTE that this is for PC and will vary on other platforms
## Windows: %APPDATA%\Godot\app_userdata\[project_name]
## Mac: ~/Library/Application Support/Godot/app_userdata/[project_name]
const ROOT_USER = "user://save/"
## Saves to the default Godot location
## You should not have to fiddle with this as it is already project dependent
const ROOT_RESOURCES = "res://resources/"

## Creates a file at the given path containing dictionary data
## Consider using save_data for gameplay to ensure consistency
## **If you do not specify full path, it will default to the project path**
## Example:
## save_data({ item: "banana" }, "items.json")
## This will create a file called items.json containing the dictionary
static func save_to_json(dict: Dictionary, path: String) -> void:
	var data = JSON.stringify(dict, "\t")
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data)

## Loads a dictionary from the given *full path*
## Consider using load_data for gameplay to ensure consistency
## Will return an empty dictionary if no file is found
## If you do not specify full path, it will default to the project path
static func load_from_json(path) -> Dictionary:
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var text = file.get_as_text()
		var data = JSON.parse_string(text)
		return data
	else:
		return {}

## Attempts to loads a json file from within the Godot project resources
## Returns either a Dictionary or Null if no file was found at the given path
static func load_json_resource(path: String) -> Variant:
	return load_from_json(ROOT_RESOURCES + path)

## Wipes everything in the user's default save area
static func global_wipe() -> void:
	if DirAccess.dir_exists_absolute(ROOT_USER):
		_remove_recursive(ROOT_USER)

## Transforms the supplied path into the "full" appended user save path
## eg. if the USER_PATH_APPEND is "save/"
## _save_path("player.json") -> "user://save/player.json"
static func _appended_path(path) -> String:
	if not DirAccess.dir_exists_absolute(ROOT_USER):
		DirAccess.make_dir_absolute(ROOT_USER)
	return ROOT_USER + path

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
		file_name = directory.get_next()
	directory.remove(path)
