--
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/Library.lua'))()
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/addons/SaveManager.lua'))()
--

local Window = Library:CreateWindow({
    Title = 'MoonHub (Cracked By Burn Hub)',
    Center = true, 
    AutoShow = true,
})

Library:SetWatermark('MoonHub (Cracked By Burn)')

-- Locales
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
local Mouse = LocalPlayer:GetMouse();
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = workspace.CurrentCamera
local Cameras = game:GetService("Workspace").Camera;
local CurrentCamera = game:GetService("Workspace").CurrentCamera
local worldToViewportPoint = CurrentCamera.worldToViewportPoint
local gmt = getrawmetatable(game)
setreadonly(gmt, false)
local oldindex = gmt.__index

local _Character = getrenv()._G.Character;

local LeavesRemoverOn = false
local HomeRayOn = false
local ZoomOn = false
local AimbotOn = false
local HRTransp = 0.6
local fovcircle = Drawing.new("Circle")
fovcircle.Visible = false
fovcircle.Radius = 120
fovcircle.Color = Color3.fromRGB(255,255,255)
fovcircle.Thickness = 1
fovcircle.Filled = false
fovcircle.Transparency = 1

fovcircle.Position = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2)
--

-- Tables
-- Esp
getgenv().EspSettings = {
    BoxColor = Color3.new(1, 0.568627, 0),
    NameColor = Color3.new(1, 0.568627, 0),
}
--Aim
getgenv()._Aimbot = {
    Enabled = false,
    AimSmooth = 1,
    X_Offset = 0,
    Y_Offset = 0
}

getgenv().ASSettings = {
    AimType = "To Cursor",
    AimDis = 300,
    AimSleepers = false,
    VisibleCheck = false
}
--All Global Settings
local AllSettings = {
    FovNow = 70
}
--

--
local VisualsTab = Window:AddTab('Visuals')
local CombatTab = Window:AddTab('Combat')
local MiscTab = Window:AddTab('Misc')
--

-- GetClosestPlayerToPlayer
function getClosestPlayerToPlayer()
    local closestPlayer = nil;
    local shortestDistance = ASSettings["AimDis"];
	for i, v in pairs(workspace:GetChildren()) do
		if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name then
			if v.Humanoid.Health ~= 0 and v.PrimaryPart ~= nil and v:FindFirstChild("Head") then
				local pos = Cameras.WorldToViewportPoint(Cameras, v.PrimaryPart.Position)
				local magnitude = (_Character.character.Middle.Position - v.PrimaryPart.Position).magnitude
				local fovmagnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude
				
				if magnitude < shortestDistance then
				    if fovmagnitude < 120 then
				        closestPlayer = v
					    shortestDistance = magnitude
				    end
				end
			end
		end
	end
	return closestPlayer
end
--
local Typing = false

local ViewportSize_ = Camera.ViewportSize / 2
local Axis_X, Axis_Y = ViewportSize_.X, ViewportSize_.Y

local HorizontalLine = Drawing.new("Line")
local VerticalLine = Drawing.new("Line")

_G.ToMouse = true

_G.CrosshairVisible = false
_G.CrosshairSize = 10
_G.CrosshairThickness = 1
_G.CrosshairColor = Color3.fromRGB(255, 0, 0)
_G.CrosshairTransparency = 1

_G.DisableKey = Enum.KeyCode.Q

RunService.RenderStepped:Connect(function()
    local Real_Size = _G.CrosshairSize / 2

    HorizontalLine.Color = _G.CrosshairColor
    HorizontalLine.Thickness = _G.CrosshairThickness
    HorizontalLine.Visible = _G.CrosshairVisible
    HorizontalLine.Transparency = _G.CrosshairTransparency
    
    VerticalLine.Color = _G.CrosshairColor
    VerticalLine.Thickness = _G.CrosshairThickness
    VerticalLine.Visible = _G.CrosshairVisible
    VerticalLine.Transparency = _G.CrosshairTransparency
    
    if _G.ToMouse == true then
        HorizontalLine.From = Vector2.new(UserInputService:GetMouseLocation().X - Real_Size, UserInputService:GetMouseLocation().Y)
        HorizontalLine.To = Vector2.new(UserInputService:GetMouseLocation().X + Real_Size, UserInputService:GetMouseLocation().Y)
        
        VerticalLine.From = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y - Real_Size)
        VerticalLine.To = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y + Real_Size)
    elseif _G.ToMouse == false then
        HorizontalLine.From = Vector2.new(Axis_X - Real_Size, Axis_Y)
        HorizontalLine.To = Vector2.new(Axis_X + Real_Size, Axis_Y)
    
        VerticalLine.From = Vector2.new(Axis_X, Axis_Y - Real_Size)
        VerticalLine.To = Vector2.new(Axis_X, Axis_Y + Real_Size)
    end
end)

UserInputService.TextBoxFocused:Connect(function()
    Typing = true
end)

UserInputService.TextBoxFocusReleased:Connect(function()
    Typing = false
end)
--
local CrossHairSector = MiscTab:AddLeftGroupbox('Crosshair')

CrossHairSector:AddToggle('Cht', {
    Text = 'Off/On',
    Default = false,
    Tooltip = 'Off/on crosshair',
})
Toggles.Cht:OnChanged(function(CrosshairVisible)
    _G.CrosshairVisible = CrosshairVisible
end)

CrossHairSector:AddToggle('Chtmt', {
    Text = 'To Mouse',
    Default = false,
    Tooltip = 'Crosshair to mouse',
})
Toggles.Chtmt:OnChanged(function(CrosshairToMouse)
    _G.ToMouse = CrosshairToMouse
end)

CrossHairSector:AddLabel('Color'):AddColorPicker('Chc', {
    Default = Color3.new(1, 0, 0),
    Title = 'Color',
})
Options.Chc:OnChanged(function(CrosshairColor)
    _G.CrosshairColor = CrosshairColor
end)

CrossHairSector:AddSlider('Chs', {
    Text = 'Size',
    Default = 15,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Compact = false,
})
Options.Chs:OnChanged(function(CrosshairSize)
    _G.CrosshairSize = CrosshairSize
end)

CrossHairSector:AddSlider('chtr', {
    Text = 'Transparency',
    Default = 1,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,
})
Options.chtr:OnChanged(function(CrshTrans)
    _G.CrosshairTransparency = CrshTrans
end)

local SkinChangerSector = MiscTab:AddRightGroupbox('Guns Skins')

