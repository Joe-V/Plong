wall = require("entities/base")

function wall.new(x,y,w,h)
	--Creates just one wall.
	local inst = wall:clone()
	
	inst:setPos(x,y)
	inst:setSize(w,h)
	inst:setColour({255,255,255})
	
	return inst
end

function wall:draw()
	love.graphics.setColor(self.colour)
	love.graphics.rectangle("fill",self.x-(self.w/2),self.y-(self.h/2),self.w/2,self.h/2)
end

function wall:update(dt)
	--Nothing needed here...
end

return wall