extends ItemContainer

func on_hit(_damage, _source):
	if opened:
		return
	
	$Lid.visible = false
	var marker = $Markers.get_child(randi_range(0, $Markers.get_child_count() - 1 ))
	open.emit(marker.global_position, current_direction)
	opened = true
	
