function Unpack(v, check)
	for i_, _ in pairs(v:GetChildren()) do
		pcall(function()
			if check[_.Name] then Unpack(_, check) end
		end)
		pcall(function()
			if check[v.Name] then
				if _:IsA("Folder") and check[v.Name]:FindFirstChild(_.Name) then
					Unpack(_, check[v.Name])
				else
					_.Parent = check[v.Name]
					if _.Enabled then _.Enabled = true end
				end
			end
		end)
	end
end


Unpack(script.Parent, game)
