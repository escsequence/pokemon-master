require 'ui'

ui_pos = 1
ui_items = {'POKeDEX', 'POKeMON', 'ITEM', 'Player', 'SAVE', 'OPTION', 'EXIT'}
ui_displayed = false

-- This function triggers the UI to show
function openMenu()
end

-- This function triggers the UI to hide
function closeMenu()
end


function ui_draw()
	love.graphics.push()


    --love.graphics.print('(Debuggo Menu)\nSelected Index: ' .. important_index .. '\nCurrent animation frame: ' .. player_current_animation.frames[player_current_animation.frame_select], 2, 2)
    --love.graphics.print(table_dump(what[2][1][1].xarg), 2, 2)
	draw_base_ui(ui.box_types.ig_menu)

	--love.graphics.setColor(0, 0, 0, 255)
    love.graphics.setFont(font_xl)
	for mid=1, #ui_items, 1 do

		if (mid == ui_pos) then
			love.graphics.push()
			love.graphics.setColor(255, 255, 255)
			love.graphics.scale(2, 2)
			--love.graphics.draw(resources.spritesheets.ui, resources.sprites.ui[ui.arrow.fill], 290, (47 * (mid-1)))
			love.graphics.pop()
		end
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.print(ui_items[mid], 608, 44 + (47 * (mid-1)))
	end

	love.graphics.setFont(bank_font)

    --love.graphics.print(table_dump(random_freaking_number), 2, 2)


    love.graphics.pop()
end

function ui_update(dt)
end
