extends TextureProgressBar

# Ignore parent rotation
func _process(delta):
	var rot = -get_parent().rotation
	var s = sin(rot)
	var c = cos(rot)
	
	var xx = position.x - get_parent().position.x
	var yy = position.y - get_parent().position.y
	
	var xnew = xx * c - yy * s
	var ynew = xx * s + yy * c
	
	position.x = xnew + get_parent().position.x
	position.y = ynew + get_parent().position.y
