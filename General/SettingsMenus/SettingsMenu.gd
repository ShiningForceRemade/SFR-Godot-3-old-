extends Node2D

var menu_active: bool = false

enum E_GeneralSettings {
	Resolution,
	Fullscreen,
}
var current_choice = E_GeneralSettings.Resolution

onready var redselection = $GeneralStatNinePatchRect/RedSelectionBorderRoot

onready var fullscreen_label = $GeneralStatNinePatchRect/Node/VBoxContainer/FullscreenControl/FullscreenLabel
onready var resolution_label = $GeneralStatNinePatchRect/Node/VBoxContainer/ResolutionControl/ResolutionLabel

var current_resolution = 1
var A_Resolutions = [
	# Vector2(320, 180),
	Vector2(640, 360),
	Vector2(1280, 720),
	Vector2(1920, 1080),
	Vector2(3840, 2160),
	Vector2(7680, 4320),
]

func _ready():
	
	# Prevent window from resizing anymore ther than the settings menu
	OS.window_resizable = false
	OS.set_window_size(Vector2(1280, 720))
	# DisplayServer.window_set_size(Vector2i(1920, 1080)) # G4
	# OS.set_windows_resizable(false)
	
	hide()


func _input(event):
	if event.is_action_pressed("ui_settings_menu"):
		if get_tree().paused:
			hide()
			menu_active = false
			get_tree().paused = !get_tree().paused
		else:
			show()
			menu_active = true
			get_tree().paused = !get_tree().paused
			
	if menu_active:
		if event.is_action_pressed("ui_down"):
			if(redselection.position.y < 39.5):	
				redselection.position = Vector2(redselection.position.x, redselection.position.y + 24)
				
				# TODO: do actual settings logic when there's more than 2 options
				current_choice = E_GeneralSettings.Fullscreen
		if event.is_action_pressed("ui_up"):
			if(redselection.position.y > 15.5):
				redselection.position = Vector2(redselection.position.x, redselection.position.y -24)
				
				current_choice = E_GeneralSettings.Resolution
		
		match current_choice:
			E_GeneralSettings.Resolution: 
				Handle_Resolution(event)
			E_GeneralSettings.Fullscreen: 
				Handle_Fullscreen(event)


func Handle_Resolution(event):
	if event.is_action_pressed("ui_left"):
		if(current_resolution > 0):
			current_resolution = current_resolution - 1
			resolution_label.text = String(A_Resolutions[current_resolution])
			OS.set_window_size(A_Resolutions[current_resolution])
			center_window()
	if event.is_action_pressed("ui_right"):
		if(current_resolution < 4):
			current_resolution = current_resolution + 1
			resolution_label.text = String(A_Resolutions[current_resolution])
			OS.set_window_size(A_Resolutions[current_resolution])
			center_window()


func Handle_Fullscreen(event):
	if event.is_action_pressed("ui_left"):
		OS.window_fullscreen = false
		fullscreen_label.text = "OFF"
	if event.is_action_pressed("ui_right"):
		OS.window_fullscreen = true
		fullscreen_label.text = "ON"


func center_window():
	var screen_size = OS.get_screen_size(0)
	var window_size = OS.get_window_size()
	
	OS.set_window_position(screen_size*0.5 - window_size*0.5)
