--Library
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({Title = 'LEGION',Center = true,AutoShow = true,TabPadding = 8,MenuFadeTime = 0.2})
local Tabs = {Main = Window:AddTab('Main'),Visual = Window:AddTab('Visual'),['UI Settings'] = Window:AddTab('UI Settings'),}

--Tables
local Functions = {}
local Esp = {Settings={
    Boxes=true,BoxesOutline=true,BoxesColor=Color3.fromRGB(34,255,7),BoxesOutlineColor=Color3.fromRGB(0,0,0),
    Sleeping=false,SleepingColor=Color3.fromRGB(34,255,7),
    Distances=true,DistanceColor=Color3.fromRGB(34,255,7),
    Armour=true,ArmourColor=Color3.fromRGB(34,255,7),
    Tool=true,ToolColor=Color3.fromRGB(34,255,7),
    ViewAngle=true,ViewAngleColor=Color3.fromRGB(255,255,255),ViewAngleThickness=1,ViewAngleTransparrency=1,
    TextFont=10,TextOutline=true,TextSize=24,RenderDistance=1500,TeamCheck=false,TargetSleepers=false,MinTextSize=8
},Drawings={},Connections={},Players={}}
local Fonts = {["UI"]=0,["System"]=1,["Plex"]=2,["Monospace"]=3}
local cache = {}

--Locals
local Camera = game:GetService("Workspace").CurrentCamera
local CharcaterMiddle = game:GetService("Workspace").Ignore.LocalCharacter.Middle

--Functions
function Functions:IsSleeping(Model)
    if Model and Model:FindFirstChild("AnimationController") and Model.AnimationController:FindFirstChild("Animator") then
		for i,v in pairs(Model.AnimationController.Animator:GetPlayingAnimationTracks()) do
            if v.Animation.AnimationId == "rbxassetid://13280887764" then
                return true
            else
                return false
            end
        end
    end
end
function Functions:Draw(Type,Propities)
    if not Type and not Propities then return end
    local drawing = Drawing.new(Type)
    for i,v in pairs(Propities) do
        drawing[i] = v
    end
    table.insert(Esp.Drawings,drawing)
    return drawing
end
function Esp:CreateEsp(PlayerTable)
    if not PlayerTable then return end
    local drawings = {}
    drawings.BoxOutline = Functions:Draw("Square",{Thickness=2,Filled=false,Transparency=1,Color=Esp.Settings.BoxesOutlineColor,Visible=false,ZIndex = -1,Visible=false});
    drawings.Box = Functions:Draw("Square",{Thickness=1,Filled=false,Transparency=1,Color=Esp.Settings.BoxesColor,Visible=false,ZIndex = 2,Visible=false});
    drawings.Sleeping = Functions:Draw("Text",{Text = "Nil",Font=Esp.Settings.TextFont,Size=Esp.Settings.TextSize,Center=true,Outline=Esp.Settings.TextOutline,Color = Esp.Settings.SleepingColor,ZIndex = 2,Visible=false})
    drawings.Distance = Functions:Draw("Text",{Text = "Nil",Font=Esp.Settings.TextFont,Size=Esp.Settings.TextSize,Center=true,Outline=Esp.Settings.TextOutline,Color = Esp.Settings.SleepingColor,ZIndex = 2,Visible=false})
    drawings.Armour = Functions:Draw("Text",{Text = " ",Font=Esp.Settings.TextFont,Size=Esp.Settings.TextSize,Center=false,Outline=Esp.Settings.TextOutline,Color = Esp.Settings.ArmourColor,ZIndex = 2,Visible=false})
    drawings.ViewAngle = Functions:Draw("Line",{Thickness=Esp.Settings.ViewAngleThickness,Transparency=Esp.Settings.ViewAngleTransparrency,Color=Esp.Settings.ViewAngleColor,ZIndex=2,Visible=false})
    drawings.PlayerTable = PlayerTable
    Esp.Players[PlayerTable.model] = drawings