SkinChangerSector:AddButton('Set Default All', function()
    -- MATERIAL

    -----HMAR
    game:GetService("ReplicatedStorage").HandModels.HMAR.Barrel.Material = Enum.Material.Metal
    game:GetService("ReplicatedStorage").HandModels.HMAR.Body.Material = Enum.Material.Metal
    game:GetService("ReplicatedStorage").HandModels.HMAR.Bolt.Material = Enum.Material.Metal
    game:GetService("ReplicatedStorage").HandModels.HMAR.Stock.Material = Enum.Material.Wood
    game:GetService("ReplicatedStorage").HandModels.HMAR.Grip.Material = Enum.Material.Wood
    game:GetService("ReplicatedStorage").HandModels.HMAR.Mag.Material = Enum.Material.Plastic
    game:GetService("ReplicatedStorage").HandModels.HMAR.Muzzle.Material = Enum.Material.Wood
    game:GetService("ReplicatedStorage").HandModels.HMAR.IronSights.ADS.Material = Enum.Material.Plastic
    game:GetService("ReplicatedStorage").HandModels.HMAR.IronSights.Union.Material = Enum.Material.Metal
    -----PipeSMG
    game:GetService("ReplicatedStorage").HandModels.PipeSMG.IronSights.ADS.Material = Enum.Material.Metal
    game:GetService("ReplicatedStorage").HandModels.PipeSMG.IronSights.Union.Material = Enum.Material.Metal
    game:GetService("ReplicatedStorage").HandModels.PipeSMG.Mag.Material = Enum.Material.Metal
    game:GetService("ReplicatedStorage").HandModels.PipeSMG.Flap.Material = Enum.Material.Metal
    game:GetService("ReplicatedStorage").HandModels.PipeSMG.Muzzle.Material = Enum.Material.Plastic
    game:GetService("ReplicatedStorage").HandModels.PipeSMG.Body.Material = Enum.Material.Metal
    game:GetService("ReplicatedStorage").HandModels.PipeSMG.Bolt.Material = Enum.Material.Metal
    -----USP
    game:GetService("ReplicatedStorage").HandModels.USP.IronSights.ADS.Material = Enum.Material.Metal
    game:GetService("ReplicatedStorage").HandModels.USP.IronSights.Union.Material = Enum.Material.Metal
    game:GetService("ReplicatedStorage").HandModels.USP.Muzzle.Material = Enum.Material.Plastic
    game:GetService("ReplicatedStorage").HandModels.USP.Mag.Material = Enum.Material.Metal
    game:GetService("ReplicatedStorage").HandModels.USP["Meshes/USP_Slide"].Material = Enum.Material.Metal
    game:GetService("ReplicatedStorage").HandModels.USP["Meshes/USP_Body"].Material = Enum.Material.Metal
    -----Pipe
    game:GetService("ReplicatedStorage").HandModels.PipePistol.IronSights.ADS.Material = Enum.Material.Plastic
    game:GetService("ReplicatedStorage").HandModels.PipePistol.IronSights["Meshes/PipePistolSights"].Material = Enum.Material.Metal
    game:GetService("ReplicatedStorage").HandModels.PipePistol.Muzzle.Material = Enum.Material.Plastic
    game:GetService("ReplicatedStorage").HandModels.PipePistol.Mag.Material = Enum.Material.Plastic
    game:GetService("ReplicatedStorage").HandModels.PipePistol["Meshes/PipePistolBody"].Material = Enum.Material.Metal
    game:GetService("ReplicatedStorage").HandModels.PipePistol["Meshes/PipePistolBolt"].Material = Enum.Material.Metal
    -----Crossbow
    game:GetService("ReplicatedStorage").HandModels.Crossbow.Arrow.Material = Enum.Material.Wood
    game:GetService("ReplicatedStorage").HandModels.Crossbow["Meshes/Bow"].Material = Enum.Material.Metal
    game:GetService("ReplicatedStorage").HandModels.Crossbow.Union.Material = Enum.Material.Metal
    game:GetService("ReplicatedStorage").HandModels.Crossbow.Body.Material = Enum.Material.Wood
    game:GetService("ReplicatedStorage").HandModels.Crossbow.Mover.Material = Enum.Material.CorrodedMetal
    -----Bow
    game:GetService("ReplicatedStorage").HandModels.Bow.Arrow.Material = Enum.Material.Wood
    game:GetService("ReplicatedStorage").HandModels.Bow["Meshes/Bow"].Material = Enum.Material.Wood 
    game:GetService("ReplicatedStorage").HandModels.Bow.Fabric.Material = Enum.Material.Fabric

    -- COLOR

    -----HMAR
	game:GetService("ReplicatedStorage").HandModels.HMAR.Barrel.BrickColor = BrickColor.new("Dark grey")
	game:GetService("ReplicatedStorage").HandModels.HMAR.Body.BrickColor = BrickColor.new("Dark stone grey")
	game:GetService("ReplicatedStorage").HandModels.HMAR.Bolt.BrickColor = BrickColor.new("Medium stone grey")
	game:GetService("ReplicatedStorage").HandModels.HMAR.Stock.BrickColor = BrickColor.new("Bronze")
	game:GetService("ReplicatedStorage").HandModels.HMAR.Grip.BrickColor = BrickColor.new("Bronze")
	game:GetService("ReplicatedStorage").HandModels.HMAR.Mag.BrickColor = BrickColor.new("Dark stone grey")
	game:GetService("ReplicatedStorage").HandModels.HMAR.Muzzle.BrickColor = BrickColor.new("Bronze")
	game:GetService("ReplicatedStorage").HandModels.HMAR.IronSights.ADS.BrickColor = BrickColor.new("Medium stone grey")
	game:GetService("ReplicatedStorage").HandModels.HMAR.IronSights.Union.BrickColor = BrickColor.new("Medium stone grey")
	-----PipeSMG
	game:GetService("ReplicatedStorage").HandModels.PipeSMG.IronSights.ADS.BrickColor = BrickColor.new("Medium stone grey")
	game:GetService("ReplicatedStorage").HandModels.PipeSMG.IronSights.Union.BrickColor = BrickColor.new("Medium stone grey")
	game:GetService("ReplicatedStorage").HandModels.PipeSMG.Mag.BrickColor = BrickColor.new("Medium stone grey")
	game:GetService("ReplicatedStorage").HandModels.PipeSMG.Flap.BrickColor = BrickColor.new("Medium stone grey")
	game:GetService("ReplicatedStorage").HandModels.PipeSMG.Muzzle.BrickColor = BrickColor.new("Medium stone grey")
	game:GetService("ReplicatedStorage").HandModels.PipeSMG.Body.BrickColor = BrickColor.new("Dark stone grey")
	game:GetService("ReplicatedStorage").HandModels.PipeSMG.Bolt.BrickColor = BrickColor.new("Medium stone grey")
	-----USP
	game:GetService("ReplicatedStorage").HandModels.USP.IronSights.ADS.BrickColor = BrickColor.new("Lime green")
	game:GetService("ReplicatedStorage").HandModels.USP.IronSights.Union.BrickColor = BrickColor.new("Medium stone grey")
	game:GetService("ReplicatedStorage").HandModels.USP.Muzzle.BrickColor = BrickColor.new("Medium stone grey")
	game:GetService("ReplicatedStorage").HandModels.USP.Mag.BrickColor = BrickColor.new("Medium stone grey")
	game:GetService("ReplicatedStorage").HandModels.USP["Meshes/USP_Slide"].BrickColor = BrickColor.new("Silver flip/flop")
	game:GetService("ReplicatedStorage").HandModels.USP["Meshes/USP_Body"].BrickColor = BrickColor.new("Dark stone grey")
    -----Pipe
    game:GetService("ReplicatedStorage").HandModels.PipePistol.IronSights.ADS.BrickColor = BrickColor.new("Dark stone grey")
    game:GetService("ReplicatedStorage").HandModels.PipePistol.IronSights["Meshes/PipePistolSights"].BrickColor = BrickColor.new("Medium stone grey")
    game:GetService("ReplicatedStorage").HandModels.PipePistol.Muzzle.BrickColor = BrickColor.new("Dark stone grey")
    game:GetService("ReplicatedStorage").HandModels.PipePistol.Mag.BrickColor = BrickColor.new("Medium stone grey")
    game:GetService("ReplicatedStorage").HandModels.PipePistol["Meshes/PipePistolBody"].BrickColor = BrickColor.new("Dark stone grey")
    game:GetService("ReplicatedStorage").HandModels.PipePistol["Meshes/PipePistolBolt"].BrickColor = BrickColor.new("Medium stone grey")
    -----Crossbow
    game:GetService("ReplicatedStorage").HandModels.Crossbow.Arrow.BrickColor = BrickColor.new("Fawn brown")
    game:GetService("ReplicatedStorage").HandModels.Crossbow["Meshes/Bow"].BrickColor = BrickColor.new("Medium stone grey")
    game:GetService("ReplicatedStorage").HandModels.Crossbow.Union.BrickColor = BrickColor.new("Medium stone grey")
    game:GetService("ReplicatedStorage").HandModels.Crossbow.Body.BrickColor = BrickColor.new("Bronze")
    game:GetService("ReplicatedStorage").HandModels.Crossbow.Mover.BrickColor = BrickColor.new("Medium stone grey")
    -----Bow
    game:GetService("ReplicatedStorage").HandModels.Bow.Arrow.BrickColor = BrickColor.new("Fawn brown")
    game:GetService("ReplicatedStorage").HandModels.Bow["Meshes/Bow"].BrickColor = BrickColor.new("Bronze")
    game:GetService("ReplicatedStorage").HandModels.Bow.Fabric.BrickColor = BrickColor.new("Beige")
end)

