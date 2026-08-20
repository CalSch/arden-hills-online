extends Node3D

@onready var mpp: MPPlayer = get_parent()


func _ready() -> void:
	mpp.player_ready.connect(_player_ready)

func _process(delta: float) -> void:
	if not mpp.is_local:
		return
	position.x += Input.get_axis("move_left","move_right") * delta * 6
	position.z -= Input.get_axis("move_back","move_forth") * delta * 6 # do -= bc godot is bad and uses a right-handed coordinate system

func _player_ready():
	print("im ready!")
