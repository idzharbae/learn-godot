extends CanvasLayer

# colors
var green: Color = Color("6bbfa3")
var red: Color = Color(0.9, 0, 0, 1)

@onready var laser_label: Label = $AmmoCounter/HboxContainer/Count
@onready var grenade_label: Label = $GrenadeCounter/HboxContainer/Count
@onready var hp_bar: TextureProgressBar = $MarginContainer/HealthBar

func _ready():
	Globals.connect("laser_updated", update_laser_count)
	Globals.connect("grenade_updated", update_grenade_count)
	Globals.connect("player_hp_updated", update_hp_count)
	update_laser_count()
	update_grenade_count()
	update_hp_count()

func update_laser_count():
	laser_label.text = str(Globals.laser_amount)
	laser_label.modulate = green if Globals.laser_amount > 0 else red

func update_grenade_count():
	grenade_label.text = str(Globals.grenade_amount)
	grenade_label.modulate = green if Globals.grenade_amount > 0 else red

func update_hp_count():
	hp_bar.value = Globals.player_hp
