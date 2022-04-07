tool
extends EditorPlugin

const CutsceneEditor = preload("res://addons/CutsceneEditor/CutsceneEditor.tscn")
var CutsceneEditorInstance

func _enter_tree():
	CutsceneEditorInstance = CutsceneEditor.instance()
	
	get_editor_interface().get_editor_viewport().add_child(CutsceneEditorInstance)
	
	make_visible(false)
	
	pass


func _exit_tree():
	if CutsceneEditorInstance:
		CutsceneEditorInstance.queue_free()
	
	pass


func has_main_screen() -> bool:
	return true
	

func make_visible(visible) -> void:
	if CutsceneEditorInstance:
		CutsceneEditorInstance.visible = visible


func get_plugin_name() -> String:
	return "SFRemade Cutscene Editor"
	

func get_plugin_icon():
	return get_editor_interface().get_base_control().get_icon("Node", "EditorIcons")
