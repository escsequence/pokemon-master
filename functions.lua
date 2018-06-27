default = {
	size = 16,
	m_size = 1
}

function colorToRGB(color)
	--if (color === "red") then
		--return
	--end
end

function allocate_2darr(x, y)
  local ar = {}
  for i = 1, x do
      ar[i] = {}
      for j = 1, y do
          ar[i][j] = nil
      end
  end
  return ar
end

function clamp(min, val, max)
    return math.max(min, math.min(val, max));
end

function drawRect(color, x, y, w, h)
	love.graphics.push()
	love.graphics.setColor(255,0,0)
	love.graphics.rectangle("fill", 20, 50, 60, 120 )
	love.graphics.pop()
end

function drawText(text, x, y, color, font)
	love.graphics.push()
	love.graphics.setColor(color.r, color.g, color.b, color.a)
	love.graphics.setFont(font)
	love.graphics.print(text, x, y)
	love.graphics.pop()
end

function setBackgroundColor(r, g, b)
	bgColor = {r, g, b};
end


function size(table)
	return table.getn(table);
end

function collides(x1,y1,x2,y2)
  return x1 < x2+default.size and
         x2 < x1+default.size and
         y1 < y2+default.size and
         y2 < y1+default.size
end
function collides_rect(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function withinView(ww, wl, wx, wr, x, y)
    return collides_rect(x, y, 16, 16, ww, wl, wx, wr)
end

--https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console
function table_dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. table_dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

--https://stackoverflow.com/questions/1426954/split-string-in-lua
function str_split(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

function pokemon_catch_formula(ball_type, pokemon)
	local R1, R2, R3, S, F

	-- Determine ball type variables
	if (ball_type == "master") then
		return true;
	elseif (ball_type == "ultra" or ball_type == "safari") then
		R1 = love.math.random(0,150);
	elseif (ball_type == "great") then
		R1 = love.math.random(0,200);
	elseif (ball_type == "normal") then
		R1 = love.math.random(0,255);
	end

	-- Status conditions
	if (pokemon.status == "frozen") then
		S = 25;
	elseif (pokemon.status == "burned" or pokemon.status == "poisoned" or pokemon.status == "paralyzed") then
		S = 12;
	else
		S = 0;
	end

	-- Some calculating
	R2 = R1 - S;
	if (R2 < 0) then
		return true;
	end

	-- HP factor
	F = pokemon.max_hp * 255;
	if (ball_type == "great") then
		F = F / 8;
	else
		F = F / 12;
	end

	if ((pokemon.current_hp / 4) > 0) then
		F = F / (pokemon.current_hp / 4);
	end

	if (F > 255) then
		F = 255;
	end

	-- More calculating and checks
	if (pokemon.catch_rate < R2) then
		return false;
	end

	R3 = love.math.random(0,255);

	if (R3 <= F) then
		return true;
	else
		return false;
	end
end

function pokemon_catch_wobbles()
end
