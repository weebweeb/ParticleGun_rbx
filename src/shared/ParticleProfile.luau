


local ParticleProfileType = {
	Blood = "Blood",
	Sparks = "Sparks",
	Bullet = "Bullet",
}

local ParticleProfile = {}
ParticleProfile.ParticleProfileType = ParticleProfileType
ParticleProfile.__index = ParticleProfile

local Presets = {}

Presets[ParticleProfileType.Blood] = function()
	return {
		PrimaryParticle = {
			RotSpeed = NumberRange.new(2),
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(53/85, 2/51, 2/51)),
				ColorSequenceKeypoint.new(1, Color3.new(37/85, 2/85, 2/85)),
			}),
			Rate = 100,
			VelocitySpread = 1,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.5, 0),
				NumberSequenceKeypoint.new(1, 0.5, 0),
			}),
			Lifetime = NumberRange.new(1),
			Speed = NumberRange.new(1),
			Texture = "http://www.roblox.com/asset/?id=87773150",
			SpreadAngle = Vector2.new(1, 100),
			Size = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.9, 0),
				NumberSequenceKeypoint.new(1, 0.9, 0),
			}),
		},
	}
end

Presets[ParticleProfileType.Sparks] = function()
	return {
		PrimaryParticle = {
			Acceleration = Vector3.new(0, -22, 0),
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(1, 40/51, 0)),
				ColorSequenceKeypoint.new(1, Color3.new(1, 1, 52/255)),
			}),
			ZOffset = 2,
			VelocitySpread = 30,
			Texture = "http://www.roblox.com/asset/?id=134531274",
			Lifetime = NumberRange.new(1.5, 3),
			Speed = NumberRange.new(10, 17),
			LightEmission = 3,
			Rate = 5,
			SpreadAngle = Vector2.new(30, 30),
			Size = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.1875, 0.125),
				NumberSequenceKeypoint.new(1, 0, 0),
			}),
		},
	}
end

Presets[ParticleProfileType.Bullet] = function()
	return {
		PrimaryParticle = {
			Enabled = false,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(1, 83/85, 52/255)),
				ColorSequenceKeypoint.new(1, Color3.new(1, 83/85, 52/255)),
			}),
			Rate = 10,
			VelocitySpread = 1,
			EmissionDirection = Enum.NormalId.Bottom,
			Texture = "rbxassetid://3077044894",
			Name = "Bullet",
			Lifetime = NumberRange.new(500),
			Speed = NumberRange.new(1),
			LightEmission = 1,
			SpreadAngle = Vector2.new(1, 2),
			Size = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.25, 0),
				NumberSequenceKeypoint.new(1, 0.25, 0),
			}),
		},

		SecondaryParticle = {
			Enabled = false,
			RotSpeed = NumberRange.new(90),
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(1, 1, 178/255)),
				ColorSequenceKeypoint.new(1, Color3.new(1, 1, 178/255)),
			}),
			LockedToPart = true,
			Rate = 40,
			VelocitySpread = 50,
			EmissionDirection = Enum.NormalId.Right,
			Texture = "rbxassetid://875750999",
			LightEmission = 1,
			Lifetime = NumberRange.new(0.8),
			Speed = NumberRange.new(0),
			Rotation = NumberRange.new(90),
			SpreadAngle = Vector2.new(50, 50),
			Size = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.3, 0),
				NumberSequenceKeypoint.new(1, 0.3, 0),
			}),
		},

		PointLight = {
			Enabled = false,
			Shadows = true,
			Color = Color3.new(1, 146/255, 4/85),
			Brightness = 100,
			Range = 3,
		},

		Sound = {
			ricochet = {"rbxassetid://4635371125", "rbxassetid://4635372723", "rbxassetid://4635372161"},
			impact = {"rbxassetid://2640195272", "rbxassetid://2640195272"},
			fire = "rbxassetid://3449328271",
			reload = "rbxassetid://4648872031",
		},

		Damage = 10,

		LocalSettings = {
			Tool = nil,
			Auto = false,
			MaxAmmo = 20,
			Ammo = 20,
			Stored = math.huge,
			FireRate = 0.15,
			CoolDown = 1,
			MaxSpread = 50,
			Burst = 1,
			BulletSpread = math.random(1,3),
			Shotgun = false,
			Particle = "Bullet",
			Recoil = 1.5,
			ReticleImage = "rbxassetid://4766006616",
			Distance = 2000,
			LastFired = os.clock(),
			Animations = {
				Equip = "rbxassetid://4752476241",
				Fire = "rbxassetid://4752573333",
				Reload = "rbxassetid://4752479167",
			},
		},
	}
end

-- Constructor
function ParticleProfile.new(presetType)
	local factory = Presets[presetType]
	if not factory then
		error("Invalid ParticleProfileType: " .. tostring(presetType))
	end

	local self = setmetatable({}, ParticleProfile)
	self = factory()
	return self
end



