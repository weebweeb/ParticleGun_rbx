local Module = {}

PlayerTracker = {}

ParticleEffects = {
	["Blood"] = {
		PrimaryParticle = {
			RotSpeed = NumberRange.new(2);
			Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(53/85,2/51,2/51)),ColorSequenceKeypoint.new(1,Color3.new(37/85,2/85,2/85))});
			Rate = 100;
			VelocitySpread = 1;
			Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.5,0),NumberSequenceKeypoint.new(1,0.5,0)});
			Lifetime = NumberRange.new(1);
			Speed = NumberRange.new(1);
			Texture = "http://www.roblox.com/asset/?id=87773150";
			SpreadAngle = Vector2.new(1,100);
			Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0.8999999761581421,0),NumberSequenceKeypoint.new(1,0.8999999761581421,0)});
		}
	},
	["Sparks"] = {
		PrimaryParticle = {
			Acceleration = Vector3.new(0,-22,0);
			Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,40/51,0)),ColorSequenceKeypoint.new(1,Color3.new(1,1,52/255))});
			ZOffset = 2;
			VelocitySpread = 30;
			Texture = "http://www.roblox.com/asset/?id=134531274";
			Lifetime = NumberRange.new(1.5,3);
			Speed = NumberRange.new(10,17);
			LightEmission = 3;
			Rate = 5;
			SpreadAngle = Vector2.new(30,30);
			Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0.18750011920928955,0.12499988079071045),NumberSequenceKeypoint.new(1,0,0)});
		}	
	},
	["Bullet"] = {
		PrimaryParticle = {
		Enabled = false;
		Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,83/85,52/255)),ColorSequenceKeypoint.new(1,Color3.new(1,83/85,52/255))});
		Rate = 10;
		VelocitySpread = 1;
		EmissionDirection = Enum.NormalId.Bottom;
		Texture = "rbxassetid://3077044894";
		Name = "Bullet";
		Lifetime = NumberRange.new(500);
		Speed = NumberRange.new(1);
		LightEmission = 1;
		SpreadAngle = Vector2.new(1,2);
			Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0.25,0),NumberSequenceKeypoint.new(1,0.25,0)});
		},
		SecondaryParticle = {
			Enabled = false;
			RotSpeed = NumberRange.new(90);
			Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,178/255)),ColorSequenceKeypoint.new(1,Color3.new(1,1,178/255))});
			LockedToPart = true;
			Rate = 40;
			VelocitySpread = 50;
			EmissionDirection = Enum.NormalId.Right;
			Texture = "rbxassetid://875750999";
			LightEmission = 1;
			Lifetime = NumberRange.new(0.800000011920929);
			Speed = NumberRange.new(0);
			Rotation = NumberRange.new(90);
			SpreadAngle = Vector2.new(50,50);
			Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0.30000001192092896,0),NumberSequenceKeypoint.new(1,0.30000001192092896,0)});
		},
		PointLight = {
			Enabled = false;
			Shadows = true;
			Color = Color3.new(1,146/255,4/85);
			Brightness = 100;
			Range = 3;
		},
		Sound = {
			ricochet = {"rbxassetid://4635371125","rbxassetid://4635372723","rbxassetid://4635372161"},
			impact = {"rbxassetid://2640195272", "rbxassetid://2640195272"},
			fire = "rbxassetid://3449328271",
			reload = "rbxassetid://4648872031"
		},
		Damage = 10,
		LocalSettings = {
			["Tool"] = nil,
			["Auto"] = false,
			["MaxAmmo"] = 20,
			["Ammo"] = 20,
			["Stored"] = math.huge,
			["FireRate"] = 0.15,
			["CoolDown"] = 1,
			["MaxSpread"] = 50,
			["Burst"] = 1,
			["BulletSpread"] = math.random(1,3),
			["Shotgun"] = false,
			["Particle"] = "Bullet",
			["Recoil"] = 1.5,
			["ReticleImage"] = "rbxassetid://4766006616",
			["Distance"] = 2000,
			["LastFired"] = os.clock(),
			["Animations"] = {
				Equip = "rbxassetid://4752476241",
				Fire = "rbxassetid://4752573333",
				Reload = "rbxassetid://4752479167",
			}
		}
	}
		
}

