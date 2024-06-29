extends Node2D

enum {wait,move}
var state;

@export var width:int;
@export var height:int;
@export var x_start:int;
@export var y_start:int;
@export var offset:int;
@export var y_offset:int;

var possible_pieces = [
	preload("res://scene/yellow_piece.tscn"),
	preload("res://scene/green_piece.tscn"),
	preload("res://scene/blue_piece.tscn"),
	preload("res://scene/pink_piece.tscn"),
	preload("res://scene/red_piece.tscn")
];

var all_pieces=[];
var piece_one=null;
var piece_two=null;
var last_place= Vector2(0,0);
var last_direction= Vector2(0,0);
var move_checked=false;
# Called when the node enters the scene tree for the first time.

var first_touch = Vector2(0,0);
var final_touch = Vector2(0,0);
var controlling = false;

func _ready():
	state = move;
	randomize();
	all_pieces = make_2d_array();
	spawn_pieces()

func make_2d_array():
	var array = [];
	for i in width:
		array.append([]);
		for j in height:
			array[i].append(null);
	return array;

func spawn_pieces():
	for i in width:
		for j in height:
			var rand = floor(randi_range(0,possible_pieces.size()-1));
			var loops = 0;
			var piece = possible_pieces[rand].instantiate();
			
			
			while(check_match(i,j,piece.colour)&&loops<100):
				rand = floor(randi_range(0,possible_pieces.size()-1));
				loops +=1;
				piece = possible_pieces[rand].instantiate();
				
					
			
			add_child(piece);
			piece.set_position(grid_to_pixel(i,j));
			all_pieces[i][j] = piece;

func check_match(i,j,color):
	if i>1 :
		if(all_pieces[i-1][j] != null && all_pieces[i-2][j] != null):
			if(all_pieces[i-1][j].colour == color && all_pieces[i-2][j].colour == color):
				return true;
	if j>1 :
		if(all_pieces[i][j-1] != null && all_pieces[i][j-2] != null):
			if(all_pieces[i][j-1].colour == color && all_pieces[i][j-2].colour == color):
				return true;
	return false;

func grid_to_pixel(column, row):
	var new_x = x_start+offset*column;
	var new_y = y_start+(-offset*row);
	return Vector2(new_x, new_y);

func pixel_to_grid(pixel_x, pixel_y):
	var new_x = roundi((pixel_x-x_start)/offset);
	var new_y = roundi((pixel_y-y_start)/(-offset));
	return Vector2(new_x,new_y);

func is_in_grid(column , row):
	if column >= 0 && column < width:
		if row >= 0 && row < height:
			return true;
	return false;

func touch_input():
	if Input.is_action_just_pressed("ui_touch"):
		first_touch = get_global_mouse_position();
		var grid_position = pixel_to_grid(first_touch.x,first_touch.y);
		if is_in_grid(grid_position.x, grid_position.y):
			controlling = true;
	if Input.is_action_just_released("ui_touch"):
		final_touch = get_global_mouse_position();
		var grid_position = pixel_to_grid(final_touch.x,final_touch.y);
		if is_in_grid(grid_position.x, grid_position.y)&& controlling:
			controlling=false;
			touch_difference(pixel_to_grid(first_touch.x,first_touch.y),grid_position);
	pass;
func swap_piece(column,row, direction):
	var first_piece = all_pieces[column][row];
	var other_piece = all_pieces[column+direction.x][row+direction.y];
	if(first_piece!=null && other_piece!=null):
		store_info(first_piece,other_piece, Vector2(column,row),direction);
		state = wait;
		all_pieces[column][row]=other_piece;
		all_pieces[column+direction.x][row+direction.y]=first_piece;
		first_piece.move(grid_to_pixel(column+direction.x,row+direction.y));
		other_piece.move(grid_to_pixel(column,row));
		if !move_checked:
			find_matches();
	
