extends Camera2D

var photoMode = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zoom = Vector2(0.3,0.3)
	pass # Replace with function body.
	##Set zoom, and to the middle of the picture

func _input(event):
	if(!event.as_text().contains("Mouse")):
		if(event.keycode == KEY_R):
			if(!photoMode):
				make_current()
				photoMode = true
				zoom = Vector2(0.3,0.3)
				offset = Vector2(0,0)
		if(photoMode):
			if(event.keycode == KEY_A):
				offset.x = offset.x-20
				if(offset.x < -2000):
					offset.x = -2000
			elif(event.keycode == KEY_W):
				offset.y = offset.y-20
				if(offset.y < -2000):
					offset.y = -2000
			elif(event.keycode == KEY_D):
				offset.x = offset.x+20
				if(offset.x > 2000):
					offset.x = 2000
			elif(event.keycode == KEY_S):
				offset.y = offset.y+20
				if(offset.y > 2000):
					offset.y = 2000
			elif(event.keycode == KEY_Q):
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
			print(zoom)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
	##Process movement and zoom
	##Trigger take_photo upon button press

func take_photo():
	##Process taking photo, and figure out 
	##Auto-aggro cryptid, send the player back to the level
	return
	
##func zoom():
##	
##	return