SkinChangerSector:AddDropdown('MaterialV', {
    Values = { 'Default', 'ForceField', 'Neon' },
    Default = 1,
    Multi = false,
    Text = 'Gun Material',
    Tooltip = 'NOT USEFUL WITH CUSTOM SKINS!',
})
Options.MaterialV:OnChanged(function()
    if Options.MaterialV.Value == "Default" then
		-----HMAR
		game:GetService("ReplicatedStorage").HandModels.HMAR.Barrel.Material = Enum.Material.Metal
		game:GetService("ReplicatedStorage").HandModels.HMAR.Body.Material = Enum.Material.Metal
		game:GetService("ReplicatedStorage").HandModels.HMAR.Bolt.Material = Enum.Material.Metal
		game:GetService("ReplicatedStorage").HandModels.HMAR.Stock.Material = Enum.Material.Wood
		game:GetService("ReplicatedStorage").HandModels.HMAR.Grip.Material = Enum.Material.Wood
		game:GetService("ReplicatedStorage").HandModels.HMAR.Mag.Material = Enum.Material.Plastic
		game:GetService("ReplicatedStorage").HandModels.HMAR.Muzzle.Material = Enum.Material.Wood
		game:GetService("ReplicatedStorage").HandModels.HMAR.IronSights.ADS.Material = Enum.Material.Plastic
		game:GetService("ReplicatedStorage").HandModels.HMAR.IronSights.Union.Material = Enum.Material.Metal
		-----PipeSMG
		game:GetService("ReplicatedStorage").HandModels.PipeSMG.IronSights.ADS.Material = Enum.Material.Metal
		game:GetService("ReplicatedStorage").HandModels.PipeSMG.IronSights.Union.Material = Enum.Material.Metal
		game:GetService("ReplicatedStorage").HandModels.PipeSMG.Mag.Material = Enum.Material.Metal
		game:GetService("ReplicatedStorage").HandModels.PipeSMG.Flap.Material = Enum.Material.Metal
		game:GetService("ReplicatedStorage").HandModels.PipeSMG.Muzzle.Material = Enum.Material.Plastic
		game:GetService("ReplicatedStorage").HandModels.PipeSMG.Body.Material = Enum.Material.Metal
		game:GetService("ReplicatedStorage").HandModels.PipeSMG.Bolt.Material = Enum.Material.Metal
		-----USP
		game:GetService("ReplicatedStorage").HandModels.USP.IronSights.ADS.Material = Enum.Material.Metal
		game:GetService("ReplicatedStorage").HandModels.USP.IronSights.Union.Material = Enum.Material.Metal
		game:GetService("ReplicatedStorage").HandModels.USP.Muzzle.Material = Enum.Material.Plastic
		game:GetService("ReplicatedStorage").HandModels.USP.Mag.Material = Enum.Material.Metal
		game:GetService("ReplicatedStorage").HandModels.USP["Meshes/USP_Slide"].Material = Enum.Material.Metal
		game:GetService("ReplicatedStorage").HandModels.USP["Meshes/USP_Body"].Material = Enum.Material.Metal
        -----Pipe
        game:GetService("ReplicatedStorage").HandModels.PipePistol.IronSights.ADS.Material = Enum.Material.Plastic
        game:GetService("ReplicatedStorage").HandModels.PipePistol.IronSights["Meshes/PipePistolSights"].Material = Enum.Material.Metal
        game:GetService("ReplicatedStorage").HandModels.PipePistol.Muzzle.Material = Enum.Material.Plastic
        game:GetService("ReplicatedStorage").HandModels.PipePistol.Mag.Material = Enum.Material.Plastic
        game:GetService("ReplicatedStorage").HandModels.PipePistol["Meshes/PipePistolBody"].Material = Enum.Material.Metal
        game:GetService("ReplicatedStorage").HandModels.PipePistol["Meshes/PipePistolBolt"].Material = Enum.Material.Metal
        -----Crossbow
        game:GetService("ReplicatedStorage").HandModels.Crossbow.Arrow.Material = Enum.Material.Wood
        game:GetService("ReplicatedStorage").HandModels.Crossbow["Meshes/Bow"].Material = Enum.Material.Metal
        game:GetService("ReplicatedStorage").HandModels.Crossbow.Union.Material = Enum.Material.Metal
        game:GetService("ReplicatedStorage").HandModels.Crossbow.Body.Material = Enum.Material.Wood
        game:GetService("ReplicatedStorage").HandModels.Crossbow.Mover.Material = Enum.Material.CorrodedMetal
        -----Bow
        game:GetService("ReplicatedStorage").HandModels.Bow.Arrow.Material = Enum.Material.Wood
        game:GetService("ReplicatedStorage").HandModels.Bow["Meshes/Bow"].Material = Enum.Material.Wood 
        game:GetService("ReplicatedStorage").HandModels.Bow.Fabric.Material = Enum.Material.Fabric
	elseif Options.MaterialV.Value == "ForceField" then
		-----HMAR
		game:GetService("ReplicatedStorage").HandModels.HMAR.Barrel.Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.HMAR.Body.Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.HMAR.Bolt.Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.HMAR.Stock.Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.HMAR.Grip.Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.HMAR.Mag.Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.HMAR.Muzzle.Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.HMAR.IronSights.ADS.Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.HMAR.IronSights.Union.Material = Enum.Material.ForceField
		-----PipeSMG
		game:GetService("ReplicatedStorage").HandModels.PipeSMG.IronSights.ADS.Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.PipeSMG.IronSights.Union.Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.PipeSMG.Mag.Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.PipeSMG.Flap.Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.PipeSMG.Muzzle.Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.PipeSMG.Body.Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.PipeSMG.Bolt.Material = Enum.Material.ForceField
		-----USP
		game:GetService("ReplicatedStorage").HandModels.USP.IronSights.ADS.Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.USP.IronSights.Union.Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.USP.Muzzle.Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.USP.Mag.Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.USP["Meshes/USP_Slide"].Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.USP["Meshes/USP_Body"].Material = Enum.Material.ForceField
        -----Pipe
        game:GetService("ReplicatedStorage").HandModels.PipePistol.IronSights.ADS.Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.PipePistol.IronSights["Meshes/PipePistolSights"].Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.PipePistol.Muzzle.Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.PipePistol.Mag.Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.PipePistol["Meshes/PipePistolBody"].Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.PipePistol["Meshes/PipePistolBolt"].Material = Enum.Material.ForceField
        -----Crossbow
        game:GetService("ReplicatedStorage").HandModels.Crossbow.Arrow.Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.Crossbow["Meshes/Bow"].Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.Crossbow.Union.Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.Crossbow.Body.Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.Crossbow.Mover.Material = Enum.Material.ForceField
        -----Bow
        game:GetService("ReplicatedStorage").HandModels.Bow.Arrow.Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.Bow["Meshes/Bow"].Material = Enum.Material.ForceField
		game:GetService("ReplicatedStorage").HandModels.Bow.Fabric.Material = Enum.Material.ForceField
	elseif Options.MaterialV.Value == "Neon" then
		-----HMAR
		game:GetService("ReplicatedStorage").HandModels.HMAR.Barrel.Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.HMAR.Body.Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.HMAR.Bolt.Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.HMAR.Stock.Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.HMAR.Grip.Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.HMAR.Mag.Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.HMAR.Muzzle.Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.HMAR.IronSights.ADS.Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.HMAR.IronSights.Union.Material = Enum.Material.Neon
		-----PipeSMG
		game:GetService("ReplicatedStorage").HandModels.PipeSMG.IronSights.ADS.Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.PipeSMG.IronSights.Union.Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.PipeSMG.Mag.Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.PipeSMG.Flap.Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.PipeSMG.Muzzle.Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.PipeSMG.Body.Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.PipeSMG.Bolt.Material = Enum.Material.Neon
		-----USP
		game:GetService("ReplicatedStorage").HandModels.USP.IronSights.ADS.Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.USP.IronSights.Union.Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.USP.Muzzle.Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.USP.Mag.Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.USP["Meshes/USP_Slide"].Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.USP["Meshes/USP_Body"].Material = Enum.Material.Neon
        -----Pipe
        game:GetService("ReplicatedStorage").HandModels.PipePistol.IronSights.ADS.Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.PipePistol.IronSights["Meshes/PipePistolSights"].Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.PipePistol.Muzzle.Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.PipePistol.Mag.Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.PipePistol["Meshes/PipePistolBody"].Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.PipePistol["Meshes/PipePistolBolt"].Material = Enum.Material.Neon
        -----Crossbow
        game:GetService("ReplicatedStorage").HandModels.Crossbow.Arrow.Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.Crossbow["Meshes/Bow"].Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.Crossbow.Union.Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.Crossbow.Body.Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.Crossbow.Mover.Material = Enum.Material.Neon
        -----Bow
        game:GetService("ReplicatedStorage").HandModels.Bow.Arrow.Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.Bow["Meshes/Bow"].Material = Enum.Material.Neon
		game:GetService("ReplicatedStorage").HandModels.Bow.Fabric.Material = Enum.Material.Neon
        -----Yeoka
	end
end)