local function RecursiveClone(obj)
	if type(obj) ~= 'table' then return obj end
	local res = {}
	for k, v in pairs(obj) do res[RecursiveClone(k)] = RecursiveClone(v) end
	return res
end

function Module:CreateParticleProfile(name)
	local NewParticle = RecursiveClone(ParticleEffects.Bullet) -- create a functional copy of our base instance
	NewParticle.LocalSettings.Particle = name
	ParticleEffects[name] = NewParticle
	return ParticleEffects[name]
end

function Module:InitServer()
	local FireGun = Instance.new("RemoteEvent", game.ReplicatedStorage); FireGun.Name = "FireGun"
	local GiveAmmo = Instance.new("RemoteEvent", game.ReplicatedStorage); GiveAmmo.Name = "GiveAmmo"
	local LogPlayer =  Instance.new("RemoteEvent", game.ReplicatedStorage); LogPlayer.Name = "LogPlayer"
	local RequestParticleInfo = Instance.new("RemoteFunction", game.ReplicatedStorage); RequestParticleInfo.Name = "RequestParticleInfo"
	
	local function TempTag(ValueType, Where, Name, Value) 
		local tag
		local s, f = pcall(function()
			if Where:FindFirstChild(Name) then
				Where[Name]:Destroy()
			end
			tag = Instance.new(ValueType, Where)
			local success, fail = pcall(function() if not tag.Value then return end end)
			if not success then warn("ValueType is not valid"); end
			tag.Name = Name
			tag.Value = Value
		end)
		if not s then error(f)
			return nil
		else
			return tag
		end
	end
	
	local function MakeParticles(what, where, Dist)
		local FX = {}
		Dist = Dist or NumberRange.new(50,50)
		for i = 1, 6 , 1 do
			local ParticleGen = Instance.new("ParticleEmitter",where)
			ParticleGen.Enabled = false
			for i, v in pairs(ParticleEffects[what].PrimaryParticle) do
				ParticleGen[i] = v
			end
			ParticleGen.Name = "Bullet"
			table.insert(FX, ParticleGen)
		end
		if ParticleEffects[what].SecondaryParticle then
			local SecondParticleGen = Instance.new("ParticleEmitter",where)
			SecondParticleGen.Enabled = false
			for i, v in pairs(ParticleEffects[what].SecondaryParticle) do
				SecondParticleGen[i] = v
			end
			table.insert(FX, SecondParticleGen)
		end
		if ParticleEffects[what].PointLight then
			local LightGen = Instance.new("PointLight",where)
			LightGen.Enabled = false
			for i, v in pairs(ParticleEffects[what].PointLight) do
				LightGen[i] = v
			end
			table.insert(FX,LightGen)
		end
		return {Particles = FX, Remove = function() for i,v in pairs(FX) do game.Debris:AddItem(v, Dist.Min*0.1) end end}
	end

	local function MakeSound(id , Where, volume, PlayBackSpeed)
		local s = Instance.new("Sound", Where)
		s.SoundId = id
		--s.PlayOnRemove = true
		s.Volume = volume or 0.5
		s.PlaybackSpeed = PlayBackSpeed or math.random(95, 105)/100
		s:Play()
		task.delay(s.TimeLength*s.PlaybackSpeed, function() s:Destroy() end) 
		--s:Destroy()
	end

	local function MakeSparks(Where, Particle)
		local SoundReference = ParticleEffects[Particle].Sound
		local Part = Instance.new("Part", workspace); Part.Transparency = 1; Part.CanCollide = false; Part.Anchored = true
		Part.Position = Where
		local Main = MakeParticles("Sparks", Part)
		local Particles = Main.Particles
		MakeSound(SoundReference.ricochet[math.random(1,#SoundReference.ricochet)], Part)
		for i, v in pairs(Particles) do
			v.Enabled = true
		end
		delay(0.07, function() Main.Remove(); game.Debris:AddItem(Part, 0.3) end)

	end

	local function ChangeRate(Rate, Name, Where)
		for i, v in pairs(Where:GetChildren()) do
			if string.find(v.Name, Name) then
				v.Rate = Rate

			end
		end
	end

	local function MakeBlood(Where, Particle)
		local SoundReference = ParticleEffects[Particle].Sound
		local Part = Instance.new("Part", workspace); Part.Transparency = 1; Part.CanCollide = false; Part.Anchored = true
		Part.Position = Where
		local Main = MakeParticles("Blood", Part)
		local Particles = Main.Particles
		--Where = Where - Vector3.new(0,2,3)
		MakeSound(SoundReference.impact[math.random(1,#SoundReference.impact)], Part, 0.2)
		for i, v in pairs(Particles) do
			v.Enabled = true
		end
		wait(0.1)
		Main.Remove()
		game.Debris:AddItem(Part, 0.5)
		

	end
	local ti = -5
	local function Cone(num, cone, shotty)
		if shotty == nil or shotty == false then return 0 end
		if ti >= num + cone/10 then ti = 0 - cone/10 end
		ti = ti + 0.1
		num = num + ti
		return num
	end

	local function BulletParticleFX(Where, ray, Dist, Shotgun, Rate, What, GraphicSetting)
		
		local Particles = MakeParticles(What, Where, Dist)
		local FX = Particles.Particles
		
		for i, v in pairs(FX) do
			if v.Name == "Bullet" then
				v.Acceleration = ray.Direction
				v.Lifetime = Dist
				if GraphicSetting > 0 then
					v.Rate = v.Rate + (v.Rate-(GraphicSetting+1))
				else
					v.Rate = v.Rate + 7
				end
			end
			v.Enabled = true
		end

		if Shotgun ~= true then
			if Rate ~= nil then
				wait(Rate - 0.01)
			else
				wait(0.15)
			end
		else wait(0.05)
		end
		
		for i, v in pairs(FX) do
			v.Enabled = false
		end
		Particles.Remove()
	end



	local function GunMain(Player, Where, UnitRay, Right, Particle, GraphicSetting, AmmoCount)
		local Tracker = PlayerTracker[Player.UserId][Where.Name]
		local SoundReference = ParticleEffects[Tracker.Particle].Sound

		--print(os.difftime(os.time(), Tracker.LastFired))
		if UnitRay == nil then MakeSound(SoundReference.reload, Where, 0.2, (math.random(97,102)/100)); Tracker.Ammo = Tracker.MaxAmmo return end
		ti = 0 - (Tracker.BulletSpread + 0.3)
		Tracker.Ammo = Tracker.Ammo - Tracker.Burst
		if Tracker.Ammo > AmmoCount or os.clock() - Tracker.LastFired < Tracker.FireRate -0.1 then error("ParticleGun: Sanity check didn't check out") end
		Tracker.LastFired = os.clock()
		for i = 1, Tracker.Burst do
			coroutine.wrap(function()
				
				if Tracker.FireRate > 0 and i > 1 and Tracker.Shotgun == false and Tracker.Burst > 1 then
					wait(Tracker.FireRate*(i-1))
				end
				MakeSound(SoundReference.fire, Where, 0.2, (math.random(97,102)/100))


				local ray = Ray.new(Where.Parent.Head.Position, (UnitRay.Direction  + (Right* Cone(2, Tracker.BulletSpread, Tracker.Shotgun))) * Tracker.Distance)
				local findparts, hitposition = workspace:FindPartOnRayWithIgnoreList(ray, Player.Character:GetDescendants())

				local distt = (Player.Character.HumanoidRootPart.Position - hitposition).Magnitude
				local Dist = NumberRange.new(distt)

				if Tracker.Shotgun then
					ChangeRate(Tracker.FireRate * 100, "Bullet", Where.BarrelParticle)
				else
					ChangeRate(2/Tracker.FireRate, "Bullet", Where.BarrelParticle)
				end

				BulletParticleFX(Where.BarrelParticle, ray, Dist,nil, nil, Particle, GraphicSetting)

				if hitposition then
					if findparts and findparts.Parent:FindFirstChild("Humanoid") or findparts and findparts.Parent.Parent:FindFirstChild("Humanoid") then
						MakeBlood(hitposition, Particle)
					else
						MakeSparks(hitposition, Particle)
					end
				end

				if findparts then

					if findparts.Parent:FindFirstChild("Humanoid") then
						TempTag("ObjectValue", findparts.Parent.Humanoid, "creator", Player.Character)
						findparts.Parent.Humanoid:TakeDamage(ParticleEffects[Tracker.Particle].Damage)
					else
						if findparts.Parent.Parent:FindFirstChild("Humanoid") then -- lazy solution
							TempTag("ObjectValue", findparts.Parent.Parent.Humanoid, "creator", Player.Character)
							findparts.Parent.Parent.Humanoid:TakeDamage(ParticleEffects[Tracker.Particle].Damage)

						end
					end
				end

			end)()
		end
	
	end
	
	LogPlayer.OnServerEvent:Connect(function(Player,ParticleInstance, Name)
		if PlayerTracker[Player.UserId] == nil then
			PlayerTracker[Player.UserId] = {}
		end
		PlayerTracker[Player.UserId][Name] = RecursiveClone(ParticleEffects[ParticleInstance].LocalSettings)
	end)
	
	local RequestParticleInfoF = function(Player, Particle)
		if ParticleEffects[Particle] then return ParticleEffects[Particle].LocalSettings end
	end
	
	RequestParticleInfo.OnServerInvoke = RequestParticleInfoF
	
	game:GetService("Players").PlayerRemoving:Connect(function(Plyr) PlayerTracker[Plyr.UserId] = nil end)

	FireGun.OnServerEvent:Connect(function(Player, Where, UnitRay, Right, fireparticle, graphicsetting, SAmmo)
		GunMain(Player, Where, UnitRay, Right, fireparticle, graphicsetting, SAmmo)
	end)

end

function Module:initClient(Particle, Tool)
	local Recoiler = {}
	local LocalPlayer = game.Players.LocalPlayer
	local Setting = game.ReplicatedStorage.RequestParticleInfo:InvokeServer(Particle)
	Setting.Tool = Tool
	
	local function CreateAnimation(id, Where)
		local Animation = Instance.new("Animation", Where)
		if id == nil then error("ParticleGun: Animations cannot be nil!") end
		Animation.AnimationId = id
		return Animation
	end
	local function CreateSound(id, Where)
		local Sound = Instance.new("Sound", Where)
		if id == nil then error("ParticleGun: Sounds cannot be nil!") end
		Sound.SoundId = id
		return Sound
	end
	
	
	local function RecoilHandler()
		local Camera = game.Workspace.CurrentCamera
		local RunService = game:GetService("RunService")
		local Theta = 0
		local dTheta_dt = 0
		local d2Theta_dt2 = 0
		local Phi = 0
		local dPhi_dt = 0
		local d2Phi_dt2 = 0
		local returnAgg
		local recoil
		local thetaMax
		local dampConstant
		local timeStepLength = 0.017
		local timeLeft = 0
		local renderSteppedConnection

		local function Step()
			local dt = os.clock() - t
			t = os.clock()

			local timeToNextStep = timeLeft + dt
			local timeSteps = math.floor(timeToNextStep / timeStepLength)
			timeLeft = timeToNextStep - timeSteps * timeStepLength

			local totaldPhi = 0
			local totaldTheta = 0
			for i = 1, timeSteps do
				local oldAccelPhi = d2Phi_dt2
				local oldVelPhi = dPhi_dt
				d2Phi_dt2 = -returnAgg * Phi - dampConstant * dPhi_dt
				dPhi_dt = dPhi_dt + dt * ((d2Phi_dt2 + oldAccelPhi) / 2)
				local dPhi = dt * ((dPhi_dt + oldVelPhi) / 2)
				totaldPhi = totaldPhi + dPhi
				Phi = Phi + dPhi

				local oldAccelTheta = d2Theta_dt2
				local oldVelTheta = dTheta_dt
				d2Theta_dt2 = -returnAgg * Theta - dampConstant * dTheta_dt
				dTheta_dt = dTheta_dt + dt * ((d2Theta_dt2 + oldAccelTheta) / 2)
				local dTheta = dt * ((dTheta_dt + oldVelTheta) / 2)
				totaldTheta = totaldTheta + dTheta
				Theta = Theta + dTheta
			end
			Camera.CFrame = Camera.CFrame * CFrame.Angles(totaldPhi, totaldTheta, 0)
			--game.Players.LocalPlayer.Character.CameraHandler.CamRecoil.Value = Vector3.new(totaldPhi, totaldTheta, 0)
		end

		Recoiler.Init = function()
			t = os.clock()
			renderSteppedConnection = RunService.RenderStepped:connect(Step)
		end

		Recoiler.Set = function(k, r, thMax)
			returnAgg = k
			recoil = r
			thetaMax = thMax
			dampConstant = 2 * math.sqrt(k)
		end

		Recoiler.Fire = function()
			dPhi_dt = recoil
			dTheta_dt = (math.random() * 2 - 1) * thetaMax
		end

		Recoiler.Deactivate = function()
			renderSteppedConnection:disconnect()

			Phi = 0
			dPhi_dt = 0
			d2Phi_dt2 = 0
			Theta = 0
			dTheta_dt = 0
			d2Theta_dt2 = 0

			timeLeft = 0
		end
	end
	
	local function CreateGUI(Setting)
		local Gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui); Gui.Name = "main"
		local AmmoCounter = Instance.new("Frame", Gui)
		AmmoCounter.Name = "Ammo"
		local Reticle = Instance.new("Frame", Gui)
		Reticle.Name = "HipFire"
		AmmoCounter.Transparency = 1; Reticle.Transparency = 1
		AmmoCounter.Size = UDim2.new(1,0,1,0); Reticle.Size = UDim2.new(1,0,1,0)
		AmmoCounter.Visible = false; Reticle.Visible = false
		local ReticleImage = Instance.new("ImageLabel", Reticle); ReticleImage.Name = "Reticle"
		ReticleImage.Image = Setting.ReticleImage
		ReticleImage.Position = UDim2.new(0.5, 0,0.5, 0)
		ReticleImage.BackgroundTransparency = 1; ReticleImage.Size = UDim2.new(0, 50, 0, 50); ReticleImage.Visible = true;
		local AmmoText = Instance.new("TextLabel", AmmoCounter); AmmoText.Size = UDim2.new(0.096, 0, 0.086, 0);
		AmmoText.Position = UDim2.new(0.522, 0.488); AmmoText.BackgroundTransparency = 1; AmmoText.Visible = true;
		AmmoText.Text = "10|40"; AmmoText.FontSize = Enum.FontSize.Size14; AmmoText.TextScaled = true; AmmoText.TextWrap = true;
		AmmoText.Font = Enum.Font.SourceSans; AmmoText.TextStrokeTransparency = 0.4000000059604645; AmmoText.TextWrapped = true;
		AmmoText.TextColor3 = Color3.new(255,255,255)
		return function() Gui:Destroy() end
	end
	
		local LocalPlayer = game.Players.LocalPlayer
		local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() 
		local Equipped = false
		local GameSettings = UserSettings():GetService("UserGameSettings")
		local Humanoid = Character:WaitForChild("Humanoid")
		local UIS = game:GetService("UserInputService")
		local HoldGunAnimation = Humanoid:LoadAnimation(CreateAnimation(Setting.Animations.Equip, Humanoid.Parent))
		local FireGunAnimation = Humanoid:LoadAnimation(CreateAnimation(Setting.Animations.Fire, Humanoid.Parent))
		local ReloadGunAnimation = Humanoid:LoadAnimation(CreateAnimation(Setting.Animations.Reload, Humanoid.Parent))
		local InputPosition = nil
		local FiringGun = false
		local Mouse = LocalPlayer:GetMouse()
		local Reloading = false
		local Firing = false
		local Camera = workspace.CurrentCamera
		local LastFired = os.clock()
		local Spread = 0
		local InputEnded = nil
		local InputBegan = nil
		local GiveAmmo = nil
		local DisableGui
		game.ReplicatedStorage.LogPlayer:FireServer(Particle, Setting.Tool.Name)		
		RecoilHandler()
		HoldGunAnimation.Priority = Enum.AnimationPriority.Movement
		FireGunAnimation.Priority = Enum.AnimationPriority.Movement
		ReloadGunAnimation.Priority = Enum.AnimationPriority.Movement


		local Reload = function()
			if Setting.Ammo == Setting.MaxAmmo or Reloading then return end
			if Setting.Stored == 0 then return end
			Reloading = true
			Firing = false
			ReloadGunAnimation:Play()
			game.ReplicatedStorage.FireGun:FireServer(Setting.Tool, nil, 0, nil, GameSettings.SavedQualityLevel.Value, Setting.Ammo)

			wait(ReloadGunAnimation.Length or 1)
			FiringGun = false
			Reloading = false
			local oldstored = Setting.Stored
			if Setting.Stored ~= math.huge then
				Setting.Stored = math.max(0, Setting.Stored - (Setting.MaxAmmo-Setting.Ammo))
			end
			if Setting.Stored ~= math.huge then
				if oldstored <= Setting.MaxAmmo then
				Setting.Ammo = oldstored
			else
				Setting.Ammo = Setting.MaxAmmo
			end
			else
			Setting.Ammo = Setting.MaxAmmo

			end
		
			LocalPlayer.PlayerGui.main.Ammo.TextLabel.Text = tostring(Setting.Ammo).."|"..tostring(Setting.Stored)

		end

		local Fire = function()
			if FiringGun == true then return end
			if Reloading == false then
				FiringGun = true
			if Setting.Ammo > 0 then
					if Setting.Recoil > 0 then Recoiler.Fire() end
					FireGunAnimation:Play()
					if Setting.Burst > 1 and not Setting.Shotgun then
						Setting.Ammo = Setting.Ammo - Setting.Burst
					else
						Setting.Ammo = Setting.Ammo - 1
					end
					LocalPlayer.PlayerGui.main.Ammo.TextLabel.Text = tostring(Setting.Ammo).."|"..tostring(Setting.Stored)
					--local length = 500
					if math.abs(os.clock() - LastFired) > Setting.CoolDown and Spread < Setting.MaxSpread then
						Spread = Spread + Setting.BulletSpread
					else
						Spread = 2
					end
					--LocalPlayer.PlayerGui.main.HipFire:TweenSize(LocalPlayer.PlayerGui.main.HipFire.Size + UDim2.new(Spread, Spread, Spread), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.5, true, function() 	LocalPlayer.PlayerGui.main.HipFire:TweenSize(LocalPlayer.PlayerGui.main.HipFire.Size - UDim2.new(Spread, Spread, Spread), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.5, true) end)
					local UnitRay = Camera:ScreenPointToRay((InputPosition.X + 10)+ math.random(1, Spread)/10, (InputPosition.Y +10) + math.random(1, Spread)/10 , InputPosition.Z + math.random(1, Spread)/10)
					game.ReplicatedStorage.FireGun:FireServer(Setting.Tool, UnitRay, Camera.CFrame.RightVector, Setting.Particle, GameSettings.SavedQualityLevel.Value, Setting.Ammo)
					if Setting.Shotgun then
						wait(FireGunAnimation.Length or 2)
					end
					FiringGun = false

				else
					Reload()
				end
			end
		end

		local AutoFireSetup = function()
			if Setting.Auto == true then
				coroutine.wrap(function()
					while Equipped do
						if Firing == true then
							if InputPosition ~= nil and Reloading == false then
								Fire(InputPosition)
							end
						end
						wait(Setting.FireRate)

					end
				end)()
			end
		end



		GiveAmmo = game.ReplicatedStorage.GiveAmmo.OnClientEvent:Connect(function(howmuch)

			Setting.Stored = Setting.Stored + howmuch
			LocalPlayer.PlayerGui.main.Ammo.TextLabel.Text = tostring(Setting.Ammo).."|"..tostring(Setting.Stored)
			--LocalPlayer.PlayerGui.main.Ammo.TextLabel.Text = tostring(Setting.Ammo).."|"..tostring(Setting.Stored)
		end)




		Setting.Tool.Equipped:Connect(function()
		DisableGui = CreateGUI(Setting)
			if Setting.Recoil > 0 then
				Recoiler.Init()
				Recoiler.Set(20,Setting.Recoil,1)
			end
			HoldGunAnimation:Play()
			Equipped = true
			if Setting.Auto == true then
				AutoFireSetup()
			end
			LocalPlayer.PlayerGui.main.Ammo.TextLabel.Text = tostring(Setting.Ammo).."|"..tostring(Setting.Stored)

			UIS.MouseIconEnabled = false
			LocalPlayer.PlayerGui.main.HipFire.Visible = true
			LocalPlayer.PlayerGui.main.Ammo.Visible = true

			--lookat()



			InputChanged = UIS.InputChanged:Connect(function(i,t)
				if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
					InputPosition = i.Position
					LocalPlayer.PlayerGui.main.HipFire.Reticle.Position = UDim2.new(0, i.Position.X- 25, 0 , i.Position.Y - 25)
					LocalPlayer.PlayerGui.main.Ammo.TextLabel.Position = UDim2.new(0, i.Position.X+ 15, 0 , i.Position.Y - 25)
				end
			end)

			InputBegan = UIS.InputBegan:Connect(function(i,t) 
				if i.UserInputType == Enum.UserInputType.MouseButton1 then
					InputPosition = i.Position
					if Setting.Auto == true then
						Firing = true
					else
						Fire(i.Position)
					end
				end

				if i.UserInputType == Enum.UserInputType.Touch then
					InputPosition = i.Position
					if Setting.Auto == true then
						Firing = true
					else
						Fire(i.Position)
					end
				end

				if i.UserInputType == Enum.UserInputType.Keyboard then
					if i.KeyCode == Enum.KeyCode.R then
						Reload()
					end
					if i.KeyCode == Enum.KeyCode.ButtonY then
						Reload()
					end
				end

			end)


			InputEnded = UIS.InputEnded:Connect(function(i,t) 
				if i.UserInputType == Enum.UserInputType.MouseButton1 then
					--if Setting.Auto == true then
					Firing = false
					--end
				end

				if i.UserInputType == Enum.UserInputType.Touch then
					--if Setting.Auto == true then
					Firing = false
					--end
				end


			end)
		end)		

		Setting.Tool.Unequipped:Connect(function()
			
			Equipped = false
			Firing = false
			LocalPlayer.PlayerGui.main.Ammo.Visible = false
			LocalPlayer.PlayerGui.main.HipFire.Visible = false
			UIS.MouseIconEnabled = true
			HoldGunAnimation:Stop()
			FireGunAnimation:Stop()
			ReloadGunAnimation:Stop()
			if Setting.Recoil > 0 then Recoiler.Deactivate() end
			pcall(function()
				InputBegan:Disconnect()
				InputChanged:Disconnect()
				InputEnded:Disconnect()
				GiveAmmo:Disconnect()
			end)
			DisableGui()
		end)

end



return Module
