-- Local libraries used throughout addon
local packets = require('packets')
local res = require('resources')
local demoter_spells = require('demoter_spells')

-- Local vars used throughout addon
local active = true
local mid_demotion = false
local mixed = false
local debugMode = false

-- Local logging function for NukeDemoter
local logger = function(is_command, color, message)
	if is_command or (not is_command and debugMode) then
		windower.add_to_chat(color, '[NukeDemoter] ' .. message)
	end
end

-- Intercept Applicable Spells in Pretarget (gracefully override any existing function for maximum compatibility)
-- TO-DO: Adapt this to return the original function
local filter_pretarget_old = filter_pretarget
function filter_pretarget(spell, spellMap, eventArgs, ...)
    -- Return out if NukeDemoter is off
	if not active then
		return logger(false, 8, 'ABORT: NukeDemoter has been deactivated. Use the "//nd on" command to re-activate NukeDemoter.')
	end
	
	-- Return Out if Cast is Result of Demotion
	if mid_demotion then --this spell was the result of demotion, reset process
		mid_demotion = false --must be reset
		return
	end
	
	local demoter_spell = demoter_spells[spell.id] --parsed.Param is the spell id
	
	-- Return Out on Non-Demotable Spell
	if demoter_spell == nil then
		return logger(false, 8, 'ABORT: The spell "' .. spell.english .. '" is not demotable...')
	end
	
	-- Return Out on Fully-Demoted Spells
	if demoter_spell.demotion_index == 1 then
		return logger(false, 8, 'ABORT: Cannot demote "' .. demoter_spell.english .. '" further...')
	end
	
	-- Get Player Spells & Recasts
	local player_spells = windower.ffxi.get_spells() --{[id] = true/false}
	local player_mp = windower.ffxi.get_player().vitals.mp
	local spell_recasts = windower.ffxi.get_spell_recasts()
	
	-- Determine the situation, log some debug, and return out if spell ready to cast
	if spell.mp_cost > player_mp then --spell too expensive to cast
		logger(false, 8, 'Player lacks enough MP to cast "' .. demoter_spell.english .. '", demoting spell... (MP:' .. player_mp .. '/' .. res.spells[demoter_spell.id].mp_cost .. ')')
	elseif spell_recasts[demoter_spell.id] > 0 then --spell not ready to cast
		logger(false, 8, 'Player awaiting recast for "' .. demoter_spell.english .. '", demoting spell... (Recast: ' .. string.format("%.2f", spell_recasts[demoter_spell.id]/60) .. ' sec)')
	elseif spell_recasts[demoter_spell.id] == 0 then --spell ready to cast (no need to demote at this point)
		return logger(false, 8, 'ABORT: The spell "' .. demoter_spell.english .. '" is demotable but ready to cast...')
	end
	
	-- Demote Until a Player-Ready-to-Cast Tier is Found
	for i = demoter_spell.demotion_index - 1, 1, -1 do --look behind, iterating backwards
		-- Get Potential Demoted Spell
		local new_spell = {
			['english'] = demoter_spell.demotion_array[i].english,
			['id'] = demoter_spell.demotion_array[i].id,
		}
		
		-- Process to Determine Demotion
		if not mixed and new_spell.english:sub(-2) == 'ja' then
			logger(false, 8, 'Mixed is off, skipping "' .. new_spell.english .. '" and demoting spell...')
		else
			if player_spells[new_spell.id] == nil then
				if i == 1 then
					return logger(false, 8, 'ABORT: Player does not know "' .. new_spell.english .. '", cannot demote spell further...')
				end
				logger(false, 8, 'Player does not know "' .. new_spell.english .. '", demoting spell...')
			else
				-- Determine the situation, log some debug, and demote if applicable
				if res.spells[new_spell.id].mp_cost > player_mp then --spells too expensive to cast
					if i == 1 then
						return logger(false, 8, 'ABORT: Player lacks enough MP to cast "' .. new_spell.english .. '", cannot demote spell further... (MP: ' .. player_mp .. '/' .. res.spells[new_spell.id].mp_cost .. ')')
					end
					logger(false, 8, 'Player lacks enough MP to cast "' .. new_spell.english .. '", demoting spell... (MP: ' .. player_mp .. '/' .. res.spells[new_spell.id].mp_cost .. ')')
				elseif spell_recasts[new_spell.id] > 0 then --spells awaiting recast
					if i == 1 then
						return logger(false, 8, 'ABORT: Player awaiting recast for "' .. new_spell.english .. '", cannot demote spell further... (Recast: ' .. string.format("%.2f", spell_recasts[new_spell.id]/60) .. ' sec)')
					end
					logger(false, 8, 'Player awaiting recast for "' .. new_spell.english .. '", demoting spell... (Recast: ' .. string.format("%.2f", spell_recasts[new_spell.id]/60) .. ' sec)')
				elseif spell_recasts[new_spell.id] == 0 then --spells ready to cast
					cancel_spell()
					mid_demotion = true
					logger(false, 8, 'Casting "' .. new_spell.english .. '"...')
					return windower.send_command('input /ma "' .. new_spell.english .. '" ' .. tostring(spell.target.raw))
				end
			end
		end
	end
end

-- Command Handler for NukeDemoter
windower.raw_register_event('unhandled command', function(source, ...) --Credit: Lili for recommending raw version for use inside GearSwap
	-- Return out for non-NukeDemoter commands
    if not table.contains({'nukedemoter', 'ndemoter', 'demoter', 'nd'}, source:lower())then return end
	
	local cmd = T{...}
	
	-- Prepare chat color definitions
	local green = 158
	local red = 123
	local grey = 8
	
	if table.contains({'toggle', 'flip', 'switch'}, cmd[1]:lower()) then
		active = not active
		logger(true, active and green or red, 'Spell Demotion ' .. (active and 'Activated' or 'Deactivated'))
	elseif table.contains({'on', 'activate', 'enable', 'start', 'begin', 'unpause'}, cmd[1]:lower()) then
		active = true
		logger(true, green, 'Spell Demotion Activated')
	elseif table.contains({'off', 'deactivate', 'disable', 'stop', 'end', 'pause'}, cmd[1]:lower()) then
		active = false
		logger(true, red, 'Spell Demotion Deactivated')
	elseif table.contains({'mixed', 'mix', 'aoe'}, cmd[1]:lower()) then
		mixed = not mixed
		logger(true, mixed and green or red, 'T6 Demotion to Nuke-ja ' .. (mixed and 'Activated' or 'Deactivated'))
		if mixed then logger(true, red, 'WARNING: Only use this mode when it is safe to AoE.') end
	elseif table.contains({'debug', 'debugmode'}, cmd[1]:lower()) then
		debugMode = not debugMode
		logger(true, grey, 'Debug Mode ' .. (debugMode and 'activated' or 'deactivated') .. '...')
	elseif table.contains({'config', 'settings'}, cmd[1]:lower()) then
		logger(true, grey, 'NukeDemoter  settings:')
		logger(true, grey, '    active     - '..tostring(active))
		logger(true, grey, '    mixed      - '..tostring(mixed))
	else
		logger(true, grey, 'NukeDemoter  v' .. _addon.version .. ' commands:')
		logger(true, grey, '//nd [command]')
		logger(true, grey, '    toggle   - Toggles NukeDemoter ON or OFF')
		logger(true, grey, '    mixed    - Demotes T6 nukes to nuke-ja variants (CAUTION!)')
		logger(true, grey, '    help     - Displays this help text')
		logger(true, grey, ' ')
		logger(true, grey, 'NOTE: NukeDemoter will only degrade to known spells and only while it is active.')
	end
end)