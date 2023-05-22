Weld = function(a, b)
local weld = Instance.new("ManualWeld")
    weld.Part0 = a
    weld.Part1 = b
    weld.C0 = CFrame.new()
    weld.C1 = b.CFrame:inverse() * a.CFrame
    weld.Parent = a
    return weld;
end 

for i , v in pairs(script.Parent:GetChildren()) do
	if v.Name ~= "Handle" and v:IsA("BasePart") then
		Weld(v, script.Parent["Handle"])
	end
end
