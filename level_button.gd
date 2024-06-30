extends Node2D

@export var level_number:int;
@export var unlocked: bool = false
@export var completed: bool = false
@export var level_popup: PackedScene
var digit_container: HBoxContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	digit_container = $HBoxContainer
	display_level_number()
	
	# Connect the button pressed signal to show the popup
	connect("pressed", Callable(self, "_on_texture_button_pressed"))
	
	self.disabled = not unlocked

func display_level_number():
	# Clear existing digits
	digit_container.clear()
	
	# Convert level_number to a string and create TextureRects for each digit
	var digits = str(level_number).split('')
	for digit in digits:
		var texture_rect = TextureRect.new()
		var texture_path = "res://art/assets/levels_map/num" + digit + ".png"
		texture_rect.texture = load(texture_path)
		digit_container.add_child(texture_rect)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_pressed():
	if unlocked:
		var popup_instance = level_popup.instantiate()
		popup_instance.set_level_info(level_number, completed, get_missions())
		popup_instance.popup_centered()
		get_tree().root.add_child(popup_instance)

func get_missions():
	return [
		{"name": "Mission 1", "completed": true},
		{"name": "Mission 2", "completed": false},
		{"name": "Mission 3", "completed": false}
	]
