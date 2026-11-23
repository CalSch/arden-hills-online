extends CharacterBody3D

@onready var mpp: MPPlayer = get_parent()

@export var speed: float = 30
@export var sensitivity: float = 0.003

func _ready() -> void:
	mpp.player_ready.connect(_player_ready)

func _process(delta: float) -> void:
	if not mpp.is_local:
		return
	
	var movement = Vector3(
		Input.get_axis("move_left","move_right") * delta * speed,
		0,
		-Input.get_axis("move_back","move_forth") * delta * speed # do -= bc godot is bad and uses a right-handed coordinate system
	)
	
	if Input.is_action_just_pressed("jump"):
		velocity.y += 8.0
	
	#transform = transform.translated_local(Vector3(movement))
	velocity += movement.rotated(Vector3.UP, rotation.y)
	velocity.y -= 0.35
	velocity *= 0.8
	#move_and_collide(velocity)
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * sensitivity
		$Camera3D.rotation.x -= event.relative.y * sensitivity
	elif event is InputEventKey and event.is_action_pressed("mouse_toggle"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode==Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE
		

func _player_ready():
	if not mpp.is_local:
		return
	print("im ready!")
	$Camera3D.make_current()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
