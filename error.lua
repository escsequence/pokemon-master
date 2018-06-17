error = {
	crash = false,
	crash_log = {},
	recent_log = {}
}

critical_error = false

debug = {
    enabled = true,
		triggered = false,
    log = {},
    log_max_count = 10000, --Max count of debug items
    log_min_scroll = 50, -- at 50, usually the debug items go off the screen
    log_max_scroll = 10000, --Max size of scroll
    log_scroll_speed = 3 -- speed of the scrolling
}


function debug_log(msg, warning)
	if (type(warning) == "nil") then
		warning = 0
	end

	if (type(msg) == "nil") then
		msg = "nil"
	elseif (type(msg) == "boolean") then

		if (msg) then
			msg = "true"
		else
			msg = "false"
		end
	end

	if not (warning == 0) then
		table.insert(debug.log, msg .. " - warning lvl: " .. warning);
	else
		table.insert(debug.log, msg .. " - no warning");
	end
end


function debug_error(msg, current, crit)
	--crash game
	if (type(current) == "nil") then
		current = "nil"
	elseif (type(current) == "boolean") then

		if (current) then
			current = "true"
		else
			current = "false"
		end
	end

	table.insert(debug.log, msg .. " -- current val: \'" .. current .. "\'");

	if (crit) then
		critical_error = true;
	end
end


-- Debug area...
function debug_init()
	debug_draw_top = 0
end

function debug_draw()
	if (critical_error) then
		offset = 8
		top = 120 - debug_draw_top
		love.graphics.setColor(255,255,255,200)
		love.graphics.rectangle("fill", offset, offset, love.graphics.getWidth()-offset*2, love.graphics.getHeight()-offset*2)
	    love.graphics.setColor(255,0,0)
	    --love.graphics.print("Debug Mode", 12, 12)

		debug_val = ""
		for i=0, table.getn(debug.log) do
			if (not (debug.log[i] == nil)) and (not (i > debug.log_max_count)) then
				debug_val = debug_val .. (debug.log[i] .. "\n");
			end
		end
		love.graphics.setFont(font_xl)
		love.graphics.printf("Pokem0n debug crash", 12, top + 18, 800, 'center')
		love.graphics.setColor(0,0,0)
		love.graphics.setFont(font_n)
		love.graphics.printf("\n\n\n" .. debug_val .. "\n\n\n\npress esc key to close game", 12, top + 42, 800, 'center')
	end
end

function debug_update()
	if love.keyboard.isDown("escape") then
		love.event.quit(0);
	end

	if love.keyboard.isDown("up") then
		if ((table.getn(debug.log) < debug.log_max_scroll) and  (table.getn(debug.log) > debug.log_min_scroll)) then
			debug_draw_top = debug_draw_top + debug.log_scroll_speed
		end
	end

	if love.keyboard.isDown("down") then
		if ((table.getn(debug.log) < debug.log_max_scroll) and  (table.getn(debug.log) > debug.log_min_scroll)) then
			debug_draw_top = debug_draw_top - debug.log_scroll_speed
		end
	end
end