SkinChangerSector:AddDropdown('SkinChange', {
    Values = { 'Default', 'Rainbow', 'Glitch', 'Water' },
    Default = 1,
    Multi = false,
    Text = 'Gun Skins',
    Tooltip = 'NOT USEFUL WITH GUN COLOR, MATERIAL!',
})
Options.SkinChange:OnChanged(function()
    if Options.SkinChange.Value == "Default" then
        -- SMG
        -- HMAR
        -- USP
        -- Pipe
        -- Yeoka
        -- Bow
        -- Crossbow
    end

    if Options.SkinChange.Value == "Rainbow" then
        -- SMG
        -- HMAR
        -- USP
        -- Pipe
        -- Yeoka
        -- Bow
        -- Crossbow
    end

    if Options.SkinChange.Value == "Glitch" then
        -- SMG
        -- HMAR
        -- USP
        -- Pipe
        -- Yeoka
        -- Bow
        -- Crossbow
    end

    if Options.SkinChange.Value == "Water" then
        -- SMG
        -- HMAR
        -- USP
        -- Pipe
        -- Yeoka
        -- Bow
        -- Crossbow
    end
end)

local SoundChangerSection = MiscTab:AddRightGroupbox('SoundChanger')

SoundChangerSection:AddDropdown('HeadshotHit', {
    Values = { 'Default', 'Neverlose', 'Rust', 'TF2', 'Bruh', 'Hm, is nice'},
    Default = 1,
    Multi = false,
    Text = 'Hit Headshot',
    Tooltip = 'Changes player hit headshot sound',
})
Options.HeadshotHit:OnChanged(function()
    if Options.HeadshotHit.Value == "Default" then
        SoundService.PlayerHitHeadshot.SoundId = "rbxassetid://9119561046"
        wait(0.2)
        SoundService.PlayerHitHeadshot.Playing = true
    end

    if Options.HeadshotHit.Value == "Neverlose" then
        SoundService.PlayerHitHeadshot.SoundId = "rbxassetid://6607204501"
        wait(0.2)
        SoundService.PlayerHitHeadshot.Playing = true
    end

    if Options.HeadshotHit.Value == "Rust" then
        SoundService.PlayerHitHeadshot.SoundId = "rbxassetid://4764109000"
        wait(0.2)
        SoundService.PlayerHitHeadshot.Playing = true
    end

    if Options.HeadshotHit.Value == "TF2" then
        SoundService.PlayerHitHeadshot.SoundId = "rbxassetid://2868331684"
        wait(0.2)
        SoundService.PlayerHitHeadshot.Playing = true
    end

    if Options.HeadshotHit.Value == "Bruh" then
        SoundService.PlayerHitHeadshot.SoundId = "rbxassetid://4275842574"
        wait(0.2)
        SoundService.PlayerHitHeadshot.Playing = true
    end

    if Options.HeadshotHit.Value == "Hm, is nice" then
        SoundService.PlayerHitHeadshot.SoundId = "rbxassetid://5570758643"
        wait(0.2)
        SoundService.PlayerHitHeadshot.Playing = true
    end
end)

SoundChangerSection:AddDropdown('Hit', {
    Values = { 'Default', 'Neverlose', 'Rust', 'TF2', 'Bruh', 'Hm, is nice'},
    Default = 1,
    Multi = false,
    Text = 'Player Hit',
    Tooltip = 'Changes player hit sound',
})
Options.Hit:OnChanged(function()
    if Options.Hit.Value == "Default" then
        SoundService.PlayerHit.SoundId = "rbxassetid://9114487369"
        SoundService.PlayerHit2.SoundId = "rbxassetid://9114487369"
        wait(0.2)
        SoundService.PlayerHit2.Playing = true
    end

    if Options.Hit.Value == "Neverlose" then
        SoundService.PlayerHit.SoundId = "rbxassetid://6607204501"
        SoundService.PlayerHit2.SoundId = "rbxassetid://6607204501"
        wait(0.2)
        SoundService.PlayerHit2.Playing = true
    end

    if Options.Hit.Value == "Rust" then
        SoundService.PlayerHit.SoundId = "rbxassetid://4764109000"
        SoundService.PlayerHit2.SoundId = "rbxassetid://4764109000"
        wait(0.2)
        SoundService.PlayerHit2.Playing = true
    end

    if Options.Hit.Value == "TF2" then
        SoundService.PlayerHit.SoundId = "rbxassetid://2868331684"
        SoundService.PlayerHit2.SoundId = "rbxassetid://2868331684"
        wait(0.2)
        SoundService.PlayerHit2.Playing = true
    end

    if Options.Hit.Value == "Bruh" then
        SoundService.PlayerHit.SoundId = "rbxassetid://4275842574"
        SoundService.PlayerHit2.SoundId = "rbxassetid://4275842574"
        wait(0.2)
        SoundService.PlayerHit2.Playing = true
    end

    if Options.Hit.Value == "Hm, is nice" then
        SoundService.PlayerHit.SoundId = "rbxassetid://5570758643"
        SoundService.PlayerHit2.SoundId = "rbxassetid://5570758643"
        wait(0.2)
        SoundService.PlayerHit2.Playing = true
    end
end)

