extends CharacterBody2D

var hitpoints: int
var direction: Vector2
var target: CharacterBody2D
var HPBar: TextureProgressBar

func _ready():
	hitpoints = 100
	var direction = Vector2.ZERO
	velocity = Vector2.ZERO
	HPBar = $DroneHP
	HPBar.max_value = hitpoints
	HPBar.value = hitpoints

func _process(delta):
	if target:
		direction = (target.position - position).normalized()
		look_at(target.position)
	
	velocity = direction * 200
	move_and_slide()

func on_hit(damage: int, source: String):
	if source != "player":
		return
	
	var tween = get_tree().create_tween()
	hitpoints -= damage
	HPBar.value = hitpoints
	if hitpoints < 1:
		hitpoints = 0
		$Sprite2D.modulate = Color(3,3,3,1)
		tween.set_loops(4)
		tween.tween_property($Sprite2D, "modulate:a", 0.33, 0.25).set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property($Sprite2D, "modulate:a", 1, 0.25).set_trans(Tween.TRANS_BOUNCE)
		tween.tween_callback(queue_free)
	else:
		tween.tween_property($Sprite2D, "modulate", Color(3,3,3,1), 0.1)
		tween.tween_property($Sprite2D, "modulate", Color(1,1,1,1), 0.1)



func _on_detection_body_entered(body):
	target = body

func _on_detection_body_exited(body):
	if body as CharacterBody2D == target:
		target = null
		direction = Vector2.ZERO
		get_tree().create_tween().tween_property($".", "rotation_degrees", 0, 0.5)