end
function Esp:RemoveEsp(PlayerTable)
    if not PlayerTable and PlayerTable.model ~= nil then return end
    esp = Esp.Players[PlayerTable.model];
    if not esp then return end
    for i, v in pairs(esp) do
        if not type(v) == "table" then
            v:Remove();
        end
    end
    Esp.Players[PlayerTable.model] = nil;
end

function Esp:UpdateEsp()
    for i,v in pairs(Esp.Players) do
        local Character = i
        local Position,OnScreen = Camera:WorldToViewportPoint(Character:GetPivot().Position);
        local scale = 1 / (Position.Z * math.tan(math.rad(Camera.FieldOfView * 0.5)) * 2) * 100;
        local w,h = math.floor(40 * scale), math.floor(55 * scale);
        local x,y = math.floor(Position.X), math.floor(Position.Y);
        local Distance = (CharcaterMiddle:GetPivot().Position-Character:GetPivot().Position).Magnitude
        local BoxPosX,BoxPosY = math.floor(x - w * 0.5),math.floor(y - h * 0.5)
        local offsetCFrame = CFrame.new(0, 0, -4)
        local sleeping = Functions:IsSleeping(Character)
        if Character and Character:FindFirstChild("HumanoidRootPart") and Character:FindFirstChild("Head") then
            local TeamTag = Character.Head.Teamtag.Enabled
            if OnScreen == true and Esp.Settings.Boxes == true and Distance <= Esp.Settings.RenderDistance then
                if Esp.Settings.TeamCheck == true and TeamTag == false then 
                    v.BoxOutline.Visible = Esp.Settings.BoxesOutline;v.Box.Visible = true
                elseif Esp.Settings.TeamCheck == true and TeamTag == true then
                    v.BoxOutline.Visible = false;v.Box.Visible = false
                else
                    v.BoxOutline.Visible = Esp.Settings.BoxesOutline;v.Box.Visible = true
                end
                if Esp.Settings.TargetSleepers == true and sleeping == true then
                    v.BoxOutline.Visible = false;v.Box.Visible = false
                end
                v.BoxOutline.Position = Vector2.new(BoxPosX,BoxPosY);v.BoxOutline.Size = Vector2.new(w,h)
                v.Box.Position = Vector2.new(BoxPosX,BoxPosY);v.Box.Size = Vector2.new(w,h)
                v.Box.Color = Esp.Settings.BoxesColor;v.BoxOutline.Color = Esp.Settings.BoxesOutlineColor
            else
                v.BoxOutline.Visible = false;v.Box.Visible = false
            end
            if OnScreen == true and Esp.Settings.Sleeping == true and Distance <= Esp.Settings.RenderDistance then
                if sleeping == true then v.Sleeping.Text = "Sleeping" else v.Sleeping.Text = "Awake" end
                if Esp.Settings.TeamCheck == true and TeamTag == false then
                    v.Sleeping.Visible = true
                elseif Esp.Settings.TeamCheck == true and TeamTag == true then
                    v.Sleeping.Visible = false
                end
                if Esp.Settings.TargetSleepers == true and sleeping == true then v.Sleeping.Visible = false end

                v.Sleeping.Outline=Esp.Settings.TextOutline;v.Sleeping.Color=Esp.Settings.SleepingColor;v.Sleeping.Size=math.max(math.min(math.abs(Esp.Settings.TextSize*scale),Esp.Settings.TextSize),Esp.Settings.MinTextSize);v.Sleeping.Color = Esp.Settings.SleepingColor;v.Sleeping.Font=Esp.Settings.TextFont;v.Sleeping.Position = Vector2.new(x,math.floor(y-h*0.5-v.Sleeping.TextBounds.Y))
            else
                v.Sleeping.Visible=false
            end
            if OnScreen == true and Esp.Settings.Distances == true and Distance <= Esp.Settings.RenderDistance then
                if Esp.Settings.TeamCheck == true and TeamTag == false then
                    v.Distance.Visible = true
                elseif Esp.Settings.TeamCheck == true and TeamTag == true then
                    v.Distance.Visible = false
                end
                if Esp.Settings.TargetSleepers == true and sleeping == true then v.Distance.Visible = false end

                if Esp.Settings.Sleeping == false then
                    v.Distance.Text = math.floor(Distance).."s"
                else
                    v.Distance.Text = math.floor(Distance).."s"
                end
                v.Distance.Outline=Esp.Settings.TextOutline;v.Distance.Color=Esp.Settings.SleepingColor;v.Distance.Size=math.max(math.min(math.abs(Esp.Settings.TextSize*scale),Esp.Settings.TextSize),Esp.Settings.MinTextSize);v.Distance.Color = Esp.Settings.DistanceColor;v.Distance.Font=Esp.Settings.TextFont;v.Distance.Position = Vector2.new(x,math.floor(y+h*.5))
            else
                v.Distance.Visible = false
            end
            if OnScreen == true and Esp.Settings.Armour == true and Distance <= Esp.Settings.RenderDistance then
                if Character.Armor:FindFirstChildOfClass("Folder") then v.Armour.Text = "Danger" else v.Armour.Text = " " end
                if Esp.Settings.TeamCheck == true and TeamTag == false then v.Armour.Visible = true elseif Esp.Settings.TeamCheck == true and TeamTag == true then v.Armour.Visible = false else v.Armour.Visible = true end
                if Esp.Settings.TargetSleepers == true and sleeping == true then v.Armour.Visible = false end
                v.Armour.Outline=Esp.Settings.TextOutline;v.Armour.Size = math.max(math.min(math.abs(Esp.Settings.TextSize*scale),Esp.Settings.TextSize),Esp.Settings.MinTextSize);
                v.Armour.Position=Vector2.new(math.floor((BoxPosX+w)+v.Armour.TextBounds.X/10),BoxPosY+v.Armour.TextBounds.Y*1.55*0.5-((v.Armour.TextBounds.Y*2)*0.5));
                v.Armour.Color = Esp.Settings.ArmourColor;v.Armour.Font=Esp.Settings.TextFont
            else
                v.Armour.Visible = false
            end
            if OnScreen == true and Esp.Settings.ViewAngle == true and Distance <= Esp.Settings.RenderDistance then
                if Esp.Settings.TeamCheck == true and TeamTag == false then v.ViewAngle.Visible = true elseif Esp.Settings.TeamCheck == true and TeamTag == true then v.ViewAngle.Visible = false else v.ViewAngle.Visible = true end
                if Esp.Settings.TargetSleepers == true and sleeping == true then v.ViewAngle.Visible = false end
                v.ViewAngle.Color = Esp.Settings.ViewAngleColor;v.ViewAngle.Thickness=Esp.Settings.ViewAngleThickness;v.Transparency=Esp.Settings.ViewAngleTransparrency;
                local headpos = Camera:WorldToViewportPoint(Character.Head.Position)
                local offsetCFrame = CFrame.new(0, 0, -4)
                v.ViewAngle.From = Vector2.new(headpos.X, headpos.Y)
                local value = math.clamp(1/Distance*100, 0.1, 1)
                local dir = Character.Head.CFrame:ToWorldSpace(offsetCFrame)
                offsetCFrame = offsetCFrame * CFrame.new(0, 0, 0.4)
                local dirpos = Camera:WorldToViewportPoint(Vector3.new(dir.X, dir.Y, dir.Z))
                if OnScreen == true then
                    v.ViewAngle.To = Vector2.new(dirpos.X, dirpos.Y)
                    offsetCFrame = CFrame.new(0, 0, -4)
                end
            else
                v.ViewAngle.Visible = false
            end
        else
            v.Box.Visible=false;v.BoxOutline.Visible=false;v.Armour.Visible=false;v.Distance.Visible=false;v.ViewAngle.Visible=false;v.Sleeping.Visible=false;
        end
    end