SoundChangerSection:AddSlider('CVH', {
    Text = 'Volume',
    Default = 1,
    Min = 0,
    Max = 5,
    Rounding = 1,
    Compact = false,
})
Options.CVH:OnChanged(function(vol)
    SoundService.PlayerHitHeadshot.Volume = vol
    SoundService.PlayerHit.Volume = vol
    SoundService.PlayerHit2.Volume = vol
end)

SoundChangerSection:AddSlider('CPS', {
    Text = 'Pitch',
    Default = 1,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Compact = false,
})
Options.CPS:OnChanged(function(pich)
    SoundService.PlayerHitHeadshot.Pitch = pich
    SoundService.PlayerHit.Pitch = pich
    SoundService.PlayerHit2.Pitch = pich
end)

--


-- HomeRay
local HomeRaySect = VisualsTab:AddLeftGroupbox('HomeRay')

HomeRaySect:AddLabel('On/Off'):AddKeyPicker('Hrk', {
    Default = 'T', 
    SyncToggleState = false, 
    Mode = 'Toggle',
    Text = 'HomeRay',
    NoUI = false,
})
Options.Hrk:OnClick(function()
    if HomeRayOn == false then
	    HomeRayOn = true
		for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
			if v:FindFirstChild("Hitbox") then
				v.Hitbox.Transparency = HRTransp
			end
		end
	else
		HomeRayOn = false
		for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
			if v:FindFirstChild("Hitbox") then
				v.Hitbox.Transparency = 0
			end
		end
	end
end)

HomeRaySect:AddSlider('Hrts', {
    Text = 'Transparency',
    Default = 0.9,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,
})
Options.Hrts:OnChanged(function(hrt)
    HRTransp = hrt
end)
--

-- Leaves Remove
local WorldSect = VisualsTab:AddRightGroupbox('World')

WorldSect:AddButton('Leaves Remove', function()
    LeavesRemoverOn = true
    while LeavesRemoverOn == true do
        for v, i in pairs(game:GetService("Workspace"):GetChildren()) do
            if i:FindFirstChild("Part") then
                if i:FindFirstChild("top") then
                    i.top:Remove()
                else
                    for x,b in pairs(i:GetChildren()) do
                        if b.ClassName == "MeshPart" and b.MeshId == "rbxassetid://743205322" then
                            b:Remove()
                        end
                    end
                end
            end
        end
    wait(5)
    end
end)
--

-- Grass Remove
WorldSect:AddToggle('Gr', {
    Text = 'Grass',
    Default = true,
    Tooltip = 'Off/on grass',
})
Toggles.Gr:OnChanged(function(GrassRemove)
    sethiddenproperty(game.Workspace.Terrain, "Decoration", GrassRemove)
end)
--

-- Global Shadow
WorldSect:AddToggle('Gs',{
    Text = 'Shadows',
    Default = true,
    Tooltip = "Off/On GlobalShadows",
})
Toggles.Gs:OnChanged(function(T)
    game:GetService("Lighting").GlobalShadows = T
end)

-- Clouds
WorldSect:AddToggle('Clh',{
    Text = '3D Clouds',
    Default = true,
    Tooltip = "Off/On 3d clouds",
})
Toggles.Clh:OnChanged(function(T)
    if T == true then
        game:GetService("Workspace").Terrain.Clouds.Enabled = true
    elseif T == false then
        game:GetService("Workspace").Terrain.Clouds.Enabled = false
    end
end)

-- PickUp All
WorldSect:AddLabel('PickUp All'):AddKeyPicker('pckk', {
    Default = "F",
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'PickUp All',
    NoUI = false,
})
Options.pckk:OnClick(function()
	game:GetService("ReplicatedStorage").e:FireServer(106, 1,true)
	game:GetService("ReplicatedStorage").e:FireServer(106, 2,true)
	game:GetService("ReplicatedStorage").e:FireServer(106, 3,true)
	game:GetService("ReplicatedStorage").e:FireServer(106, 4,true)
	game:GetService("ReplicatedStorage").e:FireServer(106, 5,true)
	game:GetService("ReplicatedStorage").e:FireServer(106, 6,true)
	game:GetService("ReplicatedStorage").e:FireServer(106, 7,true)
	game:GetService("ReplicatedStorage").e:FireServer(106, 8,true)
	game:GetService("ReplicatedStorage").e:FireServer(106, 9,true)
	game:GetService("ReplicatedStorage").e:FireServer(106, 10,true)
	game:GetService("ReplicatedStorage").e:FireServer(106, 11,true)
	game:GetService("ReplicatedStorage").e:FireServer(106, 12,true)
	game:GetService("ReplicatedStorage").e:FireServer(106, 13,true)
	game:GetService("ReplicatedStorage").e:FireServer(106, 14,true)
	game:GetService("ReplicatedStorage").e:FireServer(106, 15,true)
	game:GetService("ReplicatedStorage").e:FireServer(106, 16,true)
	game:GetService("ReplicatedStorage").e:FireServer(106, 17,true)
	game:GetService("ReplicatedStorage").e:FireServer(106, 18,true)
    game:GetService("ReplicatedStorage").e:FireServer(106, 19,true)
	game:GetService("ReplicatedStorage").e:FireServer(106, 20,true)
	game:GetService("ReplicatedStorage").e:FireServer(106, 21,true)
	game:GetService("ReplicatedStorage").e:FireServer(106, 22,true)
end)
--

-- Fov
local ArmSector = VisualsTab:AddRightGroupbox('Fov')

ArmSector:AddSlider('Fc', {
    Text = 'Changer',
    Default = 70,
    Min = 0,
    Max = 120,
    Rounding = 0,
    Compact = false,
})
Options.Fc:OnChanged(function(t)
    gmt.__index = newcclosure(function(self,b)
		if b == "FieldOfView" then
			return t
		end
		return oldindex(self,b)
	end)
end)

ArmSector:AddLabel('Zoom'):AddKeyPicker('ZoomPick', {
    Default = 'X', 
    SyncToggleState = false, 
    Mode = 'Toggle',
    Text = 'Zoom',
    NoUI = false,
})

Options.ZoomPick:OnClick(function()
    if ZoomOn == false then
        ZoomOn = true
        gmt.__index = newcclosure(function(self,b)
            if b == "FieldOfView" then
                return 1
            end
                return oldindex(self,b)
            end)
    else
        ZoomOn = false
        gmt.__index = newcclosure(function(self,b)
            if b == "FieldOfView" then
                return 70
            end
                return oldindex(self,b)
        end)
    end
end)
--

