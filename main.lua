local ents = require("entity")

function love.load()	
	love.graphics.setBackgroundColor({0,0,0})
	
	--ents.new instantiates the given entity and returns the index to it (which may be ignored).
	--The first argument must match the name of the Lua file (minus the extension) of the entity to be created.
	--entity.lua uses this argument to 'require' the correct file.
	--Following arguments are specific to the constructor for that entity.
	
	ents.new("paddle","left")
	ents.new("paddle","right")
	ents.new("paddle","top")
	ents.new("paddle","bottom")
	
	--ents.new("wall",love.graphics.getWidth()/2,love.graphics.getHeight()/2,64,64)
	
	ents.new("ball")
end

function love.update(dt)
	--To address individual objects use:
	--ents.getObject(<index>):update(dt)
	ents:update(dt)
	local balls = ents.getObjectsByName("ball")
	local players = ents.getObjectsByName("paddle")
	
	for _, b in pairs(ents.getObjectsByName("ball")) do
		
		for _, p in pairs(ents.getObjectsByName("paddle")) do
			if b:collidingWith(p) then
				b:bounce(p)
			end
		end
	end
end

local help = [[
Use w,s,c,v,n,m,k and i to control the four paddles.
Press r to create a new ball.
]]
function love.draw()
	--To address individual objects use:
	--ents.getObject(<index>):draw()
	ents:draw()
	
	love.graphics.print(help,0,0)
end

function love.keypressed(key,code)
	if key=='r' then
		ents.new("ball")
	end
end