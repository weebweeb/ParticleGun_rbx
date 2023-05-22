local module = {}

--[[

TagService, a nice a simple way to put different valuetypes where you want them

Should be used with Roblox Studio, and placed inside a ModuleScript. Preferably in ServerScriptService

arguments: 
valuetype -- type of roblox Value object (StringValue, etc)
where -- where to put it
name -- name the object
value -- value of the object

module should be called as follows:
TagService = require(game.ServerScriptService.TagService)

tag = TagService:TempTag("StringValue", workspace, "Test", "Test")



--]]

function module:TempTag(valuetype, where, name, value)
	local tag
	local s, f = pcall(function()
	if where:FindFirstChild(name) then
	where[name]:Destroy()
	end
	tag = Instance.new(valuetype, where)
	local success, fail = pcall(function() if not tag.Value then return end end)
	if not success then warn("TAGSERVICE: valuetype is not valid"); end
	tag.Name = name
	tag.Value = value
	end)
	if not s then error(f)
	return nil
	else
	return tag
	end
end

return module