-- Arms
local ArmsSect = VisualsTab:AddRightGroupbox('Player Arms')
ArmsSect:AddButton('Set Default Color', function() 
    game:GetService("Workspace").Ignore.FPSArms.RightUpperArm.BrickColor = BrickColor.new("Linen")
    game:GetService("Workspace").Ignore.FPSArms.RightLowerArm.BrickColor = BrickColor.new("Linen")
    game:GetService("Workspace").Ignore.FPSArms.RightHand.BrickColor = BrickColor.new("Linen")
    game:GetService("Workspace").Ignore.FPSArms.LeftUpperArm.BrickColor = BrickColor.new("Linen")
    game:GetService("Workspace").Ignore.FPSArms.LeftLowerArm.BrickColor = BrickColor.new("Linen")
    game:GetService("Workspace").Ignore.FPSArms.LeftHand.BrickColor = BrickColor.new("Linen")
    game:GetService("ReplicatedStorage").HandModels.HMAR.Handle.BrickColor = BrickColor.new("Cool yellow")
end)

ArmsSect:AddLabel('Color'):AddColorPicker('ARCCCC', {
    Default = Color3.new(1, 0.650980, 0),
    Title = 'Arms Color',
})

Options.ARCCCC:OnChanged(function(ARMC)
    game:GetService("Workspace").Ignore.FPSArms.RightUpperArm.Color = ARMC
    game:GetService("Workspace").Ignore.FPSArms.RightLowerArm.Color = ARMC
    game:GetService("Workspace").Ignore.FPSArms.RightHand.Color = ARMC
    game:GetService("Workspace").Ignore.FPSArms.LeftUpperArm.Color = ARMC
    game:GetService("Workspace").Ignore.FPSArms.LeftLowerArm.Color = ARMC
    game:GetService("Workspace").Ignore.FPSArms.LeftHand.Color = ARMC
    game:GetService("ReplicatedStorage").HandModels.HMAR.Handle.Color = ARMC
end)

ArmsSect:AddDropdown('MaterialD', {
    Values = { 'Default', 'ForceField', 'Neon', 'CrackedLava' },
    Default = 1, 
    Multi = false, 
    Text = 'Material',
    Tooltip = 'Arms Material', 
})

Options.MaterialD:OnChanged(function()
    if Options.MaterialD.Value == "Default" then
        game:GetService("Workspace").Ignore.FPSArms.RightUpperArm.Material = "Plastic"
        game:GetService("Workspace").Ignore.FPSArms.RightLowerArm.Material = "Plastic"
        game:GetService("Workspace").Ignore.FPSArms.RightHand.Material = "Plastic"
        game:GetService("Workspace").Ignore.FPSArms.LeftUpperArm.Material = "Plastic"
        game:GetService("Workspace").Ignore.FPSArms.LeftLowerArm.Material = "Plastic"
        game:GetService("Workspace").Ignore.FPSArms.LeftHand.Material = "Plastic"
        game:GetService("ReplicatedStorage").HandModels.HMAR.Handle.Material = "Plastic"
    end

    if Options.MaterialD.Value == "ForceField" then
        game:GetService("Workspace").Ignore.FPSArms.RightUpperArm.Material = "ForceField"
        game:GetService("Workspace").Ignore.FPSArms.RightLowerArm.Material = "ForceField"
        game:GetService("Workspace").Ignore.FPSArms.RightHand.Material = "ForceField"
        game:GetService("Workspace").Ignore.FPSArms.LeftUpperArm.Material = "ForceField"
        game:GetService("Workspace").Ignore.FPSArms.LeftLowerArm.Material = "ForceField"
        game:GetService("Workspace").Ignore.FPSArms.LeftHand.Material = "ForceField"
        game:GetService("ReplicatedStorage").HandModels.HMAR.Handle.Material = "ForceField"
    end

    if Options.MaterialD.Value == "Neon" then
        game:GetService("Workspace").Ignore.FPSArms.RightUpperArm.Material = "Neon"
        game:GetService("Workspace").Ignore.FPSArms.RightLowerArm.Material = "Neon"
        game:GetService("Workspace").Ignore.FPSArms.RightHand.Material = "Neon"
        game:GetService("Workspace").Ignore.FPSArms.LeftUpperArm.Material = "Neon"
        game:GetService("Workspace").Ignore.FPSArms.LeftLowerArm.Material = "Neon"
        game:GetService("Workspace").Ignore.FPSArms.LeftHand.Material = "Neon"
        game:GetService("ReplicatedStorage").HandModels.HMAR.Handle.Material = "Neon"
    end

    if Options.MaterialD.Value == "CrackedLava" then
        game:GetService("Workspace").Ignore.FPSArms.RightUpperArm.Material = "CrackedLava"
        game:GetService("Workspace").Ignore.FPSArms.RightLowerArm.Material = "CrackedLava"
        game:GetService("Workspace").Ignore.FPSArms.RightHand.Material = "CrackedLava"
        game:GetService("Workspace").Ignore.FPSArms.LeftUpperArm.Material = "CrackedLava"
        game:GetService("Workspace").Ignore.FPSArms.LeftLowerArm.Material = "CrackedLava"
        game:GetService("Workspace").Ignore.FPSArms.LeftHand.Material = "CrackedLava"
        game:GetService("ReplicatedStorage").HandModels.HMAR.Handle.Material = "CrackedLava"
    end
end)
--

-- ESP
local EspSect = VisualsTab:AddLeftGroupbox('Player ESP')

EspSect:AddToggle('BoxToggle', {
    Text = 'Box',
    Default = false,
}):OnChanged(function(Toggle)

end)

EspSect:AddToggle('NameESPToggle', {
    Text = 'Name',
    Default = false
}):OnChanged(function(State3)
    Names = State3
    screen = State3
    end)
    
    function WTS(part)
    local screen = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
        return Vector2.new(screen.x, screen.y - 15)
    end
    
    function ESPText(part)
    local name = Drawing.new("Text")
    name.Text = part.Nametag.tag.Text
    name.Color = Color3.new(255, 255, 255)
    name.Position = WTS(part)
    name.Size = 12.0
    name.Font = 2
    name.Outline = true
    name.Center = true
    name.Visible = true
    
    game:GetService("RunService").Stepped:connect(function()
        pcall(function()
        local destroyed = not part:IsDescendantOf(game.Workspace)
        if destroyed and name ~= nil then
            name:Remove()
        end
        if part ~= nil then
            name.Position = WTS(part)
        end
        local _, screen = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
        
        if screen and Names then
            name.Visible = true
        else
            name.Visible = false
        end
    end)
    end)
end

for _,v in pairs(game:GetService("Workspace"):GetDescendants()) do 
    if v.Name == "Head" and v.Parent.Name == "Model" then
        ESPText(v)
    end
end

game.Workspace.DescendantAdded:Connect(function(v)
    if v.Name == "Head" and v.Parent.Name == "Model" then
        ESPText(v)
    end
end)

EspSect:AddToggle('HpToggle', {
    Text = 'Healthbar',
    Default = false,
}):OnChanged(function(Toggle)
    Healthbar = Toggle
end)

EspSect:AddToggle('ChamsToggle', {
    Text = 'Chams',
    Default = false,
}):OnChanged(function(Toggle)
    Chamses = Toggle
end)

EspSect:AddToggle('LinesToggle', {
    Text = 'Lines',
    Default = false,
}):OnChanged(function(Toggle)
    Lines = Toggle
end)

local ObjectEspSect = VisualsTab:AddLeftGroupbox('Object ESP')

