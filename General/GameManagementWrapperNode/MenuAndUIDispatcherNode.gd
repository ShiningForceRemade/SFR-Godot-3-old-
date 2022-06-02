extends Node

const bmc_x: int = 171
const bmc_y: int = 182

onready var OverworldActionMenuRoot = $OverworldWrapperNode/MenusNodeWrapper/OverworldActionsMenuRoot

onready var battleMagicMenuTween = $OverworldWrapperNode/MenusNodeWrapper/OverworldMagicMenuNode/BattleMagicMenuTween
onready var battleMagicMenuWrapperRoot = $OverworldWrapperNode/MenusNodeWrapper/OverworldMagicMenuNode # /OverworldMagicMenuRoot
onready var battleMagicMenuRoot = $OverworldWrapperNode/MenusNodeWrapper/OverworldMagicMenuNode/OverworldMagicMenuRoot

onready var OverworldInventoryMenuTween = $OverworldWrapperNode/MenusNodeWrapper/OverworldInventoryMenuNode/InventoryMenuTween
onready var OverworldInventoryMenuWrapperRoot = $OverworldWrapperNode/MenusNodeWrapper/OverworldInventoryMenuNode
onready var OverworldInventoryMenuRoot = $OverworldWrapperNode/MenusNodeWrapper/OverworldInventoryMenuNode/InventoryMenuRoot

onready var HQMenuWrapperRoot = $HQMenusWrapperNode
onready var PriestMenuWrapperRoot = $OverworldWrapperNode/PriestMenuWrapperNode
onready var UserInteractionPromptsRoot = $UserInteractionPrompts

onready var GoldInfoBox = $OverworldWrapperNode/MenusNodeWrapper/GoldInfoBox

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



func internal_tween_move_to_position(ox, oy, nx, ny, tweenNode, targetNode) -> void:
	print(tweenNode)
	tweenNode.interpolate_property(targetNode, "position",
			Vector2(ox, oy), Vector2(nx, ny), 0.1,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tweenNode.start()

func s_hide_overworld_magic_menu():
	internal_tween_move_to_position(139, 134, 139, 134 + 80, battleMagicMenuTween, battleMagicMenuWrapperRoot)

func s_show_overworld_magic_menu():
	internal_tween_move_to_position(139, 134 + 80, 139, 134, battleMagicMenuTween, battleMagicMenuWrapperRoot)
	battleMagicMenuRoot.set_battle_magic_menu_active()


func s_hide_overworld_inventory_menu():
	internal_tween_move_to_position(139, 134, 139, 134 + 80, OverworldInventoryMenuTween, OverworldInventoryMenuRoot)

func s_show_overworld_inventory_menu():
	internal_tween_move_to_position(139, 134 + 80, 139, 134, OverworldInventoryMenuTween, OverworldInventoryMenuRoot)
	OverworldInventoryMenuRoot.set_overworld_inventory_menu_active()

