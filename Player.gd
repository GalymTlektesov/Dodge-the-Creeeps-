extends Area2D

export var speed = 400 #Использование ключевого слова export у первой переменной speed позволяет устанавливать ее значение в Инспекторе
export var screenLimit = 25
var screen_size
signal hit
var target = Vector2()

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func start(pos):
	position = pos
	target = pos
	show()
	$CollisionShape2D.disabled = false

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position

func _process(delta):
	var velocity = Vector2()
	if position.distance_to(target) > 10:
		velocity = target - position
	
	_anim_controller(velocity)
	motion(velocity, delta)
	_limit()
	
func motion(velocity, delta):
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	position += velocity * delta
	
func _limit():
	position.x = clamp(position.x, screenLimit, screen_size.x - screenLimit)
	position.y = clamp(position.y, screenLimit, screen_size.y - screenLimit)

func _anim_controller(velocity):
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
