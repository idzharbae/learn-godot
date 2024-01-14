extends CharacterBody2D

@onready var HPBar = $HPBar
var hitpoints = 100

func on_hit(damage: int, source: String):
	if source != "player":
		return
	
	var tween = get_tree().create_tween()
	hitpoints -= damage
	HPBar.value = hitpoints
	if hitpoints < 1:
		hitpoints = 0
		$CarImage.modulate = Color(3,3,3,1)
		tween.set_loops(4)
		tween.tween_property($CarImage, "modulate:a", 0.33, 0.25).set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property($CarImage, "modulate:a", 1, 0.25).set_trans(Tween.TRANS_BOUNCE)
		tween.tween_callback($"..".queue_free)
	else:
		tween.tween_property($CarImage, "modulate", Color(3,3,3,1), 0.1)
		tween.tween_property($CarImage, "modulate", Color(1,1,1,1), 0.1)
