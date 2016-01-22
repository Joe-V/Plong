paddle = require("entities/base")

paddle.constants = { --Respective starting positions as proportions of the screen.
					--Also defines width and height mapping for each paddle.
					--"freedom" indicates the axis through which the paddle may move.
	["length"] = 128,
	["depth"] = 32,
	["speed"] = 700,
	["left"] = {["x"] = 0.1,["y"] = 0.5,["freedom"] = "y",["shiftUp"] = "w",["shiftDown"] = "s",["heading"]=0.5*math.pi,["orientation"]=1},
	["right"] = {["x"] = 0.9,["y"] = 0.5,["freedom"] = "y",["shiftUp"] = "i",["shiftDown"] = "k",["heading"]=1.5*math.pi,["orientation"]=-1},
	["top"] = {["x"] = 0.5,["y"] = 0.1,["freedom"] = "x",["shiftUp"] = "c",["shiftDown"] = "v",["heading"]=0.5*math.pi,["orientation"]=1},
	["bottom"] = {["x"] = 0.5, ["y"] = 0.9,["freedom"] = "x",["shiftUp"] = "n",["shiftDown"] = "m",["heading"]=1.5*math.pi,["orientation"]=-1},
	["maxReflectionAngle"] = (45/180)*math.pi --Maximum ball reflection angle (when the ball hits the very edge of the paddle).
}

--Publicly usable constructor.
--side is one of "left", "right", "top" or "bottom".
function paddle.new(side)
	paddle.sideConstants = paddle.constants[side]
	if not paddle.sideConstants then error("Error: paddle edge '"..side.."' isn't defined.") end
	
	local inst = paddle:clone() --Create a CLONE of the EMPTY DEFINITION of a paddle (see function in base).
	
	inst:setPos(paddle.sideConstants.x*love.graphics.getWidth(),paddle.sideConstants.y*love.graphics.getHeight())
	--Orientate each paddle appropriately:
	if side == "left" or side == "right" then
		inst:setSize(paddle.constants.depth,paddle.constants.length)
	else
		inst:setSize(paddle.constants.length,paddle.constants.depth)
	end
	inst:setColour({255,255,255})
	
	inst.movementAxis = paddle.sideConstants.freedom
	inst.upButton = paddle.sideConstants.shiftUp
	inst.downButton = paddle.sideConstants.shiftDown
	
	return inst
end

--This replaces base:draw() - we're overriding the default function with one
--specific to all paddles.
function paddle:draw()
	love.graphics.setColor(self.colour)
	love.graphics.rectangle("line",self.x-(self.w/2),self.y-(self.h/2),self.w,self.h)
end

--New function
function paddle:shift(dt,dir)
	--dir represents the direction.
	--1 indicates down/right, -1 indicates up/left
	
	--movementAxis contains either x or y depending on where the paddle is.
	self[self.movementAxis] = self[self.movementAxis] + dir*self.constants.speed*dt
	--i.e. paddle[x] = paddle[x] + ...
end

function paddle:update(dt)
	if love.keyboard.isDown(self.upButton) then
		self:shift(dt,-1)
	elseif love.keyboard.isDown(self.downButton) then
		self:shift(dt,1)
	end
end

return paddle