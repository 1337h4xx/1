local uis = game:GetService("UserInputService")
-- u can change Enum.KeyCode.V to the key u want for example if u want it to be B u change it to Enum.KeyCode.B

uis.InputBegan:Connect(function(a)
    if a.KeyCode == Enum.KeyCode.Q then
        workspace.CurrentCamera.FieldOfView = 17
    end
end)

uis.InputEnded:Connect(function(b)
    if b.KeyCode == Enum.KeyCode.Q then
        workspace.CurrentCamera.FieldOfView = 70
    end
end)
