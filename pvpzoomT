local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local zooming = false
local normalFOV = Camera.FieldOfView
local zoomFOV = 30 -- Adjust this value for your desired zoom level

-- Function to toggle zoom
local function toggleZoom(input, gameProcessed)
if input.KeyCode == Enum.KeyCode.T then
zooming = not zooming
if zooming then
Camera.FieldOfView = zoomFOV
else
Camera.FieldOfView = normalFOV
end
end
end

-- Connect the function to key press
UserInputService.InputBegan:Connect(function(input, gameProcessed)
toggleZoom(input, gameProcessed)
end)

-- Ensure zoom is reset if the script stops
game:BindToClose(function()
Camera.FieldOfView = normalFOV
end)

-- Also reset zoom on player character respawn
game.Players.LocalPlayer.CharacterAdded:Connect(function()
Camera.FieldOfView = normalFOV
end)
