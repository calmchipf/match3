extends CanvasLayer

@onready var wait_timer = $WaitTimer


# Called when the node enters the scene tree for the first time.
func _ready():
	if $AnimationPlayer:
		$AnimationPlayer.play("RESET")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_start_pressed():
	wait_timer.start(0.5)
	if $AnimationPlayer:
		$AnimationPlayer.play("transition")
	await wait_timer.timeout
	get_tree().change_scene_to_file("res://scene/game_window.tscn")
	pass # Replace with function body.
