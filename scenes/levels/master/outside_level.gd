extends Node2D


var item_scene: PackedScene = preload("res://scenes/items/powerup.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var containers = get_tree().get_nodes_in_group("item_containers")
	for container in containers:
		container.connect("open", _on_item_container_opened)

func _on_item_container_opened(pos, direction):
	var item = item_scene.instantiate()
	item.position = pos
	item.direction = direction
	$Items.call_deferred('add_child', item)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	

func _on_gate_player_entered_gate(_body: Object):
	create_tween().tween_property($Player, "speed", 0, 0.5)
	LevelTransition.change_scene("res://scenes/levels/level_2.tscn")

func _on_house_player_entered_signal():
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($Player/Camera2D, "zoom", Vector2(1.5,1.5), 1).set_trans(Tween.TRANS_SINE)
	tween.tween_property($Player, "modulate:a", 0, 1).from(0.5)

func _on_house_player_exited_signal():
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($Player/Camera2D, "zoom", Vector2(1,1), 1).set_trans(Tween.TRANS_SINE)
	tween.tween_property($Player, "modulate:a", 1, 1).from(0.5)
