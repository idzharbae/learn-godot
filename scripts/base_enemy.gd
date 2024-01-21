extends CharacterBody2D

class_name BaseEnemy

var hitpoints: int
var direction: Vector2
var HPBar: TextureProgressBar
var speed: float
var original_position: Vector2
var body_hit_sound: AudioStreamPlayer2D

@onready var body_image = self
@onready var body_collision = self
	
func init_hp(hp_value):
	hitpoints = hp_value
	HPBar.max_value = hitpoints
	HPBar.value = hitpoints

func chase(target: CharacterBody2D):
	body_collision.look_at(target.global_position)
	direction = (target.position - position).normalized()
	velocity = direction * 200
	move_and_slide()
	
func chase_path_find(target: CharacterBody2D, navigation_agent: NavigationAgent2D):
	body_collision.look_at(target.global_position)
	var next_path_pos: Vector2 = navigation_agent.get_next_path_position()
	var direction: Vector2 = (next_path_pos - global_position) .normalized()
	velocity = direction * speed
	move_and_slide()
	
func backoff_from_chase(navigation_agent: NavigationAgent2D):
	body_collision.look_at(original_position)
	var next_path_pos: Vector2 = navigation_agent.get_next_path_position()
	var direction: Vector2 = (next_path_pos - global_position) .normalized()
	velocity = direction * speed
	move_and_slide()

func death_animation_and_free():
	var tween = get_tree().create_tween()
	body_image.modulate = Color(3,3,3,1)
	tween.set_loops(4)
	tween.tween_property(body_image, "modulate:a", 0.33, 0.25).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(body_image, "modulate:a", 1, 0.25).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_callback(queue_free)

func take_damage_animation():
	var tween = get_tree().create_tween()
	tween.tween_property(body_image, "modulate", Color(3,3,3,1), 0.1)
	tween.tween_property(body_image, "modulate", Color(1,1,1,1), 0.1)

func on_hit(damage: int, source: String):
	if source != "player":
		return
	
	if body_hit_sound:
		body_hit_sound.play()
	hitpoints -= damage
	HPBar.value = hitpoints
	if hitpoints < 1:
		hitpoints = 0
		death_animation_and_free()
	else:
		take_damage_animation()
