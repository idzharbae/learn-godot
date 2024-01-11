extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$GPUParticles2D.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not $GPUParticles2D.emitting:
		queue_free()
