local ents = {}
ents.objects = {} --Contains all instantiated entities.
ents.names = {} --Stores the names of those entities (names match the defining Lua file).
local entityDir = "entities/"
local index = 0 --Indexing actually starts at 1 (see ents.new())

--Constructs a new instance and returns the index of the instance in the objects table.
function ents.new(entName,...)
	local inst = require(entityDir..entName)

	if not inst then
		error("Error: entity '"..entName.."' does not exist.")
	elseif not inst.new then
		error("Error: the entity '"..entName.."' has no constructor.")
	else
		--Check for required functions that are missing.
		if not inst.draw then
			print("Warning: "..entName..".lua doesn't specify a draw() definition!")
		end
		if not inst.update then
			print("Warning: "..entName..".lua doesn't specify an update() definition!")
		end
		
		index = index + 1
		ents.objects[index] = inst.new(...)
		ents.names[index] = entName
		return index
	end
end

function ents:draw()
	for _,ent in pairs(ents.objects) do
		if ent.draw then
			ent:draw()
		end
	end
end

function ents:update(dt)
	for _,ent in pairs(ents.objects) do
		if ent.update then
			ent:update(dt)
		end
	end
end

function ents.getObject(index)
	return ents.objects[index] or nil
end

function ents.getObjectsByName(name)
	local t = {}
	local i = 1
	for k,v in pairs(ents.names) do
		if v == name then
			t[i] = ents.objects[k] --Capture corresponding object.
			i = i + 1
		end
	end
	
	return t
end

return setmetatable(ents,{["__call"] = function(_,...) return ents.new(...) end})