extends Node2D

@export var colour:String;
var move_tween;
var matched = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	move_tween=get_node("move_tween");
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func move(target):
	var tween: Tween = create_tween();
	tween.tween_property(self,"position",target,0.2).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT);

func dim():
	var sprite = get_node("Sprite2D");
	sprite.modulate = Color(1,1,1,0.5);
		

