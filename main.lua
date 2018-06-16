DEBUG_MODE = true;
local bgColor = {0, 0, 0};

require 'error'
require 'globals'
require 'functions'
require 'manager'

function love.load()
	-- super important things first
	print("test")
	love.window.setTitle("Pokemon Remake")
	font_n = love.graphics.newFont("fonts/Pokemon GB.ttf", 8)
	font_lg = love.graphics.newFont("fonts/Pokemon GB.ttf", 16)
	font_xl = love.graphics.newFont("fonts/Pokemon GB.ttf", 24)
	bank_font = love.graphics.newFont("fonts/bank.ttf", 10)

	love.graphics.setFont(font_n)
	debug_init();
	mgr_init();
	game_load();

	-- more init junk
	game_state = "game"; -- splash, menu, game, credits - where the game starts

	-- loading is last.
	load_resources();
	mgr_load();

end

function love.update(dt)
	if not (critical_error) then
		mgr_update(dt);
	end
	debug_update();
end

function love.draw()
	if not (critical_error) then
		--love.graphics.push()
		mgr_draw();
	    --love.graphics.pop()
	end
	love.graphics.push()
	debug_draw();
    love.graphics.pop()
end
