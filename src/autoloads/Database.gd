extends Node

const combatant_data = {
	"knight": {
		"name": "Knight",
		"min_attack": 7,
		"max_attack": 10,
		"speed": 4,
		"protection": 20,
		"max_hp": 132,
		"actions": ["basic_attack", "basic_heal", "basic_bleed", "basic_poison", "basic_group_heal", "clear_dot"],
		"animations": preload("res://assets/animations/combatants/KnightAnim.tscn")
	},
	"butcher": {
		"name": "Butcher",
		"min_attack": 9,
		"max_attack": 11,
		"speed": 2,
		"protection": 5,
		"max_hp": 136,
		"actions": ["basic_attack", "basic_bleed", "mega_bleed", "basic_poison", "basic_area_attack"],
		"animations": preload("res://assets/animations/combatants/ButcherAnim.tscn")
	},
	"wax_slug": {
		"name": "Wax Slug",
		"min_attack": 4,
		"max_attack": 6,
		"speed": 1,
		"protection": 45,
		"max_hp": 108,
		"actions": ["basic_group_heal", "basic_bleed"],
		"animations": preload("res://assets/animations/combatants/WaxSlugAnim.tscn")
	},
	"candle_priest": {
		"name": "Candle Priest",
		"min_attack": 8,
		"max_attack": 12,
		"speed": 3,
		"protection": 5,
		"max_hp": 24,
		"actions": ["basic_attack", "basic_heal"],
		"animations": preload("res://assets/animations/combatants/CandlePriestAnim.tscn")
	},
	"candle_grunt": {
		"name": "Candle Grunt",
		"min_attack": 7,
		"max_attack": 9,
		"speed": 2,
		"protection": 12,
		"max_hp": 24,
		"actions": ["basic_attack"],
		"animations": preload("res://assets/animations/combatants/CandleGruntAnim.tscn")
	},
	"candle_captain": {
		"name": "Candle Captain",
		"min_attack": 12,
		"max_attack": 15,
		"speed": 5,
		"protection": 18,
		"max_hp": 35,
		"actions": ["basic_attack"],
		"animations": preload("res://assets/animations/combatants/CandleCaptainAnim.tscn")
	},
	"candle_trickster": {
		"name": "Candle Trickster",
		"min_attack": 8,
		"max_attack": 14,
		"speed": 7,
		"protection": 6,
		"max_hp": 22,
		"actions": ["basic_attack"],
		"animations": preload("res://assets/animations/combatants/CandleTricksterAnim.tscn")
	}
}

const action_data = {
	"basic_attack": {
		"name": "Basic Attack",
		"damage_percentage": 95,
		"target": Constants.ActionTarget_EnemySingle
	},
	"basic_heal": {
		"name": "Basic Heal",
		"target": Constants.ActionTarget_AllySingle,
		"effects": [{
			"type": Constants.EffectType_Heal,
			"amount": 15
		}]
	},
	"basic_group_heal": {
		"name": "Basic Group Heal",
		"target": Constants.ActionTarget_AllyMultiple,
		"effects": [{
			"type": Constants.EffectType_Heal,
			"amount": 7
		}]
	},
	"basic_bleed": {
		"name": "Basic Bleed",
		"damage_percentage": 65,
		"target": Constants.ActionTarget_EnemySingle,
		"effects": [{
			"name": "Bleed",
			"type": Constants.EffectType_Status,
			"status": Constants.StatusType_Bleed,
			"amount": 3,
			"turn_duration": 3,
			"icon": preload("res://assets/ui/status_icons/bleed.png")
		}]
	},
	"mega_bleed": {
		"name": "Mega Bleed",
		"damage_percentage": 125,
		"target": Constants.ActionTarget_EnemySingle,
		"effects": [{
			"name": "Bleed",
			"type": Constants.EffectType_Status,
			"status": Constants.StatusType_Bleed,
			"amount": 4,
			"turn_duration": 3,
			"icon": preload("res://assets/ui/status_icons/bleed.png")
		}],
		"self_effects": [{
			"name": "Bleed",
			"type": Constants.EffectType_Status,
			"status": Constants.StatusType_Bleed,
			"amount": 6,
			"turn_duration": 3,
			"icon": preload("res://assets/ui/status_icons/bleed.png")
		}]
	},
	"basic_poison": {
		"name": "Basic Poison",
		"damage_percentage": 25,
		"target": Constants.ActionTarget_EnemySingle,
		"effects": [{
			"name": "Bleed",
			"type": Constants.EffectType_Status,
			"status": Constants.StatusType_Poison,
			"amount": 4,
			"turn_duration": 2,
			"icon": preload("res://assets/ui/status_icons/poison.png")
		}]
	},
	"clear_dot": {
		"name": "Clear DoT",
		"target": Constants.ActionTarget_AllySingle,
		"effects": [{
			"type": Constants.EffectType_ClearStatus,
			"status": Constants.StatusType_Bleed
		}, {
			"type": Constants.EffectType_ClearStatus,
			"status": Constants.StatusType_Poison
		}]
	},
	"basic_area_attack": {
		"name": "Basic Area Attack",
		"damage_percentage": 70,
		"target": Constants.ActionTarget_EnemyMultiple,
		"effects": [{
			"type": Constants.EffectType_Buff,
			"buff_type": Constants.BuffType_Malus,
			"buff_amount_type": Constants.BuffAmountType_Flat,
			"stat_type": Constants.StatType_Protection,
			"amount": -10,
			"turn_duration": 3,
			"icon": preload("res://assets/ui/status_icons/malus.png")
		}]
	}
}
