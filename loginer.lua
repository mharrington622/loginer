_addon.name = 'loginer'
_addon.author = 'Wealer'
_addon.version = '0.1.0.0'
_addon.commands = { 'login' }

numCharacters = 0
curCharacter = 0
titleMenu = true
skipError = false

SEQUENCE_DELAY = 0.5
LOGOUT_COMMAND_DELAY = 10
ERROR_TIMEOUT = 10

PRESS = {}
PRESS.UP =         'setkey up down;wait 0.2;setkey up up'
PRESS.DOWN =     'setkey down down;wait 0.2;setkey down up'
PRESS.LEFT =     'setkey left down;wait 0.2;setkey left up'
PRESS.RIGHT =   'setkey right down;wait 0.2;setkey right up'
PRESS.ENTER =   'setkey enter down;wait 0.2;setkey enter up'
PRESS.ESCAPE = 'setkey escape down;wait 0.2;setkey escape up'


windower.register_event('prerender', function()
	if numCharacters == 0 then return end
	
    do_login(curCharacter)
end)


windower.register_event('addon command', function(cmd, ...)
    local args = {...}

	if cmd == 'do' then
		numCharacters = tonumber(args[1])
	elseif cmd == 'stop' then
		numCharacters = 0
		curCharacter = 0
		titleMenu = true
		skipError = false
		coroutine.schedule(function() windower.send_command('lua u loginer') end, 0)
	end
end)

windower.register_event('zone change', function(new, old)
	skipError = true
	curCharacter = curCharacter + 1 -- We have logged in a character successfully.
	
	do_logout()
end)



function do_logout()
	local inMH = windower.ffxi.get_info().mog_house
	coroutine.sleep(LOGOUT_COMMAND_DELAY)
	
	windower.send_command('input /logout') -- Logout

	if inMH then -- Wait for logout and title menu to load
		coroutine.sleep(15)
	else
		coroutine.sleep(45)
	end

	titleMenu = true
	are_logins_complete()
end

function do_login(char)
	if titleMenu == true then
		titleMenu = false
		windower.send_command(PRESS.ENTER) -- Title menu "Select Character"
		coroutine.sleep(5)

		-- The game handles this for us but it's a time-saving improvement.
		if char / 8 >= 1 then -- Select the second column of characters
			windower.send_command(PRESS.RIGHT)
			coroutine.sleep(SEQUENCE_DELAY)
			char = char - 8
		end
		while char > 0 do
			windower.send_command(PRESS.DOWN)
			coroutine.sleep(SEQUENCE_DELAY)
			char = char - 1
		end

		windower.send_command(PRESS.ENTER) -- Choose character
		coroutine.sleep(SEQUENCE_DELAY)
		windower.send_command(PRESS.ENTER) -- Confirm character

		skipError = false
		coroutine.schedule(try_handle_unexpected_login_error, ERROR_TIMEOUT)
	end
end

-- There is no interfacing with any errors that could occur, so I am just hoping this works.
function try_handle_unexpected_login_error()
	if skipError then return end
	
	curCharacter = curCharacter + 1 -- Move to next character slot if something happens.

	windower.send_command(PRESS.ENTER)
	coroutine.sleep(SEQUENCE_DELAY)
	windower.send_command(PRESS.ESCAPE)
	coroutine.sleep(SEQUENCE_DELAY)
	windower.send_command(PRESS.ESCAPE)
	coroutine.sleep(SEQUENCE_DELAY)
	windower.send_command(PRESS.ESCAPE)
	coroutine.sleep(SEQUENCE_DELAY)
	windower.send_command(PRESS.ESCAPE)
	coroutine.sleep(3)
	windower.send_command(PRESS.ESCAPE) -- Hopefully select "Back" on title menu
	coroutine.sleep(SEQUENCE_DELAY)
	windower.send_command(PRESS.DOWN) -- Get back to "Select Character"
	coroutine.sleep(SEQUENCE_DELAY)
	
	titleMenu = true
	are_logins_complete()
end

function are_logins_complete()
	echo('Logged in '..curCharacter..' characters')
	if curCharacter >= numCharacters then -- Unload ourselves if we are done!
		numCharacters = 0
		coroutine.schedule(function() windower.send_command('lua u loginer') end, 0) -- This needs to be done in a coroutine method to avoid strange behavior.
	end
end

function echo(message)
	windower.send_command('echo '..message)
end
