extends Node

# ------------------------------
# Battle Events
# ------------------------------

signal ai_action_chosen(critter, action, targets)
signal create_popup_at(type, text, start_pos)
signal battle_ended(win_result)
signal create_damage_label(text, starting_position)
signal show_enemy_action(text)
signal combatant_revived(combatant)
signal remove_combatant_from_queue(combatant)
signal remove_combatant_ui(combatant)

# ------------------------------
# Battle Events
# ------------------------------

signal battle_grid_pressed(grid_position)

