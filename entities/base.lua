--Required by each actual entity (paddle, ball, etc.)
--Equivalent of creating an inheritance hierarchy where this is the top level class.

--NOTICE: all entities must define the following two functions:
--function ent:draw() - Invoked to request that the entity is drawn to the screen.
--function ent:update(dt) - Invoked to have the entity think over the time period given.

ent = {}

function ent:clone()
	local clone = {}
	for k,v in pairs(self) do
		clone[k] = v
	end
	return clone
end

function ent:setPos(x,y)
	self.x = x
	self.y = y
end

function ent:setSize(w,h)
	self.w = w
	self.h = h
end

function ent:setColour(colours)
	self.colour = colours
end

function ent.new(x,y,w,h,col) --Constructor for new objects
	local newEnt = ent:clone() --Clone the base entity
	
	newEnt:setPos(x or 0,y or 0)
	newEnt:setSize(w or 1, h or 1)
	newEnt:setColour(col or {255,255,255})
	
	return newEnt
end

function ent:collidingWith(other) --Tests for rectangular collisions only
	local selfTrueX = self.x - (self.w/2)
	local selfTrueY = self.y - (self.h/2)
	local otherTrueX = other.x - (other.w/2)
	local otherTrueY = other.y - (other.h/2)
	
	return ((selfTrueX < otherTrueX + other.w and selfTrueX + self.w > otherTrueX)
		and (selfTrueY < otherTrueY + other.h and selfTrueY + self.h > otherTrueY))
end

function ent:tostring()
	local r = ""
	for k,v in pairs(self) do
		r = r..k..":	"..tostring(v)
	end
	return r
end

return ent