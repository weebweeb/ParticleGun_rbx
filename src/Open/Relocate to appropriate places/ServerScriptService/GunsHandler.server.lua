
damagetable = {["Pistol"] = 10}
TagService = require(game.ServerScriptService.TagService)
--wantedModule = require(game.ReplicatedStorage.WantedModule)

soundtable = {
	ricochet = {4635371125,4635372723,4635372161},
	impact = {2640195272, 2640195272}
	
}

function makesound(id , where, volume)
	local s = Instance.new("Sound", where)
	s.SoundId = "rbxassetid://"..tostring(id)
	s.PlayOnRemove = true
	s.Volume = volume or 0.5
	s.PlaybackSpeed = math.random(95, 105)/100
	s:Destroy()
end

function makesparks(where)
	local cl = game.ReplicatedStorage.Assets.FX.Sparks:Clone()
	cl.Parent = workspace
	--where = where - Vector3.new(0,2,3)
	cl.Position = where
	makesound(soundtable.ricochet[math.random(1,#soundtable.ricochet)], cl)
	wait(0.1)
	for i, v in pairs(cl:GetChildren()) do
		v.Enabled = false
	end
	game.Debris:AddItem(cl, 1)
	
end

function changeRate(rate, name, where)
	for i, v in pairs(where:GetChildren()) do
		if string.find(v.Name, name) then
			v.Rate = rate
			
		end
	end
end

function makeblood(where)
	local cl = game.ReplicatedStorage.Assets.FX.Blood:Clone()
	cl.Parent = workspace
	--where = where - Vector3.new(0,2,3)
	cl.Position = where
	makesound(soundtable.impact[math.random(1,#soundtable.impact)], cl, 0.2)
	wait(0.1)
	for i, v in pairs(cl:GetChildren()) do
	v.Enabled = false
	end
	game.Debris:AddItem(cl, 1)
	
end
local ti = -5
local function cone(num, cone, shotty)
	if shotty == nil or shotty == false then return 0 end
	if ti >= num + cone/10 then ti = 0 - cone/10 end
	ti = ti + 0.1
	num = num + ti
	return num
end

function bulletparticlefx(where, ray, dist, shotgun, Rate)
	for i = 1, 6, 1 do
		if i == 1 then
			where.BarrelParticle["Bullet"].Acceleration = ray.Direction
			where.BarrelParticle.Bullet.Lifetime = dist

		else
			where.BarrelParticle["Bullet"..i].Acceleration = ray.Direction
			where.BarrelParticle["Bullet"..i].Lifetime = dist
		end
	end
	for i = 1, 6, 1	 do
		if i == 1 then
			where.BarrelParticle.ParticleEmitter.Enabled = true
			where.BarrelParticle.PointLight.Enabled = true
			where.BarrelParticle.Bullet.Enabled = true

		else
			where.BarrelParticle["Bullet"..i].Enabled = true
		end
	end
	
	if shotgun ~= true then
		if Rate ~= nil then
			wait(Rate - 0.01)
		else
			wait(0.15)
		end
	else wait(0.05)
	end
	for i = 1, 6, 1	 do
		if i == 1 then
			where.BarrelParticle.ParticleEmitter.Enabled = false
			where.BarrelParticle.PointLight.Enabled = false
			where.BarrelParticle.Bullet.Enabled = false

		else
			where.BarrelParticle["Bullet"..i].Enabled = false
		end
	end
end


function replicategunfire(player, where, unitRay, Rate, bullets, spread, shotgun , right)
	bullets = bullets or 1
	spread = 3

	ti = 0 - (spread + 0.3)
	for i = 1, bullets do
		coroutine.wrap(function()
		
		if Rate > 0 and i > 1 and shotgun == false and bullets > 1 then
				wait(Rate*(i-1))
		end
			
		if where:FindFirstChild("Fire") then
				where.Fire.PlaybackSpeed = (math.random(97,102))/100
				where.Fire:Play()
		end
			
		local length = 2000

		local ray = Ray.new(where.Parent.Head.Position, (unitRay.Direction  + (right* cone(2, spread, shotgun))) * length)
		local findparts, hitposition = workspace:FindPartOnRayWithIgnoreList(ray, player.Character:GetDescendants())
	
		local distt = (player.Character.HumanoidRootPart.Position - hitposition).Magnitude
		local dist = NumberRange.new(distt)
			
		if Rate then
			if shotgun then
				changeRate(Rate * 100, "Bullet", where.BarrelParticle)
			else
				changeRate(2/Rate, "Bullet", where.BarrelParticle)
			end
		end
		bulletparticlefx(where, ray, dist)

		if hitposition then
			if findparts and findparts.Parent:FindFirstChild("Humanoid") or findparts and findparts.Parent.Parent:FindFirstChild("Humanoid") then
				makeblood(hitposition)
				else
				makesparks(hitposition)
			end
		end
			
			
			end)()
	end
end




function gungun(player, where, unitRay, Rate, bullets, spread, shotgun, right)
	--bullets = bullets or 1
	--spread = spread or math.random(1,3)
		ti = 0 - (spread + 0.3)
	for i = 1, bullets do
		coroutine.wrap(function()
		
			if Rate > 0 and i > 1 and shotgun == false and bullets > 1 then
				wait(Rate*(i-1))
			end
			if where:FindFirstChild("Fire") then
				where.Fire.PlaybackSpeed = (math.random(97,102))/100
				where.Fire:Play()
			end
			
			local length = 2000
			local ray = Ray.new(where.Parent.Head.Position, (unitRay.Direction  + (right* cone(2, spread, shotgun))) * length)
			local findparts, hitposition = workspace:FindPartOnRayWithIgnoreList(ray, player.Character:GetDescendants())
	
			local distt = (player.Character.HumanoidRootPart.Position - hitposition).Magnitude
			local dist = NumberRange.new(distt)
			
			if Rate then
				if shotgun then
					changeRate(Rate * 100, "Bullet", where.BarrelParticle)
				else
				changeRate(2/Rate, "Bullet", where.BarrelParticle)
				end
			end
	
			bulletparticlefx(where, ray, dist)

			if hitposition then
				if findparts and findparts.Parent:FindFirstChild("Humanoid") or findparts and findparts.Parent.Parent:FindFirstChild("Humanoid") then
					makeblood(hitposition)
					else
					makesparks(hitposition)
				end
			end
			
			if findparts then
		
				if findparts.Parent ~= nil and findparts.Parent:FindFirstChild("NPCData") then
					TagService:TempTag("ObjectValue", findparts.Parent.NPCData, "creator", player.Character)
					findparts.Parent.NPCData.Health.Value = findparts.Parent.NPCData.Health.Value - damagetable[where.Name]*3
			else
				if findparts.Parent.Parent ~= nil and findparts.Parent.Parent:FindFirstChild("NPCData") then
				TagService:TempTag("ObjectValue", findparts.Parent.Parent.NPCData, "creator", player.Character)

				findparts.Parent.Parent.NPCData.Health.Value = findparts.Parent.Parent.NPCData.Health.Value - damagetable[where.Name]*3
				end
			end
		
			if findparts.Parent:FindFirstChild("Humanoid") then
				TagService:TempTag("ObjectValue", findparts.Parent.Humanoid, "creator", player.Character)
				findparts.Parent.Humanoid:TakeDamage(damagetable[where.Name])
				else
					if findparts.Parent.Parent:FindFirstChild("Humanoid") then
						TagService:TempTag("ObjectValue", findparts.Parent.Parent.Humanoid, "creator", player.Character)
						findparts.Parent.Parent.Humanoid:TakeDamage(damagetable[where.Name])
	
						end
					end
				end
			end)()
	end
	--[[
	if shotgun == true then
		if Rate ~= nil then
			wait(Rate - 0.01)
			else
			wait(0.15)
		end
	end
	--]]
end

game.ReplicatedStorage.ReplicateGun.Event:Connect(function(player, where, unitRay, Rate, bullets, spread, shotgun , right, slowmo)
	replicategunfire(player, where, unitRay, Rate, bullets, spread, shotgun , right, slowmo)
end)

game.ReplicatedStorage.FireGun.OnServerEvent:Connect(function(player, where, unitRay, Rate, bullets, spread, shotgun , right)
	gungun(player, where, unitRay, Rate, bullets, spread, shotgun , right)
end)
