extends Camera2D

const MIN_POS = Vector2(1920, 16100)
const MAX_POS = Vector2(11400, 18400)

@export var camera_speed: float = 20.0

var photoMode = false
var xOffset = 2580
var yOffset = 18300
var stars = 0
##@onready var time = $Timer/WaitTime

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zoom = Vector2(0.3,0.3)
	offset = Vector2(xOffset,yOffset)
	pass # Replace with function body.
	##Set zoom, and to the middle of the picture
	
func _physics_process(_delta: float) -> void:
	if photoMode:
		var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if input_direction != Vector2.ZERO:
			offset = offset + (input_direction * camera_speed)
			offset = offset.clamp(MIN_POS, MAX_POS)

func _input(event):
	if(!event.as_text().contains("Mouse")):
		if(event.keycode == KEY_R):
			if(!photoMode):
				make_current()
				photoMode = true
				zoom = Vector2(0.3,0.3)
				offset = Vector2(xOffset,yOffset)
				get_tree().paused = true
				
		if(photoMode):
			#if(event.keycode == KEY_A):
				#offset.x = offset.x-20
				#if(offset.x < 1920):
					#offset.x = 1920
			#elif(event.keycode == KEY_W):
				#offset.y = offset.y-20
				#if(offset.y < 16100):
					#offset.y = 16100
			#elif(event.keycode == KEY_D):
				#offset.x = offset.x+20
				#if(offset.x > 2580):
					#offset.x = 2580
			#elif(event.keycode == KEY_S):
				#offset.y = offset.y+20
				#if(offset.y > 18400):
					#offset.y = 18400
			if(event.keycode == KEY_Q):
				##self.property.zoom.set(self.property.get()*1.1)
				##print(self.propert.getZoom())
				zoom = 1.5*zoom
				if(zoom.x > 2.5):
					zoom = Vector2(2.5,2.5)
			elif(event.keycode == KEY_E):
				##self.property.zoom.set(self.property.get()*0.9)
				##print(self.property.getZoom())
				zoom = 0.75*zoom
				if (zoom.x < 0.3):
					zoom = Vector2(0.3,0.3)
			if(event.keycode == KEY_Z):
				take_photo()
				photoMode = false
				get_tree().paused = false
				
			##print(zoom)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	##Process movement and zoom
	##Trigger take_photo upon button press

func take_photo():
	##Process taking photo, and figure out 
	##Auto-aggro cryptid, send the player back to the level
	if(offset.x > 1):
		stars = 5
	print(stars)
	return
	
##func zoom():
##	
##	return
