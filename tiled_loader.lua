-- LoadXML from http://lua-users.org/wiki/LuaXml
function LoadXML(s)
  local function LoadXML_parseargs(s)
    local arg = {}
    string.gsub(s, "(%w+)=([\"'])(.-)%2", function (w, _, a)
    arg[w] = a
    end)
    return arg
  end
  local stack = {}
  local top = {}
  table.insert(stack, top)
  local ni,c,label,xarg, empty
  local i, j = 1, 1
  while true do
    ni,j,c,label,xarg, empty = string.find(s, "<(%/?)([%w:]+)(.-)(%/?)>", i)
    if not ni then break end
    local text = string.sub(s, i, ni-1)
    if not string.find(text, "^%s*$") then
      table.insert(top, text)
    end
    if empty == "/" then  -- empty element tag
      table.insert(top, {label=label, xarg=LoadXML_parseargs(xarg), empty=1})
    elseif c == "" then   -- start tag
      top = {label=label, xarg=LoadXML_parseargs(xarg)}
      table.insert(stack, top)   -- new level
    else  -- end tag
      local toclose = table.remove(stack)  -- remove top
      top = stack[#stack]
      if #stack < 1 then
        error("nothing to close with "..label)
      end
      if toclose.label ~= label then
        error("trying to close "..toclose.label.." with "..label)
      end
      table.insert(top, toclose)
    end
    i = j+1
  end
  local text = string.sub(s, i)
  if not string.find(text, "^%s*$") then
    table.insert(stack[#stack], text)
  end
  if #stack > 1 then
    error("unclosed "..stack[stack.n].label)
  end
  return stack[1]
end

function getMapChunks(node)
  local chunks = {}
  for k, sub in ipairs(node) do
      if (sub.xarg.name == "Tile") then
        for cid=1, #sub[1] do
          if not (sub[1][cid] == nil) then
            if (sub[1][cid].label == "chunk") then
              table.insert(chunks, sub[1][cid])
            end
          end
        end
      end
  end
  return chunks
end

function getAllMapObjects(node)
  local mobj = {}
  for k, sub in ipairs(node) do
      if (sub.label == "objectgroup") then
        table.insert(mobj, sub)
      end
  end
  return mobj;
end

-- Functions below require the getAllMNapObjects prior
function getMapColliders(map_objects)
  local colliders = {}
  for oid=1, #map_objects do
    if (map_objects[oid].xarg.name == "Collider") then
      for cid=1, #map_objects[oid] do
        table.insert(colliders, map_objects[oid][cid])
      end
    end
  end
  return colliders;
end

function getMapWarps(map_objects)
  local warps = {}
  for oid=1, #map_objects do
    if (map_objects[oid].xarg.name == "Warp") then
      for cid=1, #map_objects[oid] do
        table.insert(warps, map_objects[oid][cid])
      end
    end
  end
  return warps;
end

function getDebugPlayerStart(map_objects)
  local debugStartPos = {x = 32, y = 32}
  for oid=1, #map_objects do
    if (map_objects[oid].xarg.name == "InitalPlayerStartTest") then
      for cid=1, #map_objects[oid] do
        local offset = {x=0, y=0}
        -- ALWAYS MAKLE SURE TO CHECK FOR OFFSETS...
        if not (map_objects[oid].xarg.offsetx == nil) then
          offset.x = tonumber(map_objects[oid].xarg.offsetx)
        end
        if not (map_objects[oid].xarg.offsety == nil) then
          offset.y = tonumber(map_objects[oid].xarg.offsety)
        end
        debugStartPos = {x = tonumber(map_objects[oid][cid].xarg.x) + offset.x, y = tonumber(map_objects[oid][cid].xarg.y) + offset.y}
      end
    end
  end
  return debugStartPos;
end

function TiledMap_Parse(filename)
    local xml = LoadXML(love.filesystem.read(filename))
    return xml[2];
end
