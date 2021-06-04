local base_sprite_dimensions = 16 -- 16x16 for sprites
function typeof(var)
    local _type = type(var);
    if(_type ~= "table" and _type ~= "userdata") then
        return _type;
    end
    local _meta = getmetatable(var);
    if(_meta ~= nil and _meta._NAME ~= nil) then
        return _meta._NAME;
    else
        return _type;
    end
end

function animation_new(frames, duration, reversii)
    local animation = {}
    animation.frames = frames;
    animation.reversii = false
    animation.can_reversii = reversii
    animation.duration = duration or 1
    animation.currentTime = 0
    animation.frame_select = 1
    animation.frame_max = table.getn(frames);
    return animation
end

function animation_update(animation, dt)
	animation.currentTime = animation.currentTime + dt
    if animation.currentTime >= animation.duration then
        animation.currentTime = animation.currentTime - animation.duration
        animation.frame_select = animation.frame_select + 1
        if (animation.frame_select > animation.frame_max) then
        	animation.frame_select = 1
        	if (animation.can_reversii == true) then
	        	if (animation.reversii == true) then
	        		animation.reversii = false
	        	else
	        		animation.reversii = true
	        	end
        	end
        end
    end
end

function animation_draw(animation, x, y, flip)
	local current_frame = animation.frame_select;
	local frame = animation.frames[current_frame];

	if (flip or animation.reversii) then
		love.graphics.draw(resources.spritesheets.npc, resources.sprites.npc[frame], x+base_sprite_dimensions, y, 0, -1, 1)
	else
		love.graphics.draw(resources.spritesheets.npc, resources.sprites.npc[frame], x, y);
	end
end
