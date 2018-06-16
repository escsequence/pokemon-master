require 'player'
require 'world'
require 'world_ui'
require 'pokemon'
camera = require 'camera'

important_index = 0
game_scale = 4
game_menu_scale = 2

function game_load()
    setBackgroundColor(255, 255, 255)
    love.graphics.setDefaultFilter("nearest")
    love.keyboard.setKeyRepeat(false)
    load_level()
    --world_tile_insert({x=5, y=0, layer=1, img=20})
    --world_tile_insert({x=10, y=0, layer=1, img=20})
    camera.setBoundary(-800,-1500, 3000, 3000)

    --[[
    local catch = pokemon_catch_formula("ultra", {status="burned", max_hp=100, current_hp=1, catch_rate=3});
    local catch = love.math.random(0,255);
    for we=1, 100, 1 do
        debug_error("Catch rate", pokemon_catch_formula("ultra", {status="poisoned", max_hp=100, current_hp=100, catch_rate=45}), true)
    end]]--


end

function game_keyboard_update(dt)
    player_update_controls(dt)

    if (love.keyboard.isDown("f5")) then
        debug_error("your pressed f5", "test", true)
    end
end

function game_update(dt)
    player_update(dt);
    world_update(dt);
    game_keyboard_update(dt);

end

function sprite_draw_test()
    local yx = 1
    local xx = 0

    for i=1, table.getn(resources.sprites.npc), 1 do
        love.graphics.push()
        love.graphics.scale(1, 1)
        love.graphics.setColor(255, 255, 255, 150)
        if (collides(xx * 16 * 2, yx * 16 * 2, mouse.x, mouse.y)) then
            important_index = i;
            love.graphics.setColor(255, 255, 255, 255)
        end

        love.graphics.draw(resources.spritesheets.npc, resources.sprites.npc[i],xx * 16, yx * 16)
        love.graphics.pop();

        xx = xx + 1;
        if (xx == 22) then
            yx = yx + 1;
            xx = 0;
        end
    end
end


function game_draw()
    love.graphics.push()
    love.graphics.scale(game_scale, game_scale)
        camera.draw(function()
            --sprite_draw_test();
            world_draw()
            player_draw()
        end)
    love.graphics.pop()
    --ui_draw();
end
