-- Function to disable grass rendering
local function DisableGrassRendering()
    -- Assuming sethiddenproperty is a valid function
    sethiddenproperty(game:GetService("Workspace").Terrain, "Decoration", false)
end

-- Call the DisableGrassRendering function when needed, such as when the game starts
DisableGrassRendering()
