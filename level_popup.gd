extends Popup

@export var play_scene: PackedScene
@export var mission_scene: PackedScene

var level_label: Label
var missions_container: VBoxContainer
var play_button: TextureButton
var level_checkmark: TextureRect

func _ready():
	level_label = $VBoxContainer/LevelNumber
	missions_container = $VBoxContainer/Missions
	play_button = $VBoxContainer/TextureButton
	level_checkmark = $VBoxContainer/CheckmarkLevel
	
	# Connect the play button pressed signal
	play_button.connect("pressed", Callable(self, "_on_texture_button_pressed"))

func set_level_info(level_number: int, completed: bool, missions: Array):
	level_label.text = "Level " + str(level_number)
	
	# Clear existing missions
	missions_container.clear()
	
	for mission_data in missions:
		var mission_instance = mission_scene.instantiate()
		mission_instance.mission_name = mission_data["name"]
		mission_instance.completed = mission_data["completed"]
		missions_container.add_child(mission_instance)
	# Display level completed checkmark
	level_checkmark.visible = completed
	
func _on_texture_button_pressed():
	var play_scene_instance = play_scene.instance()
	get_tree().change_scene_to(play_scene_instance)