func swap_back():
	if piece_one!=null && piece_two!=null:
		swap_piece(last_place.x,last_place.y,last_direction );
	state=move;
	move_checked=false;
	
		
func store_info(first_piece, other_piece,place, direction):
	piece_one = first_piece;
	piece_two= other_piece;
	last_place=place;
	last_direction = direction;
	
	
func touch_difference(grid_1, grid_2):
	var differenece = grid_2-grid_1;
	if abs(differenece.x)> abs(differenece.y):
		if differenece.x > 0:
			swap_piece(grid_1.x, grid_1.y, Vector2(1,0));
		elif differenece.x<0:
			swap_piece(grid_1.x, grid_1.y, Vector2(-1,0));
	elif abs(differenece.y)> abs(differenece.x):
		if differenece.y > 0:
			swap_piece(grid_1.x, grid_1.y, Vector2(0,1));
		elif differenece.y<0:
			swap_piece(grid_1.x, grid_1.y, Vector2(0,-1));
		
func _process(delta):
	if state==move:
		touch_input();


func find_matches():
	for column in range(width):
		for row in range(height):
			if all_pieces[column][row] != null:
				var current_color = all_pieces[column][row].colour;
				if column > 0 && column < width - 1:
					if all_pieces[column - 1][row] != null && all_pieces[column + 1][row] != null:
						if all_pieces[column - 1][row].colour == current_color && all_pieces[column + 1][row].colour == current_color:
							mark_matched_and_dim(column - 1, row);
							mark_matched_and_dim(column, row);
							mark_matched_and_dim(column + 1, row);
				if row > 0 && row < height - 1:
					if all_pieces[column][row - 1] != null && all_pieces[column][row + 1] != null:
						if all_pieces[column][row - 1].colour == current_color && all_pieces[column][row + 1].colour == current_color:
							mark_matched_and_dim(column, row - 1);
							mark_matched_and_dim(column, row);
							mark_matched_and_dim(column, row + 1);
	get_parent().get_node("destroy_timer").start();

func destroy_matched():
	var was_matched = false;
	for i in width:
		for j in height:
			if all_pieces[i][j] != null:
				if all_pieces[i][j].matched:
					all_pieces[i][j].queue_free();
					all_pieces[i][j] = null;
					was_matched=true;
	move_checked=true;
	if was_matched:
		get_parent().get_node("collapse_timer").start();
	else:
		swap_back();

func mark_matched_and_dim(column, row):
	all_pieces[column][row].matched = true
	all_pieces[column][row].dim();

func collapse_columns():
	for i in width:
		for j in height:
			if all_pieces[i][j]==null:
				for k in range(j+1, height):
					if all_pieces[i][k] != null:
						all_pieces[i][k].move(grid_to_pixel(i,j));
						all_pieces[i][j]= all_pieces[i][k];
						all_pieces[i][k]=null;
						break;
	
	get_parent().get_node("refill_timer").start();

func refill_columns():
	for i in width:
		for j in height:
			if all_pieces[i][j]==null:
				var rand = floor(randi_range(0,possible_pieces.size()-1));
				var loops = 0;
				var piece = possible_pieces[rand].instantiate();
				while(check_match(i,j,piece.colour)&&loops<100):
					rand = floor(randi_range(0,possible_pieces.size()-1));
					loops +=1;
					piece = possible_pieces[rand].instantiate();
				
				add_child(piece);
				piece.set_position(grid_to_pixel(i,j-y_offset));
				piece.move(grid_to_pixel(i,j));
				all_pieces[i][j] = piece;
	after_refill();
	
func after_refill():
	for i in width:
		for j in height:
			if all_pieces[i][j] != null:
				if check_match(i,j,all_pieces[i][j].colour):
					find_matches();
					get_parent().get_node("destroy_timer").start();
					return;
	state=move;
	move_checked=false;

func _on_destroy_timer_timeout():
	destroy_matched()


func _on_collapse_timer_timeout():
	collapse_columns();


func _on_refill_timer_timeout():
	refill_columns()
