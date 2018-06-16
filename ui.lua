-- This is the was ripped straight outta pokemon, ghetto style.
-- This UI is designed to display a pop-up message - requires specific size, and if a title should be used

ui = {
    border = {
        left = {
            top = 1,
            bottom = 2
        },
        right = {
            top = 3,
            bottom = 4
        },
        hort = 5,
        vert = 6,
    },
    arrow = {
        fill = 7,
        nofill = 8
    },
    blank = 10,
    box_types = {
        debugo = {
            title = "debuggo",
            dt = false,
            x = 0,
            y = 0,
            w = 12,
            h = 2,
            color = {
                r = 255,
                g = 255,
                b = 255,
                a = 255
            },
            txt_color = {
                r = 0,
                g = 0,
                b = 0,
                a = 255
            }
        },
        ig_menu = {
            title = "",
            dt = false,
            x = 273,
            y = 0,
            w = 8,
            h = 11,
            color = {
                r = 255,
                g = 255,
                b = 255,
                a = 255
            },
            txt_color = {
                r = 0,
                g = 0,
                b = 0,
                a = 255
            }
        },
        txt = {
            title = "",
            dt = true,
            x = 100,
            y = 100,
            w = 16,
            h = 4,
            color = {
                r = 255,
                g = 255,
                b = 255,
                a = 255
            },
            txt_color = {
                r = 0,
                g = 0,
                b = 0,
                a = 255
            }
        }
    }
}


function draw_base_ui(box_type, txt, scale)
    -- Check if box is valid
    if (box_type == nil) then
        debug_error("Invalid box type for display", box_type, true)
    end
    -- Cool it's valid, continue
    love.graphics.push()
    -- Default scaling
    if (scale == nil) then
        scale = {x = 2, y = 2}
    end
    -- Check alpha values, if never set we will default to no alpha
    if (box_type.color == nil) then
        box_type.color = {
            r = 255,
            g = 255,
            b = 255,
            a = 255
        }
    end
    love.graphics.scale(scale.x, scale.y)
    love.graphics.setColor(box_type.color.r, box_type.color.g, box_type.color.b, box_type.color.a)
    local vert_count = box_type.w-2;
    for ilength=0, box_type.h, 1 do
        -- Top border portion
        if (ilength == 0) then
            love.graphics.draw(resources.spritesheets.ui, resources.sprites.ui[ui.border.left.top], box_type.x, box_type.y)
            for iwidth=1, box_type.w-2, 1 do
                love.graphics.draw(resources.spritesheets.ui, resources.sprites.ui[ui.border.hort], box_type.x + (iwidth * 16), box_type.y)
                --[[
                if (iwidth == box_type.w/2) then
                    love.graphics.rectangle("fill", 0, 0, 512, 32)
                    love.graphics.setColor(0, 0, 0)
                    love.graphics.setFont(font_n)
                    love.graphics.print(box_type.title, box_type.x + (iwidth * 16), box_type.y)
                    love.graphics.setColor(255, 255, 255, box_type.alpha)
                end]]--
            end
            if not (box_type.title == nil) then
                love.graphics.draw(resources.spritesheets.ui, resources.sprites.ui[ui.border.right.top], box_type.x + ((vert_count+1) * 16), box_type.y)
                love.graphics.rectangle("fill", box_type.x + ((((vert_count+1) * 16) - 96)/2), box_type.y, string.len(box_type.title) * 16, 32)
                love.graphics.setColor(box_type.txt_color.r, box_type.txt_color.g, box_type.txt_color.b, box_type.txt_color.a)
                love.graphics.setFont(font_lg)
                love.graphics.print(box_type.title, box_type.x + ((((vert_count+1) * 16) - 96)/2), box_type.y)
                love.graphics.setColor(box_type.color.r, box_type.color.g, box_type.color.b, box_type.color.a)
            end
        -- Bottom border portion
        elseif (ilength == box_type.h) then
            love.graphics.draw(resources.spritesheets.ui, resources.sprites.ui[ui.border.left.bottom], box_type.x, box_type.y + (ilength  * 16))
            for iwidth=1, box_type.w-2, 1 do
                love.graphics.draw(resources.spritesheets.ui, resources.sprites.ui[ui.border.hort], box_type.x + (iwidth * 16), box_type.y + (ilength * 16))
            end
            love.graphics.draw(resources.spritesheets.ui, resources.sprites.ui[ui.border.right.bottom], box_type.x + ((vert_count+1) * 16), box_type.y + (ilength * 16))

        -- Entire content + vertical borders
        else
            love.graphics.draw(resources.spritesheets.ui, resources.sprites.ui[ui.border.vert], box_type.x, box_type.y + (ilength * 16))
            for iwidth=1, box_type.w-2, 1 do
                love.graphics.draw(resources.spritesheets.ui, resources.sprites.ui[ui.blank], box_type.x + (iwidth * 16), box_type.y + (ilength * 16))
            end
            love.graphics.draw(resources.spritesheets.ui, resources.sprites.ui[ui.border.vert], box_type.x + ((vert_count+1) * 16), box_type.y + (ilength * 16))

        end
    end
    if (box_type.dt) then
        love.graphics.setColor(0, 0, 0)
        love.graphics.scale(1, 1)
        love.graphics.setFont(font_lg)
    	love.graphics.print(txt, box_type.x + 18, box_type.y + 18)
    end
    love.graphics.pop()
end
