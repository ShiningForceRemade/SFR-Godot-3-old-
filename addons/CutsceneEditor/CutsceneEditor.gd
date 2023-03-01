@tool
extends EditorPlugin

const CutsceneEditor = preload("res://addons/CutsceneEditor/CutsceneEditor.tscn")
var CutsceneEditorInstance

func _enter_tree():
	CutsceneEditorInstance = CutsceneEditor.instantiate()
	
	get_editor_interface().get_editor_main_screen().add_child(CutsceneEditorInstance)
	
	_make_visible(false)
	
	pass


func _exit_tree():
	if CutsceneEditorInstance:
		CutsceneEditorInstance.queue_free()
	
	pass


func _has_main_screen() -> bool:
	return true
	

func _make_visible(visible) -> void:
	if CutsceneEditorInstance:
		CutsceneEditorInstance.visible = visible


func _get_plugin_name() -> String:
	return "SFRemade Cutscene Editor"
	

func _get_plugin_icon():
	return get_editor_interface().get_base_control().get_icon("Node", "EditorIcons")
