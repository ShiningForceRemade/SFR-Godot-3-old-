extends Node2D

onready var positionsNode = $PositionsNode2D
onready var playerNode = $PlayerCharacterRoot

func _ready():
	match Singleton_Game_GlobalCommonVariables.position_location_st:
		"Overworld_Alterone_Castle": playerNode.transform = positionsNode.get_node("AlteronePosition2D").transform
		"Overworld_Guardiana_Castle": playerNode.transform = positionsNode.get_node("GuardianaCastlePosition2D").transform
		"Overworld_Cabin": playerNode.transform = positionsNode.get_node("CabinPosition2D").transform
		"Overworld_Ancients_Gate": playerNode.transform = positionsNode.get_node("AncientsGatePosition2D").transform
		# default is Guardiana_Castle
	
	pass

