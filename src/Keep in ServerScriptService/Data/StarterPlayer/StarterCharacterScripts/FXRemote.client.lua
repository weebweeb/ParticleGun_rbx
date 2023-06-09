player = game.Players.LocalPlayer

game.ReplicatedStorage.PlaySound.OnClientEvent:Connect(function(what, speed)
	local sound = player.PlayerGui.LocalSounds:FindFirstChild(what)
	if not sound then
		sound = Instance.new("Sound")
				sound.PlaybackSpeed = speed or 1

		sound.SoundId = "rbxassetid://"..tostring(what)
		sound.PlayOnRemove = true
		sound.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
			sound:Destroy()
	else
				sound.PlaybackSpeed = speed or 1
		sound:Play()
	end
end)

game.ReplicatedStorage.ShakeScreen.OnClientEvent:Connect(function(howlong)
	game.Players.LocalPlayer.Character.LocalFX.Shaking.Value = true
	wait(howlong)
	game.Players.LocalPlayer.Character.LocalFX.Shaking.Value = false
end)

game.ReplicatedStorage.GreyOut.OnClientEvent:Connect(function(bool)
	if bool == true then
		game.Lighting.ColorCorrection.Saturation = -1
	else
		game.Lighting.ColorCorrection.Saturation = 0
	end
end)