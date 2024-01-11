extends Area2D

var powerup_types = ['ammo', 'grenade', 'health']
var type = powerup_types[randi_range(0, len(powerup_types) - 1)]
var movement_distance = randi_range(50, 150)
var direction: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	match type:
		'health':
			$Sprite2D.modulate = Color(1, 0.5, 0.5, 1)
			$PointLight2D.color = Color(1, 0.5, 0.5, 1)
		'grenade':
			$Sprite2D.modulate = Color(0.5, 1, 0.5, 1)
			$PointLight2D.color = Color(0.5, 1, 0.5, 1)
		'ammo':
			$Sprite2D.modulate = Color(0.5, 0.5, 1, 1)
			$PointLight2D.color = Color(0.5, 0.5, 1, 1)
	
	var tw = get_tree().create_tween()
	var target_position = position + direction * movement_distance
	tw.set_parallel(true)
	tw.tween_property(self, "position", target_position, 0.5)
	tw.tween_property(self, "scale", Vector2(1, 1), 0.3).from(Vector2(0, 0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	match type:
		'health':
			Globals.player_hp += 25
		'grenade':
			Globals.grenade_amount += 10
		'ammo':
			Globals.laser_amount += 10
	
	queue_free()
