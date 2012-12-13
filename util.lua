require "snakeconf"


function shadowRectangle(style, left, top, width, height, shadowSize)
	love.graphics.setColor(0, 0, 0);
	--shadowCanvas:renderTo(function()
	--					      love.graphics.rectangle(style, left + shadowSize, top + shadowSize, width, height)
	--					  end);
	
	love.graphics.setColor(150, 150, 150);
	mainCanvas:renderTo(function()
							love.graphics.rectangle(style, left + ((love.graphics.getWidth() - ((gameBounds.right + 1) * tileWidth)) / 2), top, width, height)
						end);	
end

function split(pString, pPattern)
	local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
	local fpat = "(.-)" .. pPattern
	local last_end = 1
	local s, e, cap = pString:find(fpat, 1)
	while s do
		if s ~= 1 or cap ~= "" then
	table.insert(Table,cap)
		end
		last_end = e+1
		s, e, cap = pString:find(fpat, last_end)
	end
	if last_end <= #pString then
		cap = pString:sub(last_end)
		table.insert(Table, cap)
	end
	return Table
end
