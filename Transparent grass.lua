local UserInputService = game:GetService("UserInputService")
local Toggles = { Leaves = { Value = true }, Grass = { Value = true } }
local Functions = {}
local Misc = { Settings = { LeavesTrans = 0.4 } }

-- Function to toggle leaves transparency
function Functions:ToggleLeaves(transparency)
    -- Your code to change leaves transparency goes here
    print("Leaves transparency set to:", transparency)
end

-- Function to handle the Leaves toggle change
local function LeavesToggleChanged(value)
    if value == true then
        Functions:ToggleLeaves(0.4)
        Misc.Settings.LeavesTrans = 0.4
    else
        Functions:ToggleLeaves(1)
        Misc.Settings.LeavesTrans = 1
    end
end

-- Function to handle the Grass toggle change
local function GrassToggleChanged(value)
    -- Assuming sethiddenproperty is a valid function
    sethiddenproperty(game:GetService("Workspace").Terrain, "Decoration", value)
end

-- Function to bind to the 'F' key
local function OnKeyPress(input)
    if input.KeyCode == Enum.KeyCode.U then
        Toggles.Leaves.Value = not Toggles.Leaves.Value
        LeavesToggleChanged(Toggles.Leaves.Value)
        Toggles.Grass.Value = not Toggles.Grass.Value
        GrassToggleChanged(Toggles.Grass.Value)
    end
end

-- Connect the key press event
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent then
        OnKeyPress(input)
    end
end)

-- Add more functionality as needed