local function applyEmitterToParticle(targetTable, emitter: ParticleEmitter)
	targetTable.Color = emitter.Color
	targetTable.LightEmission = emitter.LightEmission
	targetTable.Lifetime = emitter.Lifetime
	targetTable.Rate = emitter.Rate
	targetTable.RotSpeed = emitter.RotSpeed
	targetTable.Size = emitter.Size
	targetTable.Speed = emitter.Speed
	targetTable.SpreadAngle = emitter.SpreadAngle
	targetTable.Texture = emitter.Texture
	targetTable.Transparency = emitter.Transparency
	targetTable.VelocitySpread = emitter.VelocitySpread
	targetTable.EmissionDirection = emitter.EmissionDirection
	targetTable.ZOffset = emitter.ZOffset
	targetTable.Acceleration = emitter.Acceleration
	targetTable.Enabled = emitter.Enabled
	targetTable.Name = emitter.Name
end

-- create a new ParticleProfile instance from one or more ParticleEmitter instances, and adds it to the presets
function ParticleProfile.fromEmitter(Name: string, primaryEmitter: ParticleEmitter?, secondaryEmitter: ParticleEmitter?)
	if Presets[ParticleProfileType[Name]] == nil and primaryEmitter and secondaryEmitter then
		ParticleProfileType[Name] = Name
		Presets[ParticleProfileType[Name]] = function(Name, primaryEmitter, secondaryEmitter)
			return { 
				PrimaryParticle = {
					Enabled = false,
					Color = primaryEmitter.Color or ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.new(1, 83/85, 52/255)),
						ColorSequenceKeypoint.new(1, Color3.new(1, 83/85, 52/255)),
					}),
					Rate = primaryEmitter.Rate or 10,
					VelocitySpread = primaryEmitter.VelocitySpread or 1,
					EmissionDirection = primaryEmitter.EmissionDirection or Enum.NormalId.Bottom,
					Texture = primaryEmitter.Texture or "rbxassetid://3077044894",
					Name = primaryEmitter.Name or "Bullet",
					Lifetime = primaryEmitter.Lifetime or NumberRange.new(500),
					Speed = primaryEmitter.Speed or NumberRange.new(1),
					LightEmission = primaryEmitter.LightEmission or 1,
					SpreadAngle = primaryEmitter.SpreadAngle or Vector2.new(1, 2),
					Size = primaryEmitter.Size or NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0.25, 0),
						NumberSequenceKeypoint.new(1, 0.25, 0),
					}),
				},

				SecondaryParticle = {
					Enabled = false,
					RotSpeed = secondaryEmitter.RotSpeed or NumberRange.new(90),
					Color = secondaryEmitter.Color or ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.new(1, 1, 178/255)),
						ColorSequenceKeypoint.new(1, Color3.new(1, 1, 178/255)),
					}),
					LockedToPart = secondaryEmitter.LockedToPart or true,
					Rate = secondaryEmitter.Rate or 40,
					VelocitySpread =  secondaryEmitter.VelocitySpread or 50,
					EmissionDirection = secondaryEmitter.EmissionDirection or Enum.NormalId.Right,
					Texture = secondaryEmitter.Texture or "rbxassetid://875750999",
					LightEmission = secondaryEmitter.Texture or 1,
					Lifetime = secondaryEmitter.Lifetime or NumberRange.new(0.8),
					Speed = secondaryEmitter.Speed or NumberRange.new(0),
					Rotation = secondaryEmitter.Rotation or NumberRange.new(90),
					SpreadAngle = secondaryEmitter.SpreadAngle or Vector2.new(50, 50),
					Size = secondaryEmitter.Size or NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0.3, 0),
						NumberSequenceKeypoint.new(1, 0.3, 0),
					}),
				},

				PointLight = {
					Enabled = false,
					Shadows = true,
					Color = Color3.new(1, 146/255, 4/85),
					Brightness = 100,
					Range = 3,
				},

				Sound = {
					ricochet = {"rbxassetid://4635371125", "rbxassetid://4635372723", "rbxassetid://4635372161"},
					impact = {"rbxassetid://2640195272", "rbxassetid://2640195272"},
					fire = "rbxassetid://3449328271",
					reload = "rbxassetid://4648872031",
				},

				Damage = 10,

				LocalSettings = {
					Tool = nil,
					Auto = false,
					MaxAmmo = 20,
					Ammo = 20,
					Stored = math.huge,
					FireRate = 0.15,
					CoolDown = 1,
					MaxSpread = 50,
					Burst = 1,
					BulletSpread = math.random(1,3),
					Shotgun = false,
					Particle = "Bullet",
					Recoil = 1.5,
					ReticleImage = "rbxassetid://4766006616",
					Distance = 2000,
					LastFired = os.clock(),
					Animations = {
						Equip = "rbxassetid://4752476241",
						Fire = "rbxassetid://4752573333",
						Reload = "rbxassetid://4752479167",
					},
				},
			}
			
			
		end
		else return Presets[ParticleProfileType.Bullet]()
	end
	return Presets[ParticleProfileType[Name]](Name, primaryEmitter, secondaryEmitter)
end

return ParticleProfile

