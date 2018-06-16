-- Gamestate manager
-- mgr
mouse = {
	x = 0,
	y = 0
}
function mgr_init()
	require 'debug'
	require 'resources'
	require "game"
end

function mgr_load()
end

function mgr_update_mouse(dt)
	mouse.x, mouse.y = love.mouse.getPosition()
end

function mgr_update(dt)
	mgr_update_mouse(dt);
	if (game_state == "splash") then
		splash_update(dt);
	elseif (game_state == "menu") then
		menu_update(dt);
	elseif (game_state == "game") then
		game_update(dt);
	elseif (game_state == "credits") then
		credits_update(dt);
	else
		debug_error("tried to update invalid game_state", game_state, true);
	end
end

function mgr_draw(dt)
	love.graphics.setColor(bgColor[1], bgColor[2], bgColor[3])
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    --love.graphics.push()
	if (game_state == "splash") then
		splash_draw();
	elseif (game_state == "menu") then
		menu_draw();
	elseif (game_state == "game") then
		game_draw();
	elseif (game_state == "credits") then
		credits_draw();
	else
		debug_error("tried to draw invalid game_state", game_state, true);
	end
    --love.graphics.pop()
end
