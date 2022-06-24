-- Intro
windower.add_to_chat(8, 'Loaded user-globals.lua for '..player.name)

-- Define Characters
local players = {"Rolandj", "Levii", "Josaph"}

-- Separate Player From Players
for i in ipairs(players) do if players[i] == player.name then table.remove(players, i) end end

-- NOTE: The key difference between init and user-global binds/aliases is that ones with scripted/per-player variables ones go in user-globals

-- Keybinds
windower.send_command('bind ^f send @others input /follow '..player.name)

-- Per-Char Alias Commands
for i in ipairs(players) do
	local prefix = string.sub(players[i], 1, 1)
	windower.send_command('alias inv' .. prefix .. ' input /pcmd add '..players[i])
	windower.send_command('alias fol' .. prefix .. ' send '..players[i] .. player.name)
	windower.send_command('alias hpw' .. prefix .. ' send '..players[i]..' input !homepoint')
	windower.send_command('alias buff' .. prefix .. ' send '..players[i]..' input !buff')
	windower.send_command('alias oil' .. prefix .. ' send '..players[i]..' input //oil')
	windower.send_command('alias pwd' .. prefix .. ' send '..players[i]..' input //pwd')
end

-- Invite All Alts Alias
local invCommand = 'alias inv '
for i in ipairs(players) do
	invCommand = invCommand .. 'input /pcmd add ' .. players[i] .. '; wait 3; send ' .. players[i] .. ' input /join; '
end
windower.send_command(invCommand)