-- Resource table, lays out the frame work
-- www.spriters-resource.com
love.filesystem.load("tiled_loader.lua")()

what = ""

resources = {
    spritesheets = {},
    sprites = {
        npc = {},
        tiles = {},
        ui = {}
    },
    sounds = {},
    levels = {},


}


local base_location = "graphics/"
local base_sprite_dimensions = 16 -- 16x16 for sprites



function load_resources()
    load_ui_resources();
    load_npc_resources()
    load_tilesheet_resources()
  --load_level();
end

function load_level()
    raw_map_data = TiledMap_Parse("maps/main_overworld.tmx")
    --print(getMapChunks(raw_map_data))
    --print(table_dump(getMapChunks(raw_map_data[2]))) --get some chunks from this nice big ol chunk data
    --print(table_dump(getMapChunks(raw_map_data)[3]))
    chunks = getMapChunks(raw_map_data);
    generate_all_map_objects(getAllMapObjects(raw_map_data))


    -- search through the chunks to find something useful
    for nx=1, #chunks, 1 do
      if (not (chunks[nx] == nil) and (chunks[nx].label == "chunk")) then --if the chunk is real
        local current_chunk = chunks[nx] -- cool, here is the chunk
        --print(current_chunk)
        local current_chunk_tile_data = str_split(current_chunk[1], ',') --seperate our stupid array

        -- Generate chunk function, yo.
        generate_chunk(tonumber(current_chunk.xarg.x), tonumber(current_chunk.xarg.y), 16, current_chunk_tile_data)

      end
    end
end

function generate_all_map_objects(map_objects)

    --world_collide_insert({x=32, y=0, w=32, h=32})
    --world_collide_insert({x=64, y=0, w=32, h=32})
    --world_collide_insert({x=128, y=32, w=32, h=32})
    --world_collide_insert({x=0, y=0, w=32, h=32})

  --random_freaking_number = #map_objects
  if (debug.enabled) then
    player_pos = getDebugPlayerStart(map_objects)
  end


  local colliders = getMapColliders(map_objects)
  for nx=1, #colliders, 1 do
      local collider = colliders[nx].xarg
      world_collide_insert({x=tonumber(collider.x), y=tonumber(collider.y), w=tonumber(collider.width), h=tonumber(collider.height)})
  end
end

function generate_object(type, x, y, w, h)
end

function generate_chunk(s_x, s_y, size, tilechunk)
    local xx = s_x
    local yy = s_y

    for ind=1, #tilechunk, 1 do
      if not (tilechunk[ind] == nil) then
        local img_num = tonumber(tilechunk[ind])
          if not (img_num == 0) then
            world_tile_insert({x=xx, y=yy, layer=1, img=img_num})
          end
        end
        xx = xx + 1
        if (xx >= (s_x + size)) then
          xx = s_x
          yy = yy + 1
        end
    end
end

function seperate_sheet(sheet, padding)
    if not (sheet == nil) then
        -- Check some arguments real quick, adjust
        if (padding == nil) then
            padding = {x = 0, y = 0, m_x = 0};
        end

        -- Get the base dimensions of the sheet
        local sheet_dimensions = {
            width = sheet:getWidth();
            height = sheet:getHeight();
        }

        -- Basic checking, to make sure the sheet isn't bogus
        if ((sheet_dimensions.width == nil or sheet_dimensions.height == nil) or (sheet_dimensions.width <= 0 and sheet_dimensions.height <= 0)) then
            return;
        end

        -- How many iterations will be needed
        local it_count = (sheet_dimensions.width / base_sprite_dimensions) * (sheet_dimensions.height / base_sprite_dimensions);
        local sprite
        local index_x = 0
        local sheet_loc = {x = 0, y = 0}
        local index_x = 0
        local spritesheet_pos_y = 0
        local r_table = {}

        local max_x = sheet_dimensions.width;
        local max_y = math.ceil(sheet_dimensions.height / base_sprite_dimensions);
        for index=0, it_count, 1 do
            sprite = love.graphics.newQuad(sheet_loc.x,
                                           sheet_loc.y,
                                           base_sprite_dimensions,
                                           base_sprite_dimensions,
                                           sheet:getDimensions());

           table.insert(r_table, sprite);
           sheet_loc.x = (sheet_loc.x + base_sprite_dimensions) + padding.x

           index_x = index_x + 1;
           if ((index_x*base_sprite_dimensions) >= (max_x - padding.m_x)) then
               sheet_loc.x = 0
               index_x = 0
               sheet_loc.y = (sheet_loc.y + base_sprite_dimensions) + padding.y;
           end
        end
        return r_table;
    end
end

function load_ui_resources()
    resources.spritesheets.ui = love.graphics.newImage(base_location .. "ui.png");
    resources.sprites.ui = seperate_sheet(resources.spritesheets.ui, {x = 0, y = 0, m_x = 0})
end

function load_tilesheet_resources()
    resources.spritesheets.tiles = love.graphics.newImage(base_location .. "tiles.png");
    resources.sprites.tiles = seperate_sheet(resources.spritesheets.tiles, {x = 0, y = 0, m_x = 0})
end

function load_npc_resources()
    resources.spritesheets.npc = love.graphics.newImage(base_location .. "npc.png");
    resources.sprites.npc = seperate_sheet(resources.spritesheets.npc, {x = 2, y = 2, m_x = 48})
end

function get_resource(val)
end

function unload_resources()
    resources = {} --empty everything!
end
