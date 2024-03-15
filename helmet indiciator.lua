local Camera = workspace.CurrentCamera
local DrawingAPI = {}
local function GetHead(Model)
    return Model:FindFirstChild("Head")
end
local function CheckSteelHelmet(Model)
    local Armor = Model:FindFirstChild("Armor")
    return Armor and Armor:FindFirstChild("SteelHelmet")
end
for _, Model in pairs(workspace:GetChildren()) do
    if Model:IsA("Model") and Model ~= game.Players.LocalPlayer.Character then
        local Head = GetHead(Model)
        if Head then
            DrawingAPI[Model] = Drawing.new("Text")
            DrawingAPI[Model].Visible = false
            DrawingAPI[Model].Size = 27
            DrawingAPI[Model].Center = true
            DrawingAPI[Model].Outline = true
        end
    end
end
workspace.ChildAdded:Connect(function(Model)
    if Model:IsA("Model") and Model ~= game.Players.LocalPlayer.Character then
        local Head = GetHead(Model)
        if Head then
            DrawingAPI[Model] = Drawing.new("Text")
            DrawingAPI[Model].Visible = false
            DrawingAPI[Model].Size = 20
            DrawingAPI[Model].Center = true
            DrawingAPI[Model].Outline = true
        end
    end
end)
workspace.ChildRemoved:Connect(function(Model)
    if DrawingAPI[Model] then
        DrawingAPI[Model]:Remove()
        DrawingAPI[Model] = nil
    end
end)
game:GetService("RunService").RenderStepped:Connect(function()
    for Model, Text in pairs(DrawingAPI) do
        local Head = GetHead(Model)
        if Head then
            local ScreenPosition, OnScreen = Camera:WorldToScreenPoint(Head.Position)
            if OnScreen then
                Text.Visible = true
                Text.Position = Vector2.new(ScreenPosition.X, ScreenPosition.Y)
                Text.Text = CheckSteelHelmet(Model) and "OP" or "[ ]"
                Text.Color = Color3.new(1, 1, 1)
            else
                Text.Visible = false
            end
        end
    end
end)
