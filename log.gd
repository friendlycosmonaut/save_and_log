class_name Log

## Path for the log file; see Save for precise location
const PATH = "user://log"
## Change if properties of the Log changes (post release)
## Note this may be kept separate from your project version
const VERSION = "1.0.0"


## Clear the log file and initialise with device details
static func init() -> void:
	Save._save_to_json(PATH, {
		"version": VERSION,
		"info": {
			"OS": OS.get_name(),
			"version": OS.get_version(),
			"processor_name": OS.get_processor_name(),
			"model_name": OS.get_model_name(),
			"video_adapter_driver_info": OS.get_video_adapter_driver_info(),
			"is_debug_build": OS.is_debug_build(),
			"is_sandboxed": OS.is_sandboxed(),
			"executable_path": OS.get_executable_path(),
			
			## We will update these at every new log
			"static_memory_usage": null,
			"memory_info": null,
			"ticks_msecs": null,
			"window_size": null,
			"screen_size": null,
			"refresh_rate": null,
			"fps": null,
		}
	})


## Prints and Logs a string
static func PRINT(args) -> void:
	Log._log(args)
	print(args)


## Prints and Logs a string
## User can use to earmark later work needed if codeblock runs
static func TODO(args) -> void:
	Log.PRINT(args)
	push_warning(args)


## Prints and Logs an error and crashes the game deliberately
static func CRASH(message: String) -> void:
	message = "INTENTIONAL CRASH: " + message
	Log.PRINT(message)
	assert(false, message)


## Adds a string to Log file
## Not to be used directly
static func _log(string) -> void:
	if not FileAccess.file_exists(PATH):
		init()
	
	var data = Save._load_from_json(PATH)
	
	## Add the new log at current time
	var ticks = str(Time.get_ticks_msec())
	data[ticks] = string
	
	## Capture current system info
	data["info"]["memory_info"] = OS.get_memory_info()
	data["info"]["static_memory_usage"] = OS.get_static_memory_usage()
	data["info"]["ticks_msecs"] = ticks
	data["info"]["window_size"] = DisplayServer.window_get_size()
	data["info"]["screen_size"] = DisplayServer.screen_get_size()
	data["info"]["refresh_rate"] = DisplayServer.screen_get_refresh_rate()
	data["info"]["fps"] = Engine.get_frames_per_second()
	Save._save_to_json(PATH, data)
