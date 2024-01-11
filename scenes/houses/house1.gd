extends Area2D

signal player_entered_signal
signal player_exited_signal

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	player_entered_signal.emit()


func _on_body_exited(body):
	player_exited_signal.emit()