local ClaimStoneESP = ObjectEspSect:AddButton('Claimstone', function()
    local function CreateEsp(name,text,P)
        local ESP = Instance.new("BillboardGui")
        local EspText = Instance.new("TextLabel")
    
        ESP.Name = name
        ESP.Parent = P
        ESP.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ESP.Active = true
        ESP.AlwaysOnTop = true
        ESP.LightInfluence = 1.000
        ESP.Size = UDim2.new(0, 200, 0, 50)
        ESP.SizeOffset = Vector2.new(0, 0.3)
        ESP.Adornee = P
    
        EspText.Name = "EspText"
        EspText.Parent = ESP
        EspText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        EspText.BackgroundTransparency = 1.000
        EspText.Size = UDim2.new(0, 200, 0, 50)
        EspText.Font = Enum.Font.SourceSans
        EspText.Text = text
        EspText.TextColor3 = Color3.fromRGB(21, 255, 0)
        EspText.TextSize = 15
        EspText.TextWrapped = true
    end
    
    for _,v in pairs(game.Workspace:GetDescendants()) do
        if v:FindFirstChild("Base") and v:FindFirstChild("Part") and v:FindFirstChild("Union") and v:FindFirstChild("State") then
            if not v:FindFirstChild("csESP") then
                CreateEsp("csESP","Claimstone",v)
            end
        end
    end
end)

local ClaimStoneESPDestroy = ClaimStoneESP:AddButton('Destroy', function()
    for _,v in pairs(game.Workspace:GetDescendants()) do
        if v:FindFirstChild("csESP") then
            v.csESP:Destroy()
        end
    end
end)

local MilitaryCrateESP = ObjectEspSect:AddButton('MilitaryCrate', function()

end)

local MilitaryCrateDestroy = MilitaryCrateESP:AddButton('Destroy', function()
    
end)

--

-- Aim
local AimlockSector = CombatTab:AddLeftGroupbox('Aimlock')
AimlockSector:AddLabel('Keybind'):AddKeyPicker('AIMKBK', {
    Default = 'V', 
    SyncToggleState = false, 
    Mode = 'Toggle',
    Text = 'Aimlock',
    NoUI = false,
})
Options.AIMKBK:OnClick(function(Value)
    local Target;
	if AimbotOn == false then
        AimbotOn = true
		while AimbotOn == true do
			Target = getClosestPlayerToPlayer();
			if Target then
				local Head = Target:FindFirstChild("Head");
				if Head then
					local pos, _ = Cameras:WorldToScreenPoint(Head.Position)
					mousemoverel((pos.X - (Mouse.X))/_Aimbot["AimSmooth"], (pos.Y - (Mouse.Y))/_Aimbot["AimSmooth"])
				end
			end
			wait(0.01)
		end
	else
		AimbotOn = false
	end
end)

AimlockSector:AddToggle('vftt', {
    Text = 'Visible Fov',
    Default = false,
    Tooltip = 'Off/On Visible Fov',
})
Toggles.vftt:OnChanged(function(J)
    fovcircle.Visible = J
end)

AimlockSector:AddToggle('Altch', {
    Text = "Team Check",
    Default = false,
    Tooltip = 'Off/on team check',
})
Toggles.Altch:OnChanged(function(T)
    --
end)

AimlockSector:AddToggle('Altsh', {
    Text = "Sleepers Check",
    Default = false,
    Tooltip = 'Off/on Sleepers check',
})
Toggles.Altsh:OnChanged(function(T)
    --
end)

AimlockSector:AddLabel('Color'):AddColorPicker('CCFF', {
    Default = Color3.new(1, 0, 0),
    Title = 'Fov Color',
})
Options.CCFF:OnChanged(function(KKK)
   fovcircle.Color = KKK
end)

AimlockSector:AddSlider('ADSSS', {
    Text = 'Aim ditance',
    Default = 650,
    Min = 300,
    Max = 1200,
    Rounding = 0,
    Compact = false,
})
Options.ADSSS:OnChanged(function(t)
    ASSettings["AimDis"] = t
end)

AimlockSector:AddSlider('frsss', {
    Text = 'Fov radius',
    Default = 70,
    Min = 0,
    Max = 600,
    Rounding = 0,
    Compact = false,
})
Options.frsss:OnChanged(function(t)
    fovcircle.Radius = t
end)

AimlockSector:AddSlider('ASSSS', {
    Text = 'Aim Smoothnes',
    Default = 20,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Compact = false,
})
Options.ASSSS:OnChanged(function(t)
    _Aimbot["AimSmooth"] = t/10
end)

local PipePistolDerect = require(game.ReplicatedStorage.ItemConfigs.PipePistol)
local PipeSMGDerect = require(game.ReplicatedStorage.ItemConfigs.PipeSMG)
local USPDerect = require(game.ReplicatedStorage.ItemConfigs.USP)
local HMARDerect = require(game.ReplicatedStorage.ItemConfigs.HMAR)
local CrossbowDerect = require(game.ReplicatedStorage.ItemConfigs.Crossbow)
local BowDerect = require(game.ReplicatedStorage.ItemConfigs.Bow)
local BlunderbussDerect = require(game.ReplicatedStorage.ItemConfigs.Blunderbuss)
local BowDerect = require(game.ReplicatedStorage.ItemConfigs.Bow)
local DerectCrossbow = require(game.ReplicatedStorage.ItemConfigs.Crossbow)

local GunModsSector = CombatTab:AddRightGroupbox('Gun Mods')

GunModsSector:AddToggle('Gnnr', {
    Text = "No Recoil",
    Default = false,
    Tooltip = 'Off gun recoil',
})
Toggles.Gnnr:OnChanged(function(T)
    if T == true then
        PipePistolDerect.recoilPattern = { { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 } }
		PipeSMGDerect.recoilPattern = { { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 } }
		USPDerect.recoilPattern ={ { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 } }
		HMARDerect.recoilPattern = { { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 } }
		USPDerect.anims.fire = ""
		BowDerect.recoilPattern = { { 0, 0 } } 
		DerectCrossbow.recoilPattern = { { 0, 0 } }
    elseif T == false then
        PipePistolDerect.recoilPattern = { { 0, 1 }, { 0, 1 }, { 1, 1 }, { 1, 1 }, { 2, 1 }, { 2, 1 }, { 2, 1 }, { 1, 1 }, { -1, 1 }, { -1, 1 }, { -1, 1 }, { -2, 1 }, { -2, 1 }, { -1, 1 }, { 0, 1 }, { 0, 1 } }
		PipeSMGDerect.recoilPattern = { { 0, 0.75 }, { 0.5, 0.75 }, { 0.5, 0.75 }, { -0.5, 0.75 }, { -0.5, 0.75 }, { -0.5, 0.75 }, { 0.3, 0.75 }, { 0.3, 0.75 }, { -0.3, 0.6 }, { -0.3, 0.6 }, { 0.5, 0.6 }, { -0.5, 0.4 }, { -0.5, 0.3 }, { -1, 0.15 }, { -1, 0.05 }, { -1, 0.02 }, { -1, 0.02 }, { -1, 0.02 }, { -1, 0.02 }, { -0.4, 0.1 }, { 0, 0.05 }, { 0, 0.02 }, { 0.1, 0.02 }, { 0.2, 0.02 }, { 0.4, 0.02 }, { 0.5, 0.02 } }
		USPDerect.recoilPattern = { { 0, 1 }, { 0, 1 }, { 1, 1 }, { 1, 1 }, { 2, 1 }, { 2, 1 }, { 2, 1 }, { 1, 1 }, { -1, 1 }, { -1, 1 }, { -1, 1 }, { -2, 1 }, { -2, 1 }, { -1, 1 }, { 0, 1 }, { 0, 1 } }
		BowDerect.recoilPattern = { { 0, 1 } }
		DerectCrossbow.recoilPattern = { { 0, 1 } }
		HMARDerect.recoilPattern = { { 0, 0.75 }, { 0.5, 0.75 }, { 0.5, 0.75 }, { -0.5, 0.75 }, { -0.5, 0.75 }, { -0.5, 0.75 }, { 0.3, 0.75 }, { 0.3, 0.75 }, { -0.3, 0.6 }, { -0.3, 0.6 }, { 0.5, 0.6 }, { -0.5, 0.4 }, { -0.5, 0.3 }, { -1, 0.15 }, { -1, 0.05 }, { -1, 0.02 }, { -1, 0.02 }, { -1, 0.02 }, { -1, 0.02 }, { -0.4, 0.1 }, { 0, 0.05 }, { 0, 0.02 }, { 0.1, 0.02 }, { 0.2, 0.02 }, { 0.4, 0.02 }, { 0.5, 0.02 } }
    end
end)