end

--Connections
local PlayerUpdater = game:GetService("RunService").RenderStepped
local PlayerConnection = PlayerUpdater:Connect(function()
    Esp:UpdateEsp()
end)

--Init Functions
for i,v in pairs(workspace:GetChildren()) do
	if v:FindFirstChild("HumanoidRootPart") then
        table.insert(cache,v)
        Esp:CreateEsp({model=v})
	end
end

game:GetService("Workspace").ChildAdded:Connect(function(child)
    if child:FindFirstChild("HumanoidRootPart") and not table.find(cache,child) then
        table.insert(cache,child)
        Esp:CreateEsp({model=child})
    end
end)

local PlayerVisualTabbox = Tabs.Visual:AddLeftTabbox()
local PlayerVisualTab = PlayerVisualTabbox:AddTab('Players')
local PlayerSettingsVisualTab = PlayerVisualTabbox:AddTab('Settings')

PlayerVisualTab:AddToggle('Boxes',{Text='Boxes',Default=true}):AddColorPicker('BoxesColor',{Default=Color3.fromRGB(34,255,7),Title='Color'}):AddColorPicker('BoxesOutlineColor',{Default=Color3.fromRGB(0,0,0),Title='Color'})
PlayerVisualTab:AddToggle('Distances',{Text='Distance',Default=true}):AddColorPicker('DistancesColor',{Default=Color3.fromRGB(255,255,255),Title='Color'})
PlayerVisualTab:AddToggle('Sleeping',{Text='Sleeping',Default=false}):AddColorPicker('SleepingColor',{Default=Color3.fromRGB(255,255,255),Title='Color'})
PlayerVisualTab:AddToggle('Armour',{Text='Armour',Default=true}):AddColorPicker('ArmourColor',{Default=Color3.fromRGB(34,255,7),Title='Color'})
PlayerVisualTab:AddToggle('ViewAngle',{Text='View Angle',Default=true}):AddColorPicker('ViewAngleColor',{Default=Color3.fromRGB(255,255,255),Title='Color'})

