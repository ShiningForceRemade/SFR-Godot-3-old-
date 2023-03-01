extends Node

var roof_wrapper_node = null

func _ready():
	roof_wrapper_node = get_parent().get_node("RoofsWrapperNode")
	pass


## Roofs Start
## TODO: this is disgusting - refactor and creat helper scripts instead
## just pass the roof node title and let the helper handle entrance and exit
## instead of copying and pasting everything here

func _on_TopLeftHouseEntranceArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("TopLeftHouse").hide()

func _on_TopLeftHouseExitArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("TopLeftHouse").show()


func _on_TopRightHouseEntranceArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("TopRightHouse").hide()

func _on_TopRightHouseExitArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("TopRightHouse").show()


func _on_ChruchLeftEntranceArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("Church").hide()

func _on_ChruchLeftExitArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("Church").show()

func _on_ChruchRightEntranceArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("Church").hide()

func _on_ChruchRightExitArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("Church").show()


func _on_WeaponShopEntranceArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("WeaponShop").hide()

func _on_WeaponShopExitArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("WeaponShop").show()


func _on_ItemShopLeftEntranceArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("ItemShopAndBar").hide()

func _on_ItemShopLeftExitArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("ItemShopAndBar").show()

func _on_ItemShopRightEntranceArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("ItemShopAndBar").hide()

func _on_ItemShopRightExitArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("ItemShopAndBar").show()


func _on_HouseBottomEntranceArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("HouseBottom").hide()

func _on_HouseBottomExitArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("HouseBottom").show()

## Roofs End

func _on_OverworldExitArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		print("Change Scene outside Guardiana Overworld")
		Singleton_Game_GlobalCommonVariables.position_location_st = "Overworld_Alterone_Castle"
		Singleton_Game_GlobalCommonVariables.scene_manager_node.change_scene_to_file("res://SF1/Chapters/1/Battle2/Overworld.tscn")


func _on_CastleEntranceArea2D_body_entered(body):
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		print("Change Scene Alterone Castle")
		Singleton_Game_GlobalCommonVariables.position_location_st = "Alterone-Castle__MainEntrance"
		Singleton_Game_GlobalCommonVariables.scene_manager_node.change_scene_to_file("res://SF1/Chapters/1/Alterone/Castle/Alterone_Castle.tscn")


func _on_TopRightHouseBasementEntranceArea2D_body_entered(body):
	print("Goto Basement")
	pass # Replace with function body.


func _on_HQEntranceArea2D_body_entered(body):
	print("Goto HQ Tunnel")
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		print("Change Scene HQ")
		Singleton_Game_GlobalCommonVariables.position_location_st = "Alterone-Town__HQ"
		# Singleton_Game_GlobalCommonVariables.scene_manager_node.change_scene_to_file("res://SF1/Chapters/HQ/Default/HeadQuarters.tscn")
		Singleton_Game_GlobalCommonVariables.scene_manager_node.change_scene_to_file("res://SF1/Chapters/1/Alterone/Castle_Basement/Alterone_Castle_Basement.tscn")


func _on_BottomHouseBasementEntranceArea2D_body_entered(body):
	print("Goto Basement")
	pass # Replace with function body.
