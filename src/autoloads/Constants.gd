extends Node

# Player types and ids

enum PlayerType {
	Player = 0,
	AI = 1
	NetPlayer = 2
}
const PlayerId_Player = "player"
const PlayerId_Enemy = "enemy"
const PlayerId_NetPlayer = "net_player"


# Action Types
const ActionType_Melee = "Melee"
const ActionType_Ranged = "Ranged"
const ActionType_Special = "Special"

# Action Targets
const ActionTarget_EnemySingle = "enemy_single"
const ActionTarget_AllySingle = "ally_single"
const ActionTarget_EnemyMultiple = "enemy_multiple"
const ActionTarget_AllyMultiple = "ally_multiple"
const ActionTarget_Self = "self"

# Effect Types
const EffectType_Status = "status"
const EffectType_Heal = "heal"

# Status Types

const StatusType_Bleed = "bleed"

