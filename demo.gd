extends Control

@onready var icon = $Icon
@onready var position_label = $Icon/Label
@onready var clicks_label = $Clicks

var clicks = 0

func position_icon(new_position):
	icon.position = new_position - icon.size/2
	position_label.text = str(int(icon.position.x)) + ", " + str(int(icon.position.y))


func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		position_icon(event.position)
		clicks = clicks + 1
		clicks_label.text = "Clicks: " + str(clicks)

func _on_save_pressed() -> void:
	Save.save_property("game", "icon_position", icon.position)
	Save.save_property("game", "clicks", clicks)

func _on_load_pressed() -> void:
	var pos = Save.load_property("game", "icon_position", Vector2.ZERO)
	position_icon(pos)
	
	clicks = Save.load_property("game", "clicks", 0)
	clicks_label.text = "Clicks: " + str(clicks)


func _on_wipe_pressed() -> void:
	Save.global_wipe()


func _on_play_pressed() -> void:
	Log.TODO("Whoops! We haven't made the game yet...")


func _on_crash_pressed() -> void:
	Log.CRASH("Something has gone seriously wrong!")