--Esp Switches
Toggles.ViewAngle:OnChanged(function(Value)
    Esp.Settings.ViewAngle = Value
end)
Options.ViewAngleColor:OnChanged(function(Value)
    Esp.Settings.ViewAngleColor = Value
end)
Toggles.Armour:OnChanged(function(Value)
    Esp.Settings.Armour = Value
end)
Options.ArmourColor:OnChanged(function(Value)
    Esp.Settings.ArmourColor = Value
end)
Toggles.Armour:OnChanged(function(Value)
    Esp.Settings.Armour = Value
end)
Toggles.Distances:OnChanged(function(Value)
    Esp.Settings.Distances = Value
end)
Options.DistancesColor:OnChanged(function(Value)
    Esp.Settings.DistanceColor = Value
end)
Options.BoxesColor:OnChanged(function(Value)
    Esp.Settings.BoxesColor = Value
end)
Options.BoxesOutlineColor:OnChanged(function(Value)
    Esp.Settings.BoxesOutlineColor = Value
end)
Toggles.Boxes:OnChanged(function(Value)
    Esp.Settings.Boxes = Value
end)
Options.SleepingColor:OnChanged(function(Value)
    Esp.Settings.SleepingColor = Value
end)
Toggles.Sleeping:OnChanged(function(Value)
    Esp.Settings.Sleeping = Value
end)
PlayerSettingsVisualTab:AddSlider('RenderDistance', {Text='Render Distance',Default=1500,Min=1,Max=1500,Rounding=0,Compact=false,Suffix="s"}):OnChanged(function(Value)
    Esp.Settings.RenderDistance = Value
end)
PlayerSettingsVisualTab:AddToggle('TargetSleepers',{Text='Dont Show Sleepers',Default=true}):OnChanged(function(Value)
    Esp.Settings.TargetSleepers = Value
end)
PlayerSettingsVisualTab:AddToggle('BoxesOutlines',{Text='Box Outlines',Default=false}):OnChanged(function(Value)
    Esp.Settings.BoxesOutline = Value
end)
PlayerSettingsVisualTab:AddToggle('TeamCheck',{Text='Team Check',Default=true}):OnChanged(function(Value)
    Esp.Settings.TeamCheck = Value
end)
PlayerSettingsVisualTab:AddToggle('TextOutline',{Text='Text Outlines',Default=false}):OnChanged(function(Value)
    Esp.Settings.TextOutline = Value
end)

