-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

local reapply_buffs = {}
reapply_buffs['Retaliation'] = true
reapply_buffs['Defender'] = true
local reapply_buff_attempts = {}
local reapply_buff_attempts_max = 20

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

	-- Load and initialize the include file.
	include('Mote-Include.lua')
	
	-- Lock Style
	windower.send_command('@wait 5;input /lockstyleset 2')
	
	-- Load the AutoWS addon
	--windower.send_command('input //lua load AutoWS; wait 1; input //aws ws raging rush; wait 1; input //aws tp 1000')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()

end


-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal')
	state.RangedMode:options('Normal')
	state.HybridMode:options('Normal')
	state.WeaponskillMode:options('Normal')
	state.CastingMode:options('Normal')
	state.IdleMode:options('Normal')
	state.RestingMode:options('Normal')
	state.PhysicalDefenseMode:options('PDT')
	state.MagicalDefenseMode:options('MDT')

	select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()

end

function init_gear_sets()
	
	--------------------------------------
	-- Precast sets
	--------------------------------------
	
	-- Sets to apply to arbitrary JAs
	sets.precast.JA['No Foot Rise'] = {body="Etoile Casaque +2"}
	
	-- Sets to apply to any actions of spell.type
	sets.precast.Waltz = {}
		
	-- Sets for specific actions within spell.type
	sets.precast.Waltz['Healing Waltz'] = {}

    -- Sets for fast cast gear for spells
	sets.precast.FC = {ear2="Loquacious Earring"}

    -- Fast cast gear for specific spells or spell maps
	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})

	-- Weaponskill sets
	sets.precast.WS = {}

	-- Specific weaponskill sets.
	sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {})

	
	--------------------------------------
	-- Midcast sets
	--------------------------------------

    -- Generic spell recast set
	sets.midcast.FastRecast = {}
		
	-- Specific spells
	sets.midcast.Utsusemi = {}

	
	--------------------------------------
	-- Idle/resting/defense/etc sets
	--------------------------------------
	
	-- Resting sets
	sets.resting = {head="Ocelomeh Headpiece +1",neck="Wiglen Gorget",
		ring1="Sheltered Ring",ring2="Paguroidea Ring"}
	

	-- Idle sets
	sets.idle = {feet="Hermes' Sandals"}

	sets.idle.Town = {}
	
	sets.idle.Weak = {}
	
	-- Defense sets
	sets.defense.PDT = {}

	sets.defense.MDT = {}

    -- Gear to wear for kiting
	sets.Kiting = {}

	--------------------------------------
	-- Engaged sets
	--------------------------------------

	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion
	
	-- Normal melee group
	sets.engaged = {
	    head="Outrider Mask", neck="Wiglen Gorgen", left_ring="Moonlight Ring", right_ring="Defending Ring",
		body="Outrider Mail", hands="Outrider Mittens", left_ear="Physical Earring", right_ear="Cassie Earring",
		back="Moonlight Cape", waist="Flume Belt +1", legs="Outrider Hose", feet="Outrider Greaves",
    }
	sets.engaged.Acc = {}

	--------------------------------------
	-- Custom buff sets
	--------------------------------------

	sets.buff.Barrage = set_combine(sets.midcast.RA.Acc, {hands="Orion Bracers +1"})
	sets.buff.Camouflage = {body="Orion Jerkin +1"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic target handling to be done.
function job_pretarget(spell, action, spellMap, eventArgs)

end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)

end

-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
function job_post_precast(spell, action, spellMap, eventArgs)

end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)

end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)

end

-- Runs when a pet initiates an action.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_pet_midcast(spell, action, spellMap, eventArgs)

end

-- Run after the default pet midcast() is done.
-- eventArgs is the same one used in job_pet_midcast, in case information needs to be persisted.
function job_pet_post_midcast(spell, action, spellMap, eventArgs)

end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)

end

-- Run after the default aftercast() is done.
-- eventArgs is the same one used in job_aftercast, in case information needs to be persisted.
function job_post_aftercast(spell, action, spellMap, eventArgs)

