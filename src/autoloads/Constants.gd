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
const EffectType_ClearStatus = "clear_status"
const EffectType_Buff = "buff"

# Status Types
const StatusType_Bleed = "bleed"
const StatusType_Poison = "poison"

# Buff Types
const BuffType_Buff = "buff"
const BuffType_Malus = "malus"

const BuffAmountType_Percentage = "percentage"
const BuffAmountType_Flat = "flat"

# Stat Types
const StatType_Attack = "attack"
const StatType_Protection = "protection"
const StatType_Speed = "speed"
