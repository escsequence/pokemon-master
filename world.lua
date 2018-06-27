require 'lookups/lu_warp'

MAP_SIZE = {WIDTH=1000, HEIGHT=1000} -- DO NOT CHANGE THIS EVER

PLAYER_DRAW_DISTANCE = {
  x = 16,
  y = 16
}

local Tile = {}
Tile.__index=Tile
function Tile.new(x, y, layer, img)
    local tile={x=x, y=y, w=16, h=16, layer=layer, img=img}
    return setmetatable(tile, Tile)
end

function Tile:draw()
      if not (resources.sprites.tiles[self.img] == nil) then
          --love.graphics.push()
          --love.graphics.setColor(255, 255, 255, 1)
          love.graphics.draw(resources.spritesheets.tiles, resources.sprites.tiles[self.img], self.x * 16, self.y * 16)
          --love.graphics.pop()
      end
end

local Collider = {}
Collider.__index=Collider
function Collider.new(x, y, w, h)
    local collider={x=x, y=y, w=w, h=h}
    return setmetatable(collider, Collider)
end
function Collider:draw()
  love.graphics.push()
  love.graphics.setColor(255, 0, 0, 0.5)
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
  love.graphics.pop()
end

local Warp = {}
Warp.__index=warp
function Warp.new(x, y, w, h, name)
  local warp = {x=x, y=y, w=w, h=h, name=name, warp_to=WARP_POINT[name].point, player_dir=WARP_POINT[name].dir, cont=WARP_POINT[name].cont}
  return setmetatable(warp, Warp)
end
world = {
    tiles = allocate_2darr(MAP_SIZE.WIDTH, MAP_SIZE.HEIGHT),
    collides = allocate_2darr(MAP_SIZE.WIDTH, MAP_SIZE.HEIGHT),
    warps = allocate_2darr(MAP_SIZE.WIDTH, MAP_SIZE.HEIGHT),
    warps_list = {},
    events = allocate_2darr(MAP_SIZE.WIDTH, MAP_SIZE.HEIGHT),
    triggers = allocate_2darr(MAP_SIZE.WIDTH, MAP_SIZE.HEIGHT),
    objects = allocate_2darr(MAP_SIZE.WIDTH, MAP_SIZE.HEIGHT),
    npcs = allocate_2darr(MAP_SIZE.WIDTH, MAP_SIZE.HEIGHT)
}

function world_clear_all()
    world = {
        tiles = allocate_2darr(MAP_SIZE.WIDTH, MAP_SIZE.HEIGHT),
        collides = allocate_2darr(MAP_SIZE.WIDTH, MAP_SIZE.HEIGHT),
        warps = allocate_2darr(MAP_SIZE.WIDTH, MAP_SIZE.HEIGHT),
        warps_list = {},
        events = allocate_2darr(MAP_SIZE.WIDTH, MAP_SIZE.HEIGHT),
        triggers = allocate_2darr(MAP_SIZE.WIDTH, MAP_SIZE.HEIGHT),
        objects = allocate_2darr(MAP_SIZE.WIDTH, MAP_SIZE.HEIGHT),
        npcs = allocate_2darr(MAP_SIZE.WIDTH, MAP_SIZE.HEIGHT)
    }
end

function clamp(var, min, max)
  if (var < min) then
    return min
  elseif (var > max) then
    return max
  else
    return var
  end
end

function world_update(dt)
end

function world_tile_insert(tile)
  if not (tile.x <= 0 or tile.y <= 0) then
    world.tiles[tile.y][tile.x] = Tile.new(tile.x, tile.y, tile.layer, tile.img);
  end
end

function world_collide_insert(collide)
  if not (collide.x <= 0 or collide.y <= 0) then
    world.collides[collide.y/16][collide.x/16] = Collider.new(collide.x, collide.y, collide.w, collide.h);
    --print("inserted " .. table_dump(world.collides[collide.y][collide.x]))
  end
end

function world_warp_insert(warp)
  if not (warp.x <= 0 or warp.y <= 0) then
    world.warps[warp.y/16][warp.x/16] = Warp.new(warp.x, warp.y, warp.w, warp.h, warp.name);
    table.insert(world.warps_list, Warp.new(warp.x, warp.y, warp.w, warp.h, warp.name))
  end
end

function get_warp_pos(warp_name)
  for id=1, #world.warps_list do
    if not (world.warps_list[id] == nil) then
      if (world.warps_list[id].name == warp_name) then
        return {x = world.warps_list[id].x, y = world.warps_list[id].y}
      end
    end
  end
end

function warp_effect()
  warp_effect_timer = 255;
  warp_effect_trigger = true;
end
warp_effect_timer = 255 --defaults to 1
warp_effect_trigger = false
warp_effect_dif = 1



function world_draw()
    world_tiles_draw();
    if (debug.triggered) then
      collider_debug_draw();
    end
end

function collider_debug_draw()
  local i, d, k, w = camera.getViewport()
  startx = math.floor(i / 16)
  startx = clamp(startx, 1, MAP_SIZE.WIDTH)
  starty = math.floor(d / 16)
  starty = clamp(starty, 1, MAP_SIZE.HEIGHT)
  endx = startx + PLAYER_DRAW_DISTANCE.x
  endx = clamp(endx, 1, MAP_SIZE.WIDTH)
  endy = starty + PLAYER_DRAW_DISTANCE.y
  endy = clamp(endy, 1, MAP_SIZE.HEIGHT)
  for indy=starty, endy, 1 do
    for indx=startx, endx, 1 do
      if not (world.collides[indy] == nil) then
        if not (world.collides[indy][indx] == nil) then
          world.collides[indy][indx]:draw()
        end
      end
    end
  end
end

function world_tiles_draw()
    local i, d, k, w = camera.getViewport()
    startx = math.floor(i / 16)
    startx = clamp(startx, 1, MAP_SIZE.WIDTH)
    starty = math.floor(d / 16)
    starty = clamp(starty, 1, MAP_SIZE.HEIGHT)
    endx = startx + PLAYER_DRAW_DISTANCE.x
    endx = clamp(endx, 1, MAP_SIZE.WIDTH)
    endy = starty + PLAYER_DRAW_DISTANCE.y
    endy = clamp(endy, 1, MAP_SIZE.HEIGHT)
    for indy=starty, endy, 1 do
      for indx=startx, endx, 1 do
        if not (world.tiles[indy] == nil) then
          if not (world.tiles[indy][indx] == nil) then
            world.tiles[indy][indx]:draw()
          end
        end
      end
    end
end
