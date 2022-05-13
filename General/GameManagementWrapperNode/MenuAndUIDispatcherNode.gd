extends Node


func _ready():
	Singleton_Game_GlobalCommonVariables.menus_root_node = self


# Access the Overworld Action Menu Node
func overworld_action_menu_node() -> Node:
	return $OverworldWrapperNode/MenusNodeWrapper/OverworldActionsMenuRoot


func gold_info_box_node() -> Node:
	return $OverworldWrapperNode/MenusNodeWrapper/GoldInfoBox


func character_info_box_node() -> Node:
	return $OverworldWrapperNode/MenusNodeWrapper/BattleCharacterOrEnemeyMicroInfoRoot


func member_list_node() -> Node:
	return $OverworldWrapperNode/MenusNodeWrapper/MemberListViewNodeRoot
