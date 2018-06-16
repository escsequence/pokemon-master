local playerDrawDistance = 256

local Tile = {}
Tile.__index=Tile
function Tile.new(x, y, layer, img)
    local tile={x=x, y=y, layer=layer, img=img}
    return setmetatable(tile, Tile)
end

function g2d(it)
    if not (it == nil) then
        if withinView(player_pos.x - playerDrawDistance, player_pos.y - playerDrawDistance, playerDrawDistance*2.5, playerDrawDistance*2.5, it.x * 16, it.y * 16) then
            return true
        else
            return false
        end
    else
        return false
    end
end

function Tile:draw()
    if (g2d(self)) then
        if not (resources.sprites.tiles[self.img] == nil) then
            love.graphics.push()
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.draw(resources.spritesheets.tiles, resources.sprites.tiles[self.img], self.x * 16, self.y * 16)
            love.graphics.pop()
        end
    end
end

local Collider = {}
Collider.__index=Collider
function Collider.new(x, y, w, h)
    local collider={x=x, y=y, w=w, h=h}
    return setmetatable(collider, Collider)
end
function Collider:draw()
    if (DEBUG_MODE) then
        if (g2d(self)) then
            love.graphics.push()
            love.graphics.setColor(255, 0, 0, 50)
            love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
            love.graphics.pop()
        end
    end
end


world = {
    tiles = {},
    collides = {},
    events = {},
    triggers = {},
    objects = {},
    npcs = {}
}

function world_clear_all()
    world = {
        tiles = {},
        collides = {},
        events = {},
        triggers = {},
        objects = {},
        npcs = {}
    }
end

function world_update(dt)
end

function world_tile_insert(tile)
    table.insert(world.tiles, Tile.new(tile.x, tile.y, tile.layer, tile.img));
end

function world_collide_insert(collide)
    table.insert(world.collides, Collider.new(collide.x, collide.y, collide.w, collide.h))
end

function world_draw()
    world_tiles_draw();
    --collider_debug_draw();
end

function collider_debug_draw()
    for index=0, #world.collides, 1 do
        if not (world.collides[index] == nil) then
            world.collides[index]:draw()
        end
    end
end

function world_tiles_draw()
    love.graphics.push()
    love.graphics.setColor(255, 255, 255, 255)
    for index=1, table.getn(world.tiles), 1 do
        if not (world.tiles[index] == nil) then
            world.tiles[index]:draw()
        end
    end
    love.graphics.pop()
end
