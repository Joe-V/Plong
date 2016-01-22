ball = require("entities/base")

ball.constants = {
	["speedInit"] = 128, --The initial (linear) speed.
	["speedInc"] = 32 --The increase in speed with each hit.
}


function ball.new()
	local inst = ball:clone()
	local sM = ball.constants.speedInit
	
	--math.randomseed()
	
	inst.lastHit = nil --Stores the paddle we previously hit.
	
	inst:setPos(0.5*love.graphics.getWidth(),0.5*love.graphics.getHeight())
	inst:setSize(8,8)
	inst:setColour({255,255,255})
	
	inst.velH = math.random(-sM,sM) --Select a horizontal velocity at random (either direction).
	--Now calculate the vertical velocity so the ball is moving at exactly sM pixels per second.
	--velH^2 + velV^2 = sM^2
	inst.velV = (sM^2 - inst.velH^2)^0.5
	--50% chance to flip it
	if math.random(2) == 1 then inst.velV = -inst.velV end
	
	inst.speed = ball.constants.speedInit --Stores the speed to be applied upon hit.
	
	return inst
end

function ball:update(dt)
	self.x = self.x+(self.velH*dt)
	self.y = self.y+(self.velV*dt)
end

function ball:draw()
	love.graphics.setColor(self.colour)
	love.graphics.circle("line",self.x-(self.w/2),self.y-(self.h/2),self.h/2)
end

local function norm(v)
	if v > 0 then
		return 1
	elseif v < 0 then
		return -1
	else
		return 0
	end
end

--Handles collision events between the ball and a paddle.
function ball:bounce(hitPaddle,axis)
	--hitPaddle: the paddle instance that was hit. Nil indicates something other than a paddle was hit.
	--axis: the axis parallel to the surface we're bouncing off. Retrieved from the paddle if it isn't nil.

	--Continue only if hitPaddle is nil (wall hit) or the paddle we're bouncing off isn't the one we hit last time.
	--This is necessary because the paddles have depth: the side of a paddle could be moved into the ball.
	if not hitPaddle or hitPaddle ~= self.lastHit then
		self.lastHit = hitPaddle
		
		local plane = hitPaddle.sideConstants.freedom or axis
		
		--Determine the angle of incidence from current velocities.
		local thetaI
		-- x: tan(theta) = velV/velH (O/A)
		-- y: tan(theta) = velH/velV (O/A)
		if plane=="y" then
			thetaI = math.atan(self.velV/self.velH)
		else
			--thetaI = 0.5*math.pi - math.atan(self.velV/self.velH) --Angle facing the other way.
			thetaI = math.atan(self.velH/self.velV)
		end
		--print("incidence: "..thetaI)
		
		--Angle of reflection is equal to the angle of incidence plus an angle applied by the paddle (if one was hit) plus an amount of random noise,
		--up to a maximum angle that cannot be exceeded.
		local paddleAng = 0
		if hitPaddle then
			--local paddleAng = hitPaddle.constants.maxReflectionAngle or 0
			if plane=="y" then
				--Proportion of how far we are down the paddle (0 is in the middle, 1 or -1 is right on the edge).
				paddleAng = (hitPaddle.y - self.y)/(hitPaddle.h/2)
			else
				paddleAng = (hitPaddle.x - self.x)/(hitPaddle.w/2)
			end
			paddleAng = paddleAng*hitPaddle.constants.maxReflectionAngle*hitPaddle.sideConstants.orientation
			
			--print("paddleAng: "..paddleAng)
		end
		
		--Apply (angle is absolute):
		local thetaR = hitPaddle.sideConstants.heading + thetaI + paddleAng --+ (math.random(-10,10)/20)*math.pi --random() only generates integers.
		--Set new velocities. One is set according to the angle of reflection. The other is simply negated.
		--The speed goes up.
		if math.abs(thetaR) > hitPaddle.constants.maxReflectionAngle + hitPaddle.sideConstants.heading then
			thetaR = norm(thetaR)*hitPaddle.constants.maxReflectionAngle + hitPaddle.sideConstants.heading --Cap
		end
		--print("reflection: "..thetaR)
		self.speed = self.speed + ball.constants.speedInc
		if plane=="y" then
			self.velV = math.cos(thetaR) * self.speed
			self.velH = math.sin(thetaR) * self.speed
		else
			self.velV = math.sin(thetaR) * self.speed
			self.velH = math.cos(thetaR) * self.speed
		end
		
	end
end

return ball