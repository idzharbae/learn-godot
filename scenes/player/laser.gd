extends Node2D

const projectile_speed = 1200
var damage: int = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	($Timer as Timer).start()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= projectile_speed * delta * cos(rotation)
	position.x += projectile_speed * delta * sin(rotation)

func shoot():
	visible = true


func _on_timer_timeout():
	queue_free()

func _on_body_entered(body):
	if body.has_method("on_hit"):
		body.on_hit(damage, "player")
	visible = false
	queue_free()
