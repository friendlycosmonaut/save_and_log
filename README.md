## Description
Two classes and scripts: **Save** for save/loading a dictionary to json files, and **Log** for logging strings to a log.json file along with user system data (eg. OS, version, current memory info).

## Instructions
Add the two files to your project as gdscripts. You may now use Save and Log classes.
Note that all of the following .json files will be created at the default user path. Check [Godot docs](https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html) for up to date info on sandboxing files.
- Windows: `%APPDATA%\Godot\app_userdata\[project_name]`
- Mac: `~/Library/Application Support/Godot/app_userdata/[project_name]`

Also note that you do not have to specify ".json" in the file path; this is assumed and appended automatically.

## Examples:
### Save
```
var player = { "health": 10, "gold": 230, "level": 7 }
Save.save_to_json(inventory, "user_save_1/player")
```

### Load
```
var player = Save.load_from_json("user_save_1/player")
```

### Log functionality
```
Log.PRINT("Game starting up...")
Log.TODO("Inventory should appear, work incomplete.") 
Log.CRASH("This code path should not have run - we are crashing on purpose to alert dev!")
```