GunModsSector:AddToggle('Gnek', {
    Text = 'Eoka Good',
    Default = false,
    Tooltip = 'No scatter for eoka'
})
Toggles.Gnek:OnChanged(function(T)
    if T == true then
        BlunderbussDerect.accuracy = 999999999
        BlunderbussDerect.recoilPattern = { { 0, 0 } }
	elseif T == false then 
        BlunderbussDerect.accuracy = 1200
        BlunderbussDerect.recoilPattern = { { 0, 2 } }
	end
end)

GunModsSector:AddToggle('Gnns', {
    Text = "No Scatter",
    Default = false,
    Tooltip = 'Off gun scatter',
})
Toggles.Gnns:OnChanged(function(T)
    if T == true then
		PipePistolDerect.accuracy = 10000
		PipeSMGDerect.accuracy = 10000
		USPDerect.accuracy = 100000
		HMARDerect.accuracy = 70000
		BowDerect.accuracy = 100000
		DerectCrossbow.accuracy = 100000
	elseif T == false then 
	    BowDerect.accuracy = 5000
		PipePistolDerect.accuracy = 5000
		PipeSMGDerect.accuracy = 5000
		USPDerect.accuracy = 4000 
		HMARDerect.accuracy = 7000
		DerectCrossbow.accuracy = 5000
	end
end)

GunModsSector:AddToggle('Gnrf', {
    Text = "Rapid Fire",
    Default = false,
    Tooltip = "Pistols mode auto",
})
Toggles.Gnrf:OnChanged(function(T)
    if T == true then
        PipePistolDerect.fireAction = "auto"
        DerectCrossbow.fireAction = "auto"
        BowDerect.fireAction = "auto"
        USPDerect.fireAction = "auto"
    elseif T == false then
        PipePistolDerect.fireAction = "semi"
        DerectCrossbow.fireAction = "semi"
        BowDerect.fireAction = "semi"
        USPDerect.fireAction = "semi"
    end
end)

local HedsOn = Instance.new("Part")
HedsOn.Name = "HedsOn"
HedsOn.Anchored = false
HedsOn.CanCollide = false
HedsOn.Transparency = 1
HedsOn.Size = Vector3.new(4, 7, 3)
HedsOn.Parent = game.ReplicatedStorage

local HTTransparency = 0.8
local XSize = 3
local YSize = 6
local ZSize = 2

local BigHitboxes = CombatTab:AddLeftGroupbox('Hitboxes')

BigHitboxes:AddToggle('Bht', {
    Text = 'On/Off',
    Default = false,
    Tooltip = 'Makes big player hitboxes'
})
Toggles.Bht:OnChanged(function(HeadExtends)
    if HeadExtends == true then
	    while HeadExtends == true do
		    for v, i in pairs(game:GetService("Workspace"):GetChildren()) do
			    if i:FindFirstChild("Humanoid") then
				    if i:FindFirstChild("HumanoidRootPart") then
					    if not i:FindFirstChild("HedsOn") then
						    if i ~= game.Players.LocalPlayer.Character then
						        local BigHeadsPart = Instance.new("Part")
                                BigHeadsPart.Name = "Torso"
                                BigHeadsPart.Anchored = false
                                BigHeadsPart.CanCollide = false
                                BigHeadsPart.Transparency = HTTransparency
                                BigHeadsPart.Size = Vector3.new(XSize, YSize, ZSize)
						        
							    local HeadsParts = BigHeadsPart:Clone()
							    HeadsParts.Parent = i
							    HeadsParts.Orientation = i.HumanoidRootPart.Orientation
											
							    local HedsOn = HedsOn:Clone()
							    HedsOn.Parent = i
											
							    local Headswelding = Instance.new("Weld")
							    Headswelding.Parent = HeadsParts
							    Headswelding.Part0 = i.HumanoidRootPart
							    Headswelding.Part1 = HeadsParts
							    
							    HeadsParts.Position = Vector3.new(i.HumanoidRootPart.Position.X,i.HumanoidRootPart.Position.Y - 0.4, i.HumanoidRootPart.Position.Z)
						    end
					    end 
				    end
			    end
		    end
		    wait(3)
	    end
	else
	if HeadExtends == false then
		for v, i in pairs(game:GetService("Workspace"):GetChildren()) do
			if i:FindFirstChild("Humanoid") then
				if i:FindFirstChild("HumanoidRootPart") then
					if i:FindFirstChild("HedsOn") then
						i.HedsOn:Remove()
						for x,a in pairs(i:GetChildren()) do
							if a.Name == "Torso" then
								if not a:FindFirstChild("Nametag") and not a:FindFirstChild("Face") then
								    a:Remove()
								end
							end 
						end
					end 
				end
			end
		end
	end
end
end)

BigHitboxes:AddSlider('CHSSS', {
      Text = 'Transparency',
      Default = 0.8,
      Min = 0,
      Max = 1,
      Rounding = 1,
      Compact = false,
    })
    Options.CHSSS:OnChanged(function(HT)
    HTTransparency = HT
    end)

BigHitboxes:AddSlider('BhX', {
    Text = 'X Size',
    Default = 3,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Compact = false,
})
Options.BhX:OnChanged(function(t)
    XSize = t
end)

BigHitboxes:AddSlider('BhY', {
    Text = 'Y Size',
    Default = 6,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Compact = false,
})
Options.BhY:OnChanged(function(t)
    YSize = t
end)

BigHitboxes:AddSlider('BhZ', {
    Text = 'Z Size',
    Default = 2,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Compact = false,
})
Options.BhZ:OnChanged(function(t)
    ZSize = t
end)
--


-- UI
local Tabs = {
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'RightShift', NoUI = true, Text = 'Menu keybind' }) 

Library.ToggleKeybind = Options.MenuKeybind

MenuGroup:AddToggle('WMTT', {
    Text = 'Watermark',
    Default = true,
    Tooltip = 'Off/On Watermark',
})
Toggles.WMTT:OnChanged(function(wttt)
    Library:SetWatermarkVisibility(wttt)
end)

MenuGroup:AddToggle('KBTT', {
    Text = 'Keybind',
    Default = true,
    Tooltip = 'Off/On Keybind',
})
Toggles.KBTT:OnChanged(function(KBTTTT)
    Library.KeybindFrame.Visible = KBTTTT
end)

Library.KeybindFrame.Visible = true;

Library:OnUnload(function()
    Library.Unloaded = true
end)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings() 
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')
SaveManager:BuildConfigSection(Tabs['UI Settings']) 
ThemeManager:ApplyToTab(Tabs['UI Settings'])
--