local HeadHitboxTabBox = Tabs.Main:AddLeftTabbox()
local HeadHitboxTab = HeadHitboxTabBox:AddTab('Hitbox')

local antihitbox
antihitbox = hookmetamethod(game, "__newindex", newcclosure(function(...)
    local self, k = ...
    if not checkcaller() and k == "Size" and self.Name == "Head" then
        return Vector3.new(1.672248125076294, 0.835624098777771, 0.835624098777771)
    end
    return antihitbox(...)
end))

local HitBX = 2
local HitBY = 2
local HitBZ = 2

HeadHitboxTab:AddToggle('EnabledHB', { Text = 'Enabled', Default = false, Tooltip = nil, })
Toggles.EnabledHB:OnChanged(function(EnabledHBB)
    if EnabledHBB == true then
        for v, i in pairs(workspace:GetChildren()) do
            if i:FindFirstChild("HumanoidRootPart") then
                i.Head.Size = Vector3.new(HitBX, HitBY, HitBZ)
            end
        end
        game.ReplicatedStorage.Player.Head.Size = Vector3.new(HitBX, HitBY, HitBZ)
    elseif EnabledHBB == false then
        for v, i in pairs(workspace:GetChildren()) do
            if i:FindFirstChild("HumanoidRootPart") then
                i.Head.Size = Vector3.new(1.672248125076294, 0.835624098777771, 0.835624098777771)
            end
        end
        game.ReplicatedStorage.Player.Head.Size = Vector3.new(1.672248125076294, 0.835624098777771, 0.835624098777771)
    end
end)

HeadHitboxTab:AddSlider('HitboxXSize_Slider', {Text = 'X-Size', Default = 2, Min = 0, Max = 4, Rounding = 2, Suffix = "%", Compact = false}):OnChanged(function(HitboxXSize)
    HitBX = HitboxXSize
end)

HeadHitboxTab:AddSlider('HitboxYSize_Slider', {Text = 'Y-Size', Default = 2, Min = 0, Max = 4, Rounding = 2, Suffix = "%", Compact = false}):OnChanged(function(HitboxYSize)
    HitBY = HitboxYSize
end)

HeadHitboxTab:AddSlider('HitboxZSize_Slider', {Text = 'Z-Size', Default = 2, Min = 0, Max = 4, Rounding = 2, Suffix = "%", Compact = false}):OnChanged(function(HitboxZSize)
    HitBZ = HitboxZSize
end)

Library:SetWatermarkVisibility(true)
local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;
local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1;

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter;
        FrameTimer = tick();
        FrameCounter = 0;
    end;

    Library:SetWatermark(('SKIDDED [No Actor] | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);

Library.KeybindFrame.Visible = true;

Library:OnUnload(function()
    WatermarkConnection:Disconnect()
    for i,v in pairs(Toggles) do
        v:SetValue(false)
    end
    PlayerConnection:Disconnect()
    Library.Unloaded = true
end)

local MenuGroup = Tabs['Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('Swag')
SaveManager:SetFolder('Build')
SaveManager:BuildConfigSection(Tabs['Settings'])
ThemeManager:ApplyToTab(Tabs['Settings'])
SaveManager:LoadAutoloadConfig()

Library:Notify("Status: Undetected 🟩",8)
