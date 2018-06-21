require 'animation'

local imageFile
local frames = {
    bike = {
        side = 44,
        up = 144,
        down = 119
    },
    biking = {
        side = 169,
        up = 19,
        down = 194
    },
    stand = {
        side = 218,
        up = 94,
        down = 69
    },
    walk = {
        side = 293,
        up = 268,
        down = 243
    }
}
local animation = {
    none = nil,
    walk = {
        side = animation_new({frames.stand.side, frames.walk.side}, 0.15, false),
        up = animation_new({frames.stand.up, frames.walk.up}, 0.15, true),
        down = animation_new({frames.stand.down, frames.walk.down}, 0.15, true)

    },
    biking = {
        side = animation_new({frames.bike.side, frames.biking.side}, 0.15, false),
        up = animation_new({frames.bike.up, frames.biking.up}, 0.15, true),
        down = animation_new({frames.bike.down, frames.biking.down}, 0.15, true)
    }
}

player_pos = {x=16, y=16, z=0}
movex = 0
movey = 0

flip = false -- do not modify
player_direction = "down" -- current direction
player_riding_bike = true
player_moving = false -- if the player is currently moving
player_actually_moving = false -- if the player is animating/actually moving in distance
player_base_spd = 1
player_bike_spd = 2
player_moving_mspd = player_bike_spd -- recommended to keep this and player_moving_spd similar
player_moving_spd = player_bike_spd -- recommended to keep this and player_moving_spd similar
player_moving_distance = 16 -- distance player is set to move, in any direction
player_current_animation = animation.walk.down
num = frames.stand.down --base standing location
just_warped = false -- this gets set if the player JUST warped

--animate = animation_new({frames.stand.side, frames.walk.side}, 0.20)


keypressed = false

function player_update_controls(dt)
    if love.keyboard.isDown("up") then
        player_move("up", dt)
    end

    if love.keyboard.isDown("down") then
        player_move("down", dt)
    end

    if love.keyboard.isDown("left") then
        player_move("left", dt)
    end

    if love.keyboard.isDown("right") then
        player_move("right", dt)
    end

    if love.keyboard.isDown("a") and not keypressed then
        if (player_riding_bike) then
            player_riding_bike = false
            player_moving_mspd = player_base_spd
            player_moving_spd = player_base_spd
        else
            player_riding_bike = true
            player_moving_mspd = player_bike_spd
            player_moving_spd = player_bike_spd
        end
        keypressed = true
    end

    if not love.keyboard.isDown("a") then
        keypressed = false
    end
end

function player_move(pos, dt)
    if not (player_moving) then
        player_direction = pos;
        if (pos == "left") then
            movex = -player_moving_distance
            player_moving = true
        elseif (pos == "right") then
            movex = player_moving_distance
            player_moving = true
        elseif (pos == "up") then
            movey = -player_moving_distance
            player_moving = true
        elseif (pos == "down") then
            movey = player_moving_distance
            player_moving = true
        end
    end
end

function player_move_check_collision(x, y)
    for xn=1, #world.collides, 1 do
        if (collides_rect(x, y, 16, 16, world.collides[xn].x, world.collides[xn].y, world.collides[xn].w, world.collides[xn].h)) then
            return true
        end
    end
    return false
end

function player_move_check_obj(x, y, obj)
  for xn=1, #obj, 1 do
      if (collides_rect(x, y, 16, 16, obj[xn].x, obj[xn].y, obj[xn].w, obj[xn].h)) then
          return obj[xn]
      end
  end
  return false
end

