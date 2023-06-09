wait(1)
math.randomseed(tick())
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local character = workspace:WaitForChild(game.Players.LocalPlayer.Name)
local humanoid = character:WaitForChild("Humanoid")
local nextFire = 0
local shaking = script.Shaking
local recoil = script.Recoil
local recoilservice = require(game.ReplicatedStorage.Assets.Modules.Recoil)
local shakemin = 0
local shakemax = 200

recoilservice.init()
recoilservice.set(20,2,1)
recoil.Changed:Connect(function()
	if recoil.Value == true then
		recoil.Value = false
		recoilservice.fire()
	end
	
end)




runService.RenderStepped:Connect(function()
	if shaking.Value == true then
	if elapsedTime() > nextFire then
		nextFire = elapsedTime() + shakeRate
		script.CamShake.Value = Vector3.new(math.random(shakemin, shakemax)/1000, math.random(shakemin, shakemax)/1000, math.random(shakemin, shakemax)/1000)
		end
	else
	script.CamShake.Value = Vector3.new(0,0,0)
	end
end)

local function OnRenderStep()
    local delta = userInputService:GetMouseDelta()
--game.Lighting.Bloom.Intensity = 0.5 + delta.magnitude/500
end

 
runService:BindToRenderStep("MeasureMouseMovement", Enum.RenderPriority.Input.Value, OnRenderStep)