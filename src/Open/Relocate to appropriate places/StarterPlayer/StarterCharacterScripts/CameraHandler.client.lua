




local Config = { 
	sensitivity = 1,
	snap = math.rad(85),
	offset = Vector3.new(2, 2, 10)
}

local moveX, moveY = 0, 0

 moving = false



local Character = script.Parent
local Root = Character:WaitForChild("HumanoidRootPart")

local Camera = game.Workspace.CurrentCamera




function focus()
	game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.LockCenter 
end


function mouseMove(name, state, inputObject)
	moveX = moveX + (-inputObject.Delta.x*Config.sensitivity/100) 
	moveY = moveY + (-inputObject.Delta.y*Config.sensitivity/100)
	
	moveY = math.clamp(moveY, -Config.snap, Config.snap) 
end

function moveBetweenPoint(A,B,Frames)
moving = true
local Cam = game.Workspace.CurrentCamera
local A2, B2 = A*CFrame.new(0,0,-5), B*CFrame.new(0,0,-5)
local X, Y, Z =  -(A.p.X-B.p.X)/Frames, -(A.p.Y-B.p.Y)/Frames, -(A.p.Z-B.p.Z)/Frames
local X2, Y2, Z2 =  -(A2.p.X-B2.p.X)/Frames, -(A2.p.Y-B2.p.Y)/Frames, -(A2.p.Z-B2.p.Z)/Frames
for i = 0, Frames do
local AFram, BFram = A+Vector3.new(X*i,Y*i,Z*i), A2+Vector3.new(X2*i,Y2*i,Z2*i)
Cam.CoordinateFrame = CFrame.new(AFram.p,BFram.p)
wait()
	end
moving = false
end



game:GetService("UserInputService").WindowFocused:Connect(function() 
	focus()
end)


game:GetService("ContextActionService"):BindActionToInputTypes("MouseMove", mouseMove, false, Enum.UserInputType.MouseMovement) 




Camera.CameraType = "Scriptable"

focus() 




wait(0.3)
game:GetService("RunService").RenderStepped:Connect(function() 
	--wait()
	if script.CustomCamera.Value == true then
		if moving == false then
			moveBetweenPoint(Camera.CFrame, script.CustomCFrame.Value, 30)
		end
	Camera.CFrame = CFrame.new(Camera.CFrame.Position, Character.LeftLowerArm.Position + (Character.LeftLowerArm.CFrame.lookVector * 2)) * CFrame.new(script.Parent.LocalFX.CamShake.Value) 

	else
	Camera.CFrame = CFrame.new(Root.Position) * CFrame.Angles(script.Parent.LocalFX.CamRecoil.Value.X, script.Parent.LocalFX.CamRecoil.Value.Y, 0) * CFrame.Angles(0, moveX, 0) * CFrame.Angles(moveY, 0, 0)
	Camera.CFrame = Camera.CFrame * CFrame.new(Config.offset + script.Parent.LocalFX.CamShake.Value) 
	
	
	local clipCorrection = 2 
	
	local rayStart = Root.Position + Vector3.new(0, Config.offset.Y, 0) 
	local rayEnd = Camera.CFrame * CFrame.new(0, 0, clipCorrection).p 
	
	local ray = Ray.new(rayStart, rayEnd - rayStart) 
	local part, position = workspace:FindPartOnRayWithIgnoreList(ray, Character:GetChildren()) 
	
	if (part) and part.CanCollide == true then 
		Camera.CFrame = CFrame.new(position) * (Camera.CFrame - Camera.CFrame.p) * CFrame.new(script.Parent.LocalFX.CamRecoil.Value.X, script.Parent.LocalFX.CamRecoil.Value.Y, -clipCorrection) 
		end
		end
end)