function player_update(dt)
    -- Player moving logic
    camera.lookAt(math.floor(player_pos.x), math.floor(player_pos.y))
    if (player_moving) then
        if (player_direction == "left" or player_direction == "right") then
            if (movex > 0) then --moving right
                camera.lookAt(math.floor(player_pos.x), math.floor(player_pos.y))
                movex = movex - player_moving_mspd
                flip = true
                if (player_riding_bike) then
                    animation_update(animation.biking.side, dt);
                    player_current_animation = animation.biking.side
                else
                    animation_update(animation.walk.side, dt);
                    player_current_animation = animation.walk.side
                end
                if not (player_move_check_collision(player_pos.x + movex, player_pos.y)) then
                    player_pos.x = player_pos.x + player_moving_spd
                    player_actually_moving = true
                    if (just_warped) then
                      just_warped=false
                    end
                else
                    movex = 0
                    player_actually_moving = false
                    if not (player_pos.x % 16 == 0) then
                        player_pos.x = player_pos.x + (player_pos.x % 16);
                    end
                end
                camera.lookAt(math.floor(player_pos.x), math.floor(player_pos.y))

            elseif (movex < 0) then --moving left
                camera.lookAt(math.ceil(player_pos.x), math.ceil(player_pos.y))
                movex = movex + player_moving_mspd
                flip = false
                if (player_riding_bike) then
                    animation_update(animation.biking.side, dt);
                    player_current_animation = animation.biking.side
                else
                    animation_update(animation.walk.side, dt);
                    player_current_animation = animation.walk.side
                end
                if not (player_move_check_collision(player_pos.x + movex, player_pos.y)) then
                    player_pos.x = player_pos.x - player_moving_spd
                    player_actually_moving = true
                    if (just_warped) then
                      just_warped=false
                    end
                else
                    player_actually_moving = false
                    movex = 0
                    if not (player_pos.x % 16 == 0) then
                        player_pos.x = player_pos.x - (player_pos.x % 16);
                    end
                end
                camera.lookAt(math.ceil(player_pos.x), math.ceil(player_pos.y))

            elseif (movex == 0) then --no more movement
                player_moving = false
                player_actually_moving = false
            end
        end

        if (player_direction == "up" or player_direction == "down") then
            if (movey > 0) then --moving down
                camera.lookAt(math.ceil(player_pos.x), math.ceil(player_pos.y))
                movey = movey - player_moving_mspd
                flip = false
                if (player_riding_bike) then
                    animation_update(animation.biking.down, dt);
                    player_current_animation = animation.biking.down
                else
                    animation_update(animation.walk.down, dt);
                    player_current_animation = animation.walk.down
                end
                if not (player_move_check_collision(player_pos.x, player_pos.y + movey)) then
                    player_pos.y = player_pos.y + player_moving_spd
                    player_actually_moving = true
                    if (just_warped) then
                      just_warped=false
                    end
                else
                    movey = 0
                    player_actually_moving = false
                    if not (player_pos.y % 16 == 0) then
                        movey = player_pos.y + (player_pos.y % 16);
                    end
                end
                camera.lookAt(math.ceil(player_pos.x), math.ceil(player_pos.y))

            elseif (movey < 0) then --moving up
                camera.lookAt(math.ceil(player_pos.x), math.ceil(player_pos.y))
                movey = movey + player_moving_mspd
                flip = false
                if (player_riding_bike) then
                    animation_update(animation.biking.up, dt);
                    player_current_animation = animation.biking.up
                else
                    animation_update(animation.walk.up, dt);
                    player_current_animation = animation.walk.up
                end
                if not (player_move_check_collision(player_pos.x, player_pos.y + movey)) then
                    player_pos.y = player_pos.y - player_moving_spd
                    player_actually_moving = true
                    if (just_warped) then
                      just_warped=false
                    end
                else
                    movey = 0
                    player_actually_moving = false
                    if not (player_pos.y % 16 == 0) then
                        player_pos.y = player_pos.y - (player_pos.y % 16);
                    end
                end
                camera.lookAt(math.ceil(player_pos.x), math.ceil(player_pos.y))

            elseif (movey == 0) then
                player_moving = false
                player_actually_moving = false
            end
        end
    end

    if not (just_warped) and not (player_actually_moving) then
      warp_touch = player_move_check_obj(player_pos.x, player_pos.y, world.warps)
      if (warp_touch) then
        warp_effect()
        just_warped = true
        player_pos = get_warp_pos(warp_touch.warp_to)
        player_moving = false
        --player_move(warp_touch.player_dir)
      end
    end

end

function player_draw()
    love.graphics.setColor(255, 255, 255, 255)
    if (player_moving) then
        -- If player is moving, draw dis - sucka!
        animation_draw(player_current_animation, player_pos.x, player_pos.y, flip);
    -- Animation has stopped, do dis.. stationary -- user has stopped moving.. because animation will stop animating
    else
        -- If riding bike
        if (player_riding_bike) then
            if (player_direction == "up") then
                love.graphics.draw(resources.spritesheets.npc, resources.sprites.npc[frames.bike.up], player_pos.x, player_pos.y)
            elseif (player_direction == "down") then
                love.graphics.draw(resources.spritesheets.npc, resources.sprites.npc[frames.bike.down], player_pos.x, player_pos.y)
            elseif (player_direction == "left") then
                love.graphics.draw(resources.spritesheets.npc, resources.sprites.npc[frames.bike.side], player_pos.x, player_pos.y)
            elseif (player_direction == "right") then
                love.graphics.draw(resources.spritesheets.npc, resources.sprites.npc[frames.bike.side], player_pos.x+16, player_pos.y, 0, -1, 1)
            end
        else
            -- No bike riding
            if (player_direction == "up") then
                love.graphics.draw(resources.spritesheets.npc, resources.sprites.npc[frames.stand.up], player_pos.x, player_pos.y)
            elseif (player_direction == "down") then
                love.graphics.draw(resources.spritesheets.npc, resources.sprites.npc[frames.stand.down], player_pos.x, player_pos.y)
            elseif (player_direction == "left") then
                love.graphics.draw(resources.spritesheets.npc, resources.sprites.npc[frames.stand.side], player_pos.x, player_pos.y)
            elseif (player_direction == "right") then
                love.graphics.draw(resources.spritesheets.npc, resources.sprites.npc[frames.stand.side], player_pos.x+16, player_pos.y, 0, -1, 1)
            end
        end
    end
end