end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_pet_aftercast(spell, action, spellMap, eventArgs)

end

-- Run after the default pet aftercast() is done.
-- eventArgs is the same one used in job_pet_aftercast, in case information needs to be persisted.
function job_pet_post_aftercast(spell, action, spellMap, eventArgs)

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when the player's status changes.
function job_status_change(newStatus, oldStatus, eventArgs)

end

-- Called when the player's pet's status changes.
function job_pet_status_change(newStatus, oldStatus, eventArgs)

end

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	if reapply_buffs[buff] and not gain then
		reapply_buff_attempts[buff] = 0
		reapply_buff(buff, 'input //' .. buff)
	end
end

-- Called when a generally-handled state value has been changed.
function job_state_change(stateField, newValue, oldValue)

end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called before the Include starts constructing melee/idle/resting sets.
-- Can customize state or custom melee class values at this point.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_handle_equipping_gear(status, eventArgs)

end

-- Custom spell mapping.
-- Return custom spellMap value that can override the default spell mapping.
-- Don't return anything to allow default spell mapping to be used.
function job_get_spell_map(spell, default_spell_map)

end

-- Return a customized weaponskill mode to use for weaponskill sets.
-- Don't return anything if you're not overriding the default value.
function get_custom_wsmode(spell, spellMap, default_wsmode)

end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
	return meleeSet
end

-- Modify the default defense set after it was constructed.
function customize_defense_set(defenseSet)
	return defenseSet
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)

end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
	if type(cmdParams[1]) ~= string then return end
	if string.lower(cmdParams[1]) == 'buff' then
	
	end
	local commandArgs = cmdParams
	local command = commandArgs[1] and string.lower(table.remove(commandArgs, 1)) or 'help'
	local value = table.concat(commandArgs, " ")
	windower.add_to_chat(8, 'command: ' .. command .. ' / value: ' .. value)
end

-- Job-specific toggles.
function job_toggle_state(field)

end

-- Request job-specific mode lists.
-- Return the list, and the current value for the requested field.
function job_get_option_modes(field)

end

-- Set job-specific mode values.
-- Return true if we recognize and set the requested field.
function job_set_option_mode(field, val)

end

-- Handle auto-targetting based on local setup.
function job_auto_change_target(spell, action, spellMap, eventArgs)

end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'WAR' then
		set_macro_page(3, 20)
	elseif player.sub_job == 'NIN' then
		set_macro_page(1, 20)
	elseif player.sub_job == 'SAM' then
		set_macro_page(2, 20)
	else
		set_macro_page(5, 20)
	end
end

function reapply_buff(buff, command)
	-- Cancel if Buff Already Re-Applied
	if buffactive[buff] then
		windower.add_to_chat(8, '[AutoBuff] ' .. buff .. ' was reapplied...')
		return
	end
	
	-- Cancel if Player is Invisible
	if buffactive["Invisible"] then
		windower.add_to_chat(8, '[AutoBuff] Re-application of ' .. buff .. ' canceled, user is invisible...')
		return
	end
	
	-- Re-Schedule if Buff on Cooldown
	-- TO-DO
	
	-- Re-Attempt Buff when User Engages (to-do but outside this function. Let's move all of this to an add-on, anyways)
	-- TO-DO (check invis and cancel it if it's active, then call this function)
	
	-- Re-Apply Buff
	reapply_buff_attempts[buff] = reapply_buff_attempts[buff] + 1
	if reapply_buff_attempts[buff] <= reapply_buff_attempts_max then
		windower.add_to_chat(8, '[AutoBuff] Attempting to re-apply "' .. buff .. '" (attempt ' .. reapply_buff_attempts[buff] .. '/' .. reapply_buff_attempts_max ..')')
		windower.send_command(command)
		
		-- Queue Another Re-Application In-Case Action Misfires (User is busy)
		reapply_buff:schedule(1, buff, command)
	else
		windower.add_to_chat(8, '[AutoBuff] Out of attempts to re-apply "' .. buff .. '"')
	end
end