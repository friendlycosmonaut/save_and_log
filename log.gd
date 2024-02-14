class_name Log

## Path for the log file; see Save for precise location
const PATH = "user://log"
## Change if details of the Log changes
## Note this may be kept separate from your project version
const VERSION = "1.0.0"

## Clear the log file and initialise with device details
## Call this at the start of your project
static func init() -> void:
	Save.save_to_json({
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
	}, PATH)

## Prints and Logs a string
static func PRINT(string) -> void:
	Log._log(string)
	print(string)

## Prints and Logs a string
## User can use to earmark later work needed if codeblock runs
static func TODO(string) -> void:
	Log.PRINT("TODO: " + string)

## Prints and Logs an error and crashes the game deliberately
static func CRASH(string) -> void:
	string += "\n INTENTIONAL CRASH"
	Log.PRINT(string)
	assert(false, string)

## Adds a string to Log file
## Not to be used directly
static func _log(string) -> void:
	var data = Save.load_from_json(PATH)
	
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
	Save.save_to_json(data, PATH)