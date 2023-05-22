local function initGun(parent, GunType, auto, maxammo,ammo,stored,firerate, cooldown, burst, bulletspread, shotgun)
	
	wait(1)
local parent = parent
local GunType = GunType
local auto = auto
local maxammo = maxammo
local ammo = ammo
local stored = stored
local firerate = firerate	
local cooldown = cooldown	
local burst = burst	or 1
local bulletspread = bulletspread or math.random(1,3)
local shotgun = shotgun or false

local localplayer = game.Players.LocalPlayer
local character = localplayer.Character or localplayer.CharacterAdded:Wait() 
local equipped = false
local hum = character:WaitForChild("Humanoid")
local uis = game:GetService("UserInputService")
local holdgun = hum:LoadAnimation(game.ReplicatedStorage.Assets.Animations["Equip"..GunType])
local firegun = hum:LoadAnimation(game.ReplicatedStorage.Assets.Animations[GunType.."Fire"])
local reloadgun = hum:LoadAnimation(game.ReplicatedStorage.Assets.Animations[GunType.."Reload"])
local gunanimfire = nil
local reloadsound = parent.Reload
local position = nil
local firinggun = false
local tool = parent
local Mouse = localplayer:GetMouse()
local reloading = false
local firing = false
local camera = workspace.CurrentCamera
local lastfired = os.time()
local spread = 0
local ie = nil
local ib = nil
local ga = nil
local gg = nil
holdgun.Priority = Enum.AnimationPriority.Movement
firegun.Priority = Enum.AnimationPriority.Movement
reloadgun.Priority = Enum.AnimationPriority.Movement


local reload = function()
		--if firinggun == true then return end
	if ammo == maxammo then return end
		if stored == 0 then return end
		reloading = true
		firing = false
		reloadgun:Play()
		reloadsound:Play()
		reloadsound.Ended:Wait()
	
	local oldstored = stored
	if stored ~= "inf" then
		stored = math.max(0, stored - (maxammo-ammo))
	else
		stored = stored
	end
	if stored ~= "inf" then
		if oldstored <= maxammo then
			ammo = oldstored
		else
			ammo = maxammo
		end
	else
	ammo = maxammo

	end
	wait(reloadgun.Length - 2 or 0.5)
	firinggun = false
	reloading = false
	localplayer.PlayerGui.main.Ammo.TextLabel.Text = tostring(ammo).."|"..tostring(stored)
	
	
end

local fire = function()
	if firinggun == true then return end
		if reloading == false then
			firinggun = true
			if ammo > 0 then
				if parent:FindFirstChild("AnimationController") then
					if gunanimfire == nil then
						gunanimfire = parent.AnimationController:LoadAnimation(game.ReplicatedStorage:FindFirstChild(string.upper(GunType).."SHOOT"))
					end
					--print("playing animation")
					gunanimfire:Play()
				end
				character:WaitForChild("LocalFX").Recoil.Value = true
				firegun:Play()
				ammo = ammo - 1
				localplayer.PlayerGui.main.Ammo.TextLabel.Text = tostring(ammo).."|"..tostring(stored)
				--local length = 500
				if math.abs(os.time() - lastfired) > cooldown and spread < 50 then
				spread = spread + 1
				else
				spread = 2
				end
				--localplayer.PlayerGui.main.HipFire:TweenSize(localplayer.PlayerGui.main.HipFire.Size + UDim2.new(spread, spread, spread), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.5, true, function() 	localplayer.PlayerGui.main.HipFire:TweenSize(localplayer.PlayerGui.main.HipFire.Size - UDim2.new(spread, spread, spread), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.5, true) end)
				local unitRay = camera:ScreenPointToRay(position.X+ math.random(1, spread)/10, position.Y + math.random(1, spread)/10 , position.Z + math.random(1, spread)/10)
				game.ReplicatedStorage.FireGun:FireServer(parent, unitRay, firerate, burst, bulletspread, shotgun, camera.CFrame.RightVector)
				if shotgun then
				wait(firegun.Length or 2)
				end
				firinggun = false
			else
			reload()
		end
	end
end

local autofiresetup = function()
	if auto == true then
		coroutine.wrap(function()
			while equipped do
				if firing == true then
					if position ~= nil and reloading == false then
					fire(position)
					end
				end
			wait(firerate)

			end
		end)()
	end
end



ga = game.ReplicatedStorage.GiveAmmo.OnClientEvent:Connect(function(howmuch)
	stored = stored + howmuch
	--localplayer.PlayerGui.main.Ammo.TextLabel.Text = tostring(ammo).."|"..tostring(stored)
	end)
	
	


tool.Equipped:Connect(function()
--holdgun = hum:LoadAnimation(game.ReplicatedStorage["Equip"..GunType])
--firegun = hum:LoadAnimation(game.ReplicatedStorage[GunType.."Fire"])
--reloadgun = hum:LoadAnimation(game.ReplicatedStorage[GunType.."Reload"])
reloadsound = parent.Reload
holdgun.Priority = Enum.AnimationPriority.Movement
firegun.Priority = Enum.AnimationPriority.Movement
reloadgun.Priority = Enum.AnimationPriority.Movement
tool = parent

	holdgun:Play()
	equipped = true
if auto == true then
autofiresetup()
end
	
		uis.MouseIconEnabled = false
		localplayer.PlayerGui.main.HipFire.Visible = true
			localplayer.PlayerGui.main.Ammo.Visible = true

	--lookat()
	
gg = game.ReplicatedStorage.Cutscene.OnClientEvent:Connect(function(bool)
		if bool ~= nil then
		holdgun:Stop()
		firegun:Stop()
		reloadgun:Stop()
			equipped = false
				firing = false
				reloading = false
			uis.MouseIconEnabled = false
			localplayer.PlayerGui.main.Enabled = false
			else
			reloading = false
				firing = false
			equipped = true
			holdgun:Play()
				localplayer.PlayerGui.main.Enabled = true
				autofiresetup()

		end
	end)	
	
mm = uis.InputChanged:Connect(function(i,t)
	if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
		position = i.Position
		localplayer.PlayerGui.main.HipFire.Reticle.Position = UDim2.new(0, i.Position.X- 25, 0 , i.Position.Y - 25)
		localplayer.PlayerGui.main.Ammo.TextLabel.Position = UDim2.new(0, i.Position.X+ 15, 0 , i.Position.Y - 25)
	end
end)

ib = uis.InputBegan:Connect(function(i,t) 
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
	
	position = i.Position
		if auto == true then
		firing = true
	else
		fire(i.Position)
		end
		 
	end
	
	if i.UserInputType == Enum.UserInputType.Touch then
		position = i.Position
		if auto == true then
		firing = true
	else
		fire(i.Position)
		end
	end
	
	if i.UserInputType == Enum.UserInputType.Keyboard then
		if i.KeyCode == Enum.KeyCode.R then
			reload()
		end
		if i.KeyCode == Enum.KeyCode.ButtonY then
			reload()
		end
	end
	
	end)


ie = uis.InputEnded:Connect(function(i,t) 
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		--if auto == true then
		firing = false
		--end
	end
	
	if i.UserInputType == Enum.UserInputType.Touch then
		--if auto == true then
		firing = false
		--end
	end
	
	
		end)
end)		

tool.Unequipped:Connect(function()
	equipped = false
	firing = false
	localplayer.PlayerGui.main.Ammo.Visible = false
	localplayer.PlayerGui.main.HipFire.Visible = false
	uis.MouseIconEnabled = true
	holdgun:Stop()
	firegun:Stop()
	reloadgun:Stop()
	ib:Disconnect()
	mm:Disconnect()
	ie:Disconnect()
	gg:Disconnect()
	--ga:Disconnect()
end)


end

return initGun
