extends Node


var max_laser_amount = 30
signal laser_updated
var laser_amount = 30:
	get:
		return laser_amount
	set(value):
		laser_amount = value
		laser_updated.emit()

var max_grenade_amount = 5
signal grenade_updated
var grenade_amount = 5:
	get:
		return grenade_amount
	set(value):
		grenade_amount = value
		grenade_updated.emit()

var player_max_hp = 100
signal player_hp_updated
var player_hp: int = 50:
	get:
		return player_hp
	set(value):
		player_hp = max(0, min(value, player_max_hp))
		player_hp_updated.emit()
		if player_hp <= 0:
			get_tree().change_scene_to_file("res://scenes/ui/gameover.tscn")
