print("Float.balls Loading\n")

--Locals
local oldTick = tick()
local Camera = game:GetService("Workspace").CurrentCamera
local CharcaterMiddle = game:GetService("Workspace").Ignore.LocalCharacter.Middle
local Mouse = game.Players.LocalPlayer:GetMouse()
local NoSway = false
local Sky = game:GetService("Lighting"):FindFirstChildOfClass("Sky")
if not Sky then Sky = Instance.new("Sky",Lighting) end

--Tables
local Functions = {}
local Esp = {Settings={
    Boxes=true,BoxesOutline=true,BoxesColor=Color3.fromRGB(255,255,255),BoxesOutlineColor=Color3.fromRGB(0,0,0),
    Sleeping=false,SleepingColor=Color3.fromRGB(255,255,255),
    Distances=false,DistanceColor=Color3.fromRGB(255,255,255),
    Armour=false,ArmourColor=Color3.fromRGB(255,255,255),
    Tool=false,ToolColor=Color3.fromRGB(255,255,255),
    Tracer=false,TracerColor=Color3.fromRGB(255,255,255),TracerThickness=1,TracerTransparrency=1,TracerFrom="Bottom",
    ViewAngle=false,ViewAngleColor=Color3.fromRGB(255,255,255),ViewAngleThickness=1,ViewAngleTransparrency=1,
    OreDistances=false,OreDistanceColor=Color3.fromRGB(255,255,255),
    OreNames=false,OreNamesColor=Color3.fromRGB(255,255,255),
    OresRenderDistance=1500,
    TextFont=2,TextOutline=true,TextSize=15,RenderDistance=1500,TeamCheck=false,TargetSleepers=false,MinTextSize=8
},Drawings={},Connections={},Players={},Ores={},StorageThings={}}
local Fonts = {["UI"]=0,["System"]=1,["Plex"]=2,["Monospace"]=3}
local Fov = {Settings={
    FovEnabled=false,FovColor=Color3.fromRGB(255,255,255),FovSize=90,FovFilled=false,FovTransparency=1,OutlineFovColor=Color3.fromRGB(0,0,0),Dynamic=true,RealFovSize=90,FovPosition="Mouse",
    Snapline=false,SnaplineColor=Color3.fromRGB(255,255,255)
}}
local Combat = {Settings={
    SilentEnabled=false,SilentHitChance=100,SilentAimPart="Head",TeamCheck=true,SleeperCheck=true,
}}
local Misc = {Settings={
    SpeedHackEnabled=false,SpeedHackSpeed=30,
}}
local cache,OreCache = {},{}
local AllowedOres,AllowedItems = {"StoneOre","NitrateOre","IronOre"},{"PartsBox","MilitaryCrate","SnallBox","SnallBox","Backpack","VendingMachine"}
local SkyBoxes = {
    ["Standard"] = {["SkyboxBk"] = Sky.SkyboxBk,["SkyboxDn"] = Sky.SkyboxDn,["SkyboxFt"] = Sky.SkyboxFt,["SkyboxLf"] = Sky.SkyboxLf,["SkyboxRt"] = Sky.SkyboxRt,["SkyboxUp"] = Sky.SkyboxUp,},
    ["Among Us"] = {["SkyboxBk"] = "rbxassetid://5752463190",["SkyboxDn"] = "rbxassetid://5752463190",["SkyboxFt"] = "rbxassetid://5752463190",["SkyboxLf"] = "rbxassetid://5752463190",["SkyboxRt"] = "rbxassetid://5752463190",["SkyboxUp"] = "rbxassetid://5752463190"},
    ["Spongebob"] = {["SkyboxBk"]="rbxassetid://277099484",["SkyboxDn"]="rbxassetid://277099500",["SkyboxFt"]="rbxassetid://277099554",["SkyboxLf"]="rbxassetid://277099531",["SkyboxRt"]="rbxassetid://277099589",["SkyboxUp"]="rbxassetid://277101591"},
    ["Deep Space"] = {["SkyboxBk"]="rbxassetid://159248188",["SkyboxDn"]="rbxassetid://159248183",["SkyboxFt"]="rbxassetid://159248187",["SkyboxLf"]="rbxassetid://159248173",["SkyboxRt"]="rbxassetid://159248192",["SkyboxUp"]="rbxassetid://159248176"},
    ["Winter"] = {["SkyboxBk"]="rbxassetid://510645155",["SkyboxDn"]="rbxassetid://510645130",["SkyboxFt"]="rbxassetid://510645179",["SkyboxLf"]="rbxassetid://510645117",["SkyboxRt"]="rbxassetid://510645146",["SkyboxUp"]="rbxassetid://510645195"},
    ["Clouded Sky"] = {["SkyboxBk"]="rbxassetid://252760981",["SkyboxDn"]="rbxassetid://252763035",["SkyboxFt"]="rbxassetid://252761439",["SkyboxLf"]="rbxassetid://252760980",["SkyboxRt"]="rbxassetid://252760986",["SkyboxUp"]="rbxassetid://252762652"},
    --["test"] = {"SkyboxBk"="rbxassetid://","SkyboxDn"="rbxassetid://","SkyboxFt"="rbxassetid://","SkyboxLf"="rbxassetid://","SkyboxRt"="rbxassetid://","SkyboxUp"="rbxassetid://"},
}

--Functions
function Functions:GetBarrel()
    if game:GetService("Workspace").Ignore.FPSArms:FindFirstChild("HandModel") then
        if game:GetService("Workspace").Ignore.FPSArms.HandModel:FindFirstChild("ADS",true) then
            return game:GetService("Workspace").Ignore.FPSArms.HandModel:FindFirstChild("ADS",true)
        end
    end
end
function Functions:GetClosest()
    local closest,PlayerDistance,playerTable = nil,Esp.Settings.RenderDistance,nil
    for i,v in pairs(getupvalues(getrenv()._G.modules.Player.GetPlayerModel)[1]) do
        if v.model:FindFirstChild("HumanoidRootPart") then
            local Mouse = game.Players.LocalPlayer:GetMouse()
            local pos,OnScreen = Camera.WorldToViewportPoint(Camera, v.model:GetPivot().Position)
            local MouseMagnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            local PlayerDistance = (CharcaterMiddle:GetPivot().Position-v.model:GetPivot().Position).Magnitude
            if MouseMagnitude < Fov.Settings.RealFovSize and PlayerDistance <= Esp.Settings.RenderDistance and OnScreen == true then
                closest = v.model;PlayerDistance = PlayerDistance;playerTable=v
            end
        end
    end
    return closest,playerTable
end
function Functions:GetProjectileInfo()
    if getrenv()._G.modules.FPS.GetEquippedItem() == nil then return 0,0 end
    local mod = require(game:GetService("ReplicatedStorage").ItemConfigs[getrenv()._G.modules.FPS.GetEquippedItem().id])
    for i,v in pairs(mod) do
        if i == "ProjectileSpeed" or i == "ProjectileDrop" then
            return mod.ProjectileSpeed,mod.ProjectileDrop
        end
    end
    return 0,0
end
function Functions:Predict()
    local Prediction = Vector3.new(0,0,0)
    local Drop = Vector3.new(0,0,0)
    if Functions:GetClosest() ~= nil then
        local ps,pd = Functions:GetProjectileInfo()
        local Player,PlayerTable = Functions:GetClosest()
		local Velocity = PlayerTable.velocityVector
        local Distance = (CharcaterMiddle.Position - Player[Combat.Settings.SilentAimPart].Position).Magnitude
        if ps == 0 then
            ps = 500
        end
        if pd == 0 then
            pd = 1
        end
        local TimeOfFlight = Distance / ps
        newps = ps - 13 * ps ^ 2 * TimeOfFlight ^ 2
        TimeOfFlight += (Distance / newps)
        if Velocity and TimeOfFlight then
            Prediction = (Velocity * (TimeOfFlight*10)) * .5
        end
    end
    return Prediction,Drop
end
function Functions:ItemToColor(Item)
    table = {}
    table["PartsBox"] = Color3.new(0.929,0.973,0.796)
    table["MilitaryCrate"] = Color3.new(0.075,0.353,0.086)
    table["SnallBox"] = Color3.new(0.263,0.200,0.075)
    table["MediumBox"] = Color3.new(0.404,0.302,0.094)
    table["Backpack"] = Color3.new(0.404,0.302,0.094)
    table["VendingMachine"] = Color3.new(0.192,0.478,0.988)
    table["StoneOre"] = Color3.new(0.612,0.612,0.612)
    table["IronOre"] = Color3.new(0.773,0.686,0.365)
    table["NitrateOre"] = Color3.new(1,1,1)
    return table[Item]
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
function Functions:GetToolNames()
    tbl = {}
    for i,v in pairs(game:GetService("ReplicatedStorage").HandModels:GetChildren()) do
        if not table.find(tbl,v.Name) then table.insert(tbl,v.Name) end
    end
    return tbl
end
function Esp:CheckTools(PlayerTable)
    if not PlayerTable then return end
    if PlayerTable.equippedItem and table.find(Functions:GetToolNames(),PlayerTable["equippedItem"].id) then
        return tostring(PlayerTable["equippedItem"].id)
    elseif PlayerTable.handModel and PlayerTable.handModel.Name and string.find(PlayerTable.handModel.Name,"Hammer") then
        return PlayerTable["handModel"].Name
    else
        return "Empty"
    end
end
function Esp:CreateOreEsp(ItemTable)
    local drawings = {}
    drawings.Names = Functions:Draw("Text",{Text = "Nil",Font=Esp.Settings.TextFont,Size=Esp.Settings.TextSize,Center=true,Outline=Esp.Settings.TextOutline,Color = Esp.Settings.OreNamesColor,ZIndex = 2,Visible=false})
    drawings.Distance = Functions:Draw("Text",{Text = "Nil",Font=Esp.Settings.TextFont,Size=Esp.Settings.TextSize,Center=true,Outline=Esp.Settings.TextOutline,Color = Esp.Settings.OreDistanceColor,ZIndex = 2,Visible=false})
    Esp.Ores[ItemTable] = drawings
end
function Esp:CreateEsp(PlayerTable)
    if not PlayerTable then return end
    local drawings = {}
    drawings.BoxOutline = Functions:Draw("Square",{Thickness=2,Filled=false,Transparency=1,Color=Esp.Settings.BoxesOutlineColor,Visible=false,ZIndex = -1,Visible=false});
    drawings.Box = Functions:Draw("Square",{Thickness=1,Filled=false,Transparency=1,Color=Esp.Settings.BoxesColor,Visible=false,ZIndex = 2,Visible=false});
    drawings.Sleeping = Functions:Draw("Text",{Text = "Nil",Font=Esp.Settings.TextFont,Size=Esp.Settings.TextSize,Center=true,Outline=Esp.Settings.TextOutline,Color = Esp.Settings.SleepingColor,ZIndex = 2,Visible=false})
    drawings.Armour = Functions:Draw("Text",{Text = "Naked",Font=Esp.Settings.TextFont,Size=Esp.Settings.TextSize,Center=false,Outline=Esp.Settings.TextOutline,Color = Esp.Settings.ArmourColor,ZIndex = 2,Visible=false})
    drawings.Tool = Functions:Draw("Text",{Text = "Nothing",Font=Esp.Settings.TextFont,Size=Esp.Settings.TextSize,Center=false,Outline=Esp.Settings.TextOutline,Color = Esp.Settings.ToolColor,ZIndex = 2,Visible=false})
    drawings.ViewAngle = Functions:Draw("Line",{Thickness=Esp.Settings.ViewAngleThickness,Transparency=Esp.Settings.ViewAngleTransparrency,Color=Esp.Settings.ViewAngleColor,ZIndex=2,Visible=false})
    drawings.Tracer = Functions:Draw("Line",{Thickness=Esp.Settings.TracerThickness,Transparency=1,Color=Esp.Settings.TracerColor,ZIndex=2,Visible=false})
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
function Esp:UpdateOreEsp()
    for i,v in pairs(Esp.Ores) do
        local OreModel = i.model
        local Position,OnScreen = Camera:WorldToViewportPoint(OreModel:GetPivot().Position);
        local scale = 1 / (Position.Z * math.tan(math.rad(Camera.FieldOfView * 0.5)) * 2) * 100;
        local Distance = (CharcaterMiddle:GetPivot().Position-OreModel:GetPivot().Position).Magnitude

        if OreModel and OnScreen == true and Esp.Settings.OreNames == true and Distance <= Esp.Settings.OresRenderDistance then
            v.Names.Text=i.typ;
            v.Names.Outline=Esp.Settings.TextOutline;
            v.Names.Color=Functions:ItemToColor(i.typ);
            v.Names.Size=math.max(math.min(math.abs(Esp.Settings.TextSize*scale),Esp.Settings.TextSize),Esp.Settings.MinTextSize);
            v.Names.Font=Esp.Settings.TextFont;
            v.Names.Position = Vector2.new(Position.X,Position.Y);
            v.Names.Visible = true
        else
            v.Names.Visible = false
        end
        if OreModel and OnScreen == true and Esp.Settings.OreDistances == true and Distance <= Esp.Settings.OresRenderDistance then
            v.Distance.Text="[ "..math.floor(Distance).." ]";v.Distance.Outline=Esp.Settings.TextOutline;v.Distance.Color=Functions:ItemToColor(i.typ);v.Distance.Size=math.max(math.min(math.abs(Esp.Settings.TextSize*scale),Esp.Settings.TextSize),Esp.Settings.MinTextSize);v.Distance.Font=Esp.Settings.TextFont;v.Distance.Position = Vector2.new(Position.X,Position.Y-v.Distance.TextBounds.Y);v.Distance.Visible = true
        else
            v.Distance.Visible = false
        end
    end
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
                if Esp.Settings.TargetSleepers == true and v.PlayerTable.sleeping == true then
                    v.BoxOutline.Visible = false;v.Box.Visible = false
                end
                v.BoxOutline.Position = Vector2.new(BoxPosX,BoxPosY);v.BoxOutline.Size = Vector2.new(w,h)
                v.Box.Position = Vector2.new(BoxPosX,BoxPosY);v.Box.Size = Vector2.new(w,h)
                v.Box.Color = Esp.Settings.BoxesColor;v.BoxOutline.Color = Esp.Settings.BoxesOutlineColor
            else
                v.BoxOutline.Visible = false;v.Box.Visible = false
            end
            if OnScreen == true and Esp.Settings.Sleeping == true and Distance <= Esp.Settings.RenderDistance then
                if v.PlayerTable.sleeping == true then v.Sleeping.Text = "Sleeping" else v.Sleeping.Text = "Awake" end
                if Esp.Settings.TeamCheck == true and TeamTag == false then  v.Sleeping.Visible = true elseif Esp.Settings.TeamCheck == true and TeamTag == true then v.Sleeping.Visible = false else v.Sleeping.Visible = true end
                if Esp.Settings.TargetSleepers == true and v.PlayerTable.sleeping == true then v.Sleeping.Visible = false end
                v.Sleeping.Outline=Esp.Settings.TextOutline;v.Sleeping.Color=Esp.Settings.SleepingColor;v.Sleeping.Size=math.max(math.min(math.abs(Esp.Settings.TextSize*scale),Esp.Settings.TextSize),Esp.Settings.MinTextSize);v.Sleeping.Color = Esp.Settings.SleepingColor;v.Sleeping.Font=Esp.Settings.TextFont;v.Sleeping.Position = Vector2.new(x,math.floor(y-h*0.5-v.Sleeping.TextBounds.Y))
            else
                v.Sleeping.Visible=false
            end
            if OnScreen == true and Esp.Settings.Distances == true and Distance <= Esp.Settings.RenderDistance then
                if Esp.Settings.TeamCheck == true and TeamTag == false then  v.Sleeping.Visible = true elseif Esp.Settings.TeamCheck == true and TeamTag == true then v.Sleeping.Visible = false else v.Sleeping.Visible = true end
                if Esp.Settings.TargetSleepers == true and v.PlayerTable.sleeping == true then v.Sleeping.Visible = false end

                if Esp.Settings.Sleeping == false then
                    v.Sleeping.Text = math.floor(Distance).."s"
                else
                    v.Sleeping.Text = v.Sleeping.Text.." | "..math.floor(Distance).."s"
                end
                v.Sleeping.Outline=Esp.Settings.TextOutline;v.Sleeping.Color=Esp.Settings.SleepingColor;v.Sleeping.Size=math.max(math.min(math.abs(Esp.Settings.TextSize*scale),Esp.Settings.TextSize),Esp.Settings.MinTextSize);v.Sleeping.Color = Esp.Settings.SleepingColor;v.Sleeping.Font=Esp.Settings.TextFont;v.Sleeping.Position = Vector2.new(x,math.floor(y-h*0.5-v.Sleeping.TextBounds.Y))
            else
                v.Sleeping.Visible = false
            end
            if OnScreen == true and Esp.Settings.Tool == true and Distance <= Esp.Settings.RenderDistance then
                if Esp.Settings.TeamCheck == true and TeamTag == false then v.Tool.Visible = true elseif Esp.Settings.TeamCheck == true and TeamTag == true then v.Tool.Visible = false else v.Tool.Visible = true end
                if Esp.Settings.TargetSleepers == true and v.PlayerTable.sleeping == true then v.Tool.Visible = false end
                v.Tool.Position = Vector2.new(math.floor((BoxPosX+w)+v.Tool.TextBounds.X/10),BoxPosY+v.Tool.TextBounds.Y*1.55*0.5-((v.Tool.TextBounds.Y*2)*0.5)+v.Tool.TextBounds.Y)
                v.Tool.Text=Esp:CheckTools(v.PlayerTable);v.Tool.Outline=Esp.Settings.TextOutline;v.Tool.Size=math.max(math.min(math.abs(Esp.Settings.TextSize*scale),Esp.Settings.TextSize),Esp.Settings.MinTextSize);v.Tool.Color=Esp.Settings.ToolColor;v.Tool.Font=Esp.Settings.TextFont
            else
                v.Tool.Visible = false
            end
            if OnScreen == true and Esp.Settings.Armour == true and Distance <= Esp.Settings.RenderDistance then
                if Character.Armor:FindFirstChildOfClass("Folder") then v.Armour.Text = "Armoured" else v.Armour.Text = "Naked" end
                if Esp.Settings.TeamCheck == true and TeamTag == false then v.Armour.Visible = true elseif Esp.Settings.TeamCheck == true and TeamTag == true then v.Armour.Visible = false else v.Armour.Visible = true end
                if Esp.Settings.TargetSleepers == true and v.PlayerTable.sleeping == true then v.Armour.Visible = false end
                v.Armour.Outline=Esp.Settings.TextOutline;v.Armour.Size = math.max(math.min(math.abs(Esp.Settings.TextSize*scale),Esp.Settings.TextSize),Esp.Settings.MinTextSize);
                v.Armour.Position=Vector2.new(math.floor((BoxPosX+w)+v.Armour.TextBounds.X/10),BoxPosY+v.Armour.TextBounds.Y*1.55*0.5-((v.Armour.TextBounds.Y*2)*0.5));
                v.Armour.Color = Esp.Settings.ArmourColor;v.Armour.Font=Esp.Settings.TextFont
            else
                v.Armour.Visible = false
            end
            if OnScreen == true and Esp.Settings.Tracer == true and Distance <= Esp.Settings.RenderDistance then
                if Esp.Settings.TeamCheck == true and TeamTag == false then v.Tracer.Visible = true elseif Esp.Settings.TeamCheck == true and TeamTag == true then v.Tracer.Visible = false else v.Tracer.Visible = true end
                if Esp.Settings.TargetSleepers == true and v.PlayerTable.sleeping == true then v.Tracer.Visible = false end
                v.Tracer.Color = Esp.Settings.TracerColor;v.Tracer.Thickness=Esp.Settings.TracerThickness;v.Transparency=Esp.Settings.TracerTransparrency;
                if Esp.Settings.TracerFrom == "Bottom" then
                    v.Tracer.From = Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y)
                    v.Tracer.To = Vector2.new(x,y+h*0.5)
                elseif Esp.Settings.TracerFrom == "Middle" then
                    v.Tracer.From = Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
                    v.Tracer.To = Vector2.new(x,y)
                else
                    v.Tracer.From = Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/Camera.ViewportSize.Y)
                    if Esp.Settings.Sleeping == true then
                        v.Tracer.To = Vector2.new(x,(y-h)-v.Sleeping.TextBounds.Y*0.5)
                    else
                        v.Tracer.To = Vector2.new(x,y-h*0.5)
                    end
                end
            else
                v.Tracer.Visible = false
            end
            if OnScreen == true and Esp.Settings.ViewAngle == true and Distance <= Esp.Settings.RenderDistance then
                if Esp.Settings.TeamCheck == true and TeamTag == false then v.ViewAngle.Visible = true elseif Esp.Settings.TeamCheck == true and TeamTag == true then v.ViewAngle.Visible = false else v.ViewAngle.Visible = true end
                if Esp.Settings.TargetSleepers == true and v.PlayerTable.sleeping == true then v.ViewAngle.Visible = false end
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
            v.Box.Visible=false;v.BoxOutline.Visible=false;v.Tool.Visible=false;v.Armour.Visible=false;v.Sleeping.Visible=false;v.ViewAngle.Visible=false;v.Tracer.Visible=false;
        end
    end
end


--Drawings
local FovCircle = Functions:Draw("Circle",{Filled=Fov.Settings.FovFilled,Color=Fov.Settings.FovColor,Radius=Fov.Settings.FovSize,NumSides=90,Thickness=1,Transparency=Fov.Settings.FovTransparency,ZIndex=2,Visible=false})
local FovSnapline = Functions:Draw("Line",{Transparency=1,Thickness=1,Visible=false})

--Connections
local PlayerUpdater = game:GetService("RunService").RenderStepped
local PlayerConnection = PlayerUpdater:Connect(function()
    Esp:UpdateEsp()
end)
--[[
local OreUpdater = game:GetService("RunService").RenderStepped
local OreConnection = OreUpdater:Connect(function()
    Esp:UpdateOreEsp()
end)
]]
--Init Functions
for i, v in pairs(getupvalues(getrenv()._G.modules.Player.GetPlayerModel)[1]) do
    if not table.find(cache,v) then
        table.insert(cache,v)
        Esp:CreateEsp(v)
    end
end

--[[
for i,v in pairs(getrenv()._G.modules.Entity.List) do
    if table.find(AllowedOres,v.typ) and not table.find(OreCache,v) then
        table.insert(OreCache,v)
        Esp:CreateOreEsp(v)
    end
end

local oldOreHook;oldOreHook = hookfunction(getrenv()._G.modules.Entity.BulkLoad,function(...)
    for i,v in pairs(getrenv()._G.modules.Entity.List) do
        if table.find(AllowedOres,v.typ) and not table.find(OreCache,v) then
            table.insert(OreCache,v)
            Esp:CreateOreEsp(v)
        end
    end
    return oldOreHook(...)
end)
]]

game:GetService("Workspace").ChildAdded:Connect(function(child)
    if child:FindFirstChild("HumanoidRootPart") then
        for i, v in pairs(getupvalues(getrenv()._G.modules.Player.GetPlayerModel)[1]) do
            if not table.find(cache,v) then
                Esp:CreateEsp(v)
                table.insert(cache,v)
            end
        end
    end
end)
game:GetService("Workspace").ChildAdded:Connect(function(child)
    if child:FindFirstChild("Leaves") then
        Functions:ToggleLeaves(Misc.Settings.LeavesTrans)
    end
end)

--UI
local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/VertigoCool99/LoadScript/main/FloatManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({Title = 'Float.balls | Free',Center = true, AutoShow = true})
Library:SetWatermark('Float.balls | Free')
Library:OnUnload(function() 
    Library.Unloaded = true
    for i,v in pairs(Toggles) do
        v:SetValue(false)
    end
    PlayerConnection:Disconnect()
end)

local Tabs = {Combat = Window:AddTab('Combat'),Visual = Window:AddTab('Visual'),Misc=Window:AddTab('Miscellaneous'),['UI Settings'] = Window:AddTab('UI Settings'),}

local SilentTabbox = Tabs.Combat:AddLeftTabbox()
local SilentTab = SilentTabbox:AddTab('Silent Aim')
local FovTabbox = Tabs.Combat:AddRightTabbox()
local FovTab = FovTabbox:AddTab('Fov')
local GunModsTabbox = Tabs.Combat:AddRightTabbox()
local GunModsTab = GunModsTabbox:AddTab('Modifications')

SilentTab:AddToggle('SilentAim',{Text='Enabled',Default=true}):AddKeyPicker('SilentKey', {Default='MB2',SyncToggleState=true,Mode='Hold',Text='Silent Aim',NoUI=false}):OnChanged(function(Value)
    Combat.Settings.SilentEnabled = Value
end)
SilentTab:AddToggle('TeamCheck',{Text='Team Check',Default=true}):OnChanged(function(Value)
    Combat.Settings.TeamCheck = Value
end)
SilentTab:AddToggle('SleeperCheck',{Text='Sleeper Check',Default=true}):OnChanged(function(Value)
    Combat.Settings.SleeperCheck = Value
end)
SilentTab:AddSlider('HitChance', {Text='Hit Chance',Default=100,Min=0,Max=100,Rounding=0,Compact=false,Suffix="%"}):OnChanged(function(Value)
    Combat.Settings.SilentHitChance = Value
end)
SilentTab:AddDropdown('SilentHitpart', {Values = {"Head","HumanoidRootPart","Torso"},Default = 1,Multi = false,Text = 'Hitpart'}):OnChanged(function(Value)
    Combat.Settings.SilentAimPart = Value
end)

FovTab:AddToggle('Fov',{Text='Fov',Default=false}):AddColorPicker('FovColor',{Default=Color3.fromRGB(0,255,239),Title='Color'})
FovTab:AddToggle('Dynamic',{Text='Dynamic',Default=true})
FovTab:AddSlider('FovSize', {Text='Size',Default=90,Min=5,Max=500,Rounding=0,Compact=false}):OnChanged(function(Value)
    Fov.Settings.FovSize = Value;FovCircle.Radius = Value
end)
FovTab:AddToggle('Snapline',{Text='Snapline',Default=true}):AddColorPicker('SnaplineColor',{Default=Color3.fromRGB(0,255,239),Title='Color'})
FovTab:AddDropdown('FovPosition', {Values = {"Screen","Mouse"},Default = 2,Multi = false,Text = 'Posiiton'}):OnChanged(function(Value)
    Fov.Settings.FovPosition = Value
end)
FovTab:AddToggle('Filled',{Text='Filled',Default=false}):OnChanged(function(Value)
    Fov.Settings.FovFilled = Value;FovCircle.Filled = Value
end)
FovTab:AddSlider('Transparency', {Text='Transparency',Default=1,Min=0,Max=1,Rounding=2,Compact=false,Suffix="%"}):OnChanged(function(Value)
    Fov.Settings.FovTransparency = Value;FovCircle.Transparency = Value
end)

--Fov Switches
Toggles.Snapline:OnChanged(function(Value)
    Fov.Settings.Snapline = Value
    FovSnapline.Visible = Value
end)
Options.SnaplineColor:OnChanged(function(Value)
    Fov.Settings.SnaplineColor = Value
    FovSnapline.Color=Value
end)

GunModsTab:AddToggle('AutoReload',{Text='Auto Reload',Default=false}):OnChanged(function(Value)
    task.spawn(function()
        while Value do task.wait()
            if InstantReloadToggle and getrenv()._G.modules.FPS.GetEquippedItem() ~= nil and getrenv()._G.modules.FPS.GetEquippedItem().id ~= nil and table.find(GetToolNames(),getrenv()._G.modules.FPS.GetEquippedItem().id) and getrenv()._G.modules.FPS.GetEquippedItem().ammo and getrenv()._G.modules.FPS.GetEquippedItem().ammo < math.round(require(game:GetService("ReplicatedStorage").ItemConfigs[getrenv()._G.modules.FPS.GetEquippedItem().id]).MaxAmmo/2) then
                game.Players.LocalPlayer.PlayerGui:FindFirstChild("RemoteEvent"):FireServer(10, "Reload")
            end
        end
    end)
end)
GunModsTab:AddToggle('NoSway',{Text='No Sway',Default=false}):OnChanged(function(Value)
    NoSway = Value
end)

--Combat Connections
game:GetService("RunService").RenderStepped:Connect(function()
    if Functions:GetClosest() ~= nil and Toggles.Snapline.Value == true then
        local p,t = Functions:GetClosest()
        FovSnapline.Visible = true
        local Position,OnScreen = Camera:WorldToViewportPoint(Functions:GetClosest()[Combat.Settings.SilentAimPart]:GetPivot().p+Functions:Predict());
        if Combat.Settings.TeamCheck == true and Functions:GetClosest().Head.Teamtag.Enabled == false and OnScreen == true then
            FovSnapline.To = Position
        elseif OnScreen == true then
            FovSnapline.To = Position
        end
    else
        FovSnapline.Visible = false
    end
    Fov.Settings.RealFovSize=FovCircle.Radius
    if Fov.Settings.Dynamic == true then
        local set = Fov.Settings.FovSize * ((Fov.Settings.FovSize-Camera.FieldOfView)/100 + 1) + 5
        FovCircle.Radius = set
    else
        FovCircle.Radius=Fov.Settings.FovSize
    end
    if Fov.Settings.FovPosition == "Screen" then
        FovCircle.Position = Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
        FovSnapline.From=FovCircle.Position
    else
        local MousePos = Camera.WorldToViewportPoint(Camera,game.Players.LocalPlayer:GetMouse().Hit.p)
        FovCircle.Position = Vector2.new(MousePos.X,MousePos.Y)
        FovSnapline.From=FovCircle.Position
    end
end)

--Combat Switches
Toggles.Dynamic:OnChanged(function(Value)
    Fov.Settings.Dynamic = Value
end)
Toggles.Fov:OnChanged(function(Value)
    Fov.Settings.FovEnabled = Value
    FovCircle.Visible = Value
end)
Options.FovColor:OnChanged(function(Value)
    Fov.Settings.FovColor = Value
    FovCircle.Color = Value
end)

--[[
local OreVisualTabbox = Tabs.Visual:AddRightTabbox()
local OreVisualTab = OreVisualTabbox:AddTab('Ores')
local OreSettingsVisualTab = OreVisualTabbox:AddTab('Settings')

OreVisualTab:AddToggle('OreNames',{Text='Names',Default=false}):AddColorPicker('OreNamesColor',{Default=Color3.fromRGB(0,255,239),Title='Color'})
OreVisualTab:AddToggle('OreDistance',{Text='Distance',Default=false}):AddColorPicker('OreDistanceColor',{Default=Color3.fromRGB(0,255,239),Title='Distance'})

--Ore Esp Switches
Toggles.OreNames:OnChanged(function(Value)
    Esp.Settings.OreNames = Value
end)
Toggles.OreDistance:OnChanged(function(Value)
    Esp.Settings.OreDistances = Value
end)
Options.OreNamesColor:OnChanged(function(Value)
    Esp.Settings.OreNamesColor = Value
end)
Options.OreDistanceColor:OnChanged(function(Value)
    Esp.Settings.OreDistanceColorColor = Value
end)
]]

local CrosshairTabbox = Tabs.Visual:AddRightTabbox()
local CrosshairTab = CrosshairTabbox:AddTab('Crosshair')

CrosshairTab:AddToggle('CrosshairEnabled',{Text='Enabled',Default=false}):AddColorPicker('CrosshairColor',{Default=Color3.fromRGB(0,255,239),Title='Color'})



local PlayerVisualTabbox = Tabs.Visual:AddLeftTabbox()
local PlayerVisualTab = PlayerVisualTabbox:AddTab('Players')
local PlayerSettingsVisualTab = PlayerVisualTabbox:AddTab('Settings')

PlayerVisualTab:AddToggle('Boxes',{Text='Boxes',Default=false}):AddColorPicker('BoxesColor',{Default=Color3.fromRGB(0,255,239),Title='Color'}):AddColorPicker('BoxesOutlineColor',{Default=Color3.fromRGB(0,0,0),Title='Color'})
PlayerVisualTab:AddToggle('Sleeping',{Text='Sleeping',Default=false}):AddColorPicker('SleepingColor',{Default=Color3.fromRGB(0,255,239),Title='Color'})
PlayerVisualTab:AddToggle('Distances',{Text='Distance',Default=false}):AddColorPicker('DistancesColor',{Default=Color3.fromRGB(0,255,239),Title='Color'})
PlayerVisualTab:AddToggle('Armour',{Text='Armour',Default=false}):AddColorPicker('ArmourColor',{Default=Color3.fromRGB(0,255,239),Title='Color'})
PlayerVisualTab:AddToggle('Tool',{Text='Tool',Default=false}):AddColorPicker('ToolColor',{Default=Color3.fromRGB(0,255,239),Title='Color'})
PlayerVisualTab:AddToggle('ViewAngle',{Text='View Angle',Default=false}):AddColorPicker('ViewAngleColor',{Default=Color3.fromRGB(0,255,239),Title='Color'})
PlayerVisualTab:AddToggle('Tracer',{Text='Tracer',Default=false}):AddColorPicker('TracerColor',{Default=Color3.fromRGB(0,255,239),Title='Color'})

--Esp Switches
Toggles.ViewAngle:OnChanged(function(Value)
    Esp.Settings.ViewAngle = Value
end)
Options.ViewAngleColor:OnChanged(function(Value)
    Esp.Settings.ViewAngleColor = Value
end)
Toggles.Tracer:OnChanged(function(Value)
    Esp.Settings.Tracer = Value
end)
Options.TracerColor:OnChanged(function(Value)
    Esp.Settings.TracerColor = Value
end)
Toggles.Armour:OnChanged(function(Value)
    Esp.Settings.Armour = Value
end)
Options.ToolColor:OnChanged(function(Value)
    Esp.Settings.ToolColor = Value
end)
Toggles.Tool:OnChanged(function(Value)
    Esp.Settings.Tool = Value
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
Options.SleepingColor:OnChanged(function(Value)
    Esp.Settings.SleepingColor = Value
end)
Toggles.Sleeping:OnChanged(function(Value)
    Esp.Settings.Sleeping = Value
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
PlayerSettingsVisualTab:AddSlider('RenderDistance', {Text='Render Distance',Default=1500,Min=1,Max=1500,Rounding=0,Compact=false,Suffix="s"}):OnChanged(function(Value)
    Esp.Settings.RenderDistance = Value
end)
PlayerSettingsVisualTab:AddToggle('TargetSleepers',{Text='Dont Show Sleepers',Default=true}):OnChanged(function(Value)
    Esp.Settings.TargetSleepers = Value
end)
PlayerSettingsVisualTab:AddToggle('BoxesOutlines',{Text='Box Outlines',Default=true}):OnChanged(function(Value)
    Esp.Settings.BoxesOutline = Value
end)
PlayerSettingsVisualTab:AddToggle('TeamCheck',{Text='Team Check',Default=true}):OnChanged(function(Value)
    Esp.Settings.TeamCheck = Value
end)
PlayerSettingsVisualTab:AddToggle('TextOutline',{Text='Text Outlines',Default=true}):OnChanged(function(Value)
    Esp.Settings.TextOutline = Value
end)
PlayerSettingsVisualTab:AddDropdown('TracerPosition',{Values={"Bottom","Middle","Top"},Default=1,Multi=false,Text='Tracer Position'}):OnChanged(function(Value)
    Esp.Settings.TracerFrom = Value
end)

--Misc
local LightingTabbox = Tabs.Misc:AddLeftTabbox()
local LightingTab = LightingTabbox:AddTab('Enviroment')
local MiscTabbox = Tabs.Misc:AddRightTabbox()
local MiscTab = MiscTabbox:AddTab('Character Exploits')
local MiscTabbox = Tabs.Misc:AddLeftTabbox()
local ServerTab = MiscTabbox:AddTab('Server')

ServerTab:AddButton("Rejoin", function()
    writefile("TridentServerRJ.txt",string.split(game:GetService("Players").LocalPlayer.PlayerGui.GameUI.ServerInfo.Text," |")[1])
    game:GetService("TeleportService"):Teleport(13253735473, game.Players.LocalPlayer)
    if syn then queue_on_teleport = syn.queue_on_teleport end
    queue_on_teleport([[
        repeat task.wait() until game:IsLoaded()
        if readfile("TridentServerRJ.txt") ~= nil then
            local String = readfile("TridentServerRJ.txt")
            task.wait(.5)
            local OldHook; OldHook = hookfunction(getrenv()._G.modules.UI.LoadServers,function(...)
            args = {...}
            for i,v in pairs(args[1]) do
                if v.name == String then
                    for i = 0,2 do
                        game:GetService("Players").LocalPlayer.PlayerGui.RemoteEvent:FireServer("JOIN_SERVER",v.uid)
                    end
                end
            end
            return OldHook(...)
            end)
        end
        game:GetService("Players").LocalPlayer.PlayerGui.LobbyUI.Fullscreen.Mask.Changed:Connect(function()
            delfile("TridentServerRJ.txt")    
        end)
    ]])
end)

LightingTab:AddDropdown('SkyboxeChange', {Values = {"Standard","Among Us","Spongebob","Deep Space","Winter","Clouded Sky"},Default = 1,Multi = false,Text = 'Sky'}):OnChanged(function(Value)
    for i, v in pairs(SkyBoxes[Value]) do
        Sky[i] = v
    end
end)
LightingTab:AddDropdown('LightingMode', {Values = {"Compatibility","Future","ShadowMap","Voxel"},Default = 1,Multi = false,Text = 'Lighting'})
LightingTab:AddDivider()
LightingTab:AddToggle('Grass', {Text = 'Grass',Default = true}):OnChanged(function(Value)
    sethiddenproperty(game:GetService("Workspace").Terrain,"Decoration",Value)
end)

MiscTab:AddToggle('Noclip',{Text='Semi Noclip',Default=false}):AddKeyPicker('NoclipKey', {Default='N',SyncToggleState=true,Mode='Toggle',Text='Noclip',NoUI=false})

--Misc Switches
Toggles.Noclip:OnChanged(function(Value)
    getrenv()._G.modules.Character.SetNoclipping(Value)
end)

--Hooks
local event = game.Players.LocalPlayer:FindFirstChild("RemoteEvent").FireServer
local value = 1

local NoSwayHook;NoSwayHook = hookfunction(getrenv()._G.modules.Camera.SetSwaySpeed,function(...)
    if NoSway == true then
    	return
    end
    return NoSwayHook(...)
end)

--Silent Aim
local oldFunction; oldFunction = hookfunction(getupvalues(getrenv()._G.modules.FPS.ToolControllers.BowSpecial.PlayerFire)[4],function(...)
    args = {...}
    local Player = Functions:GetClosest()
    if Combat.Settings.SilentEnabled == true and Player ~= nil and (CharcaterMiddle:GetPivot().Position-Player:GetPivot().Position).Magnitude <= Esp.Settings.RenderDistance and math.random(0,100) <= Combat.Settings.SilentHitChance then
        if Combat.TeamCheck == true and Player.Head.Teamtag.Enabled == false then
            args[1] = CFrame.lookAt(args[1].Position,Player[Combat.Settings.SilentAimPart]:GetPivot().p+Functions:Predict())
        else
            args[1] = CFrame.lookAt(args[1].Position,Player[Combat.Settings.SilentAimPart]:GetPivot().p+Functions:Predict())
        end
    end
    return oldFunction(unpack(args))
end)

local oldFunctionGun; oldFunctionGun = hookfunction(getupvalues(getrenv()._G.modules.FPS.ToolControllers.RangedWeapon.PlayerFire)[1],function(...)
    args = {...}
    local Player = Functions:GetClosest()
    if Combat.Settings.SilentEnabled == true and Player ~= nil and (CharcaterMiddle:GetPivot().Position-Player:GetPivot().Position).Magnitude <= Esp.Settings.RenderDistance and math.random(0,100) <= Combat.Settings.SilentHitChance then
        if Combat.TeamCheck == true and Player.Head.Teamtag.Enabled == false then
            args[1] = CFrame.lookAt(args[1].Position,Player[Combat.Settings.SilentAimPart]:GetPivot().p+Functions:Predict())
        else
            args[1] = CFrame.lookAt(args[1].Position,Player[Combat.Settings.SilentAimPart]:GetPivot().p+Functions:Predict())
        end
    end
    return oldFunction(unpack(args))
end)

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
MenuGroup:AddToggle('Watermark', {Text="Watermark",Default=true}):OnChanged(function(newValue)
    Library:SetWatermarkVisibility(newValue)
end)
MenuGroup:AddToggle('KeybindFrame', {Text="Keybinds",Default=true}):OnChanged(function(newValue)
    Library.KeybindFrame.Visible = newValue
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings() 
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' }) 
ThemeManager:SetFolder('TridentFloat')
SaveManager:SetFolder('TridentFloat/Configs')
SaveManager:BuildConfigSection(Tabs['UI Settings']) 
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()
local ServerInfoGroup = Tabs['UI Settings']:AddRightGroupbox('Server Info')
local ServerPlayersText = ServerInfoGroup:AddLabel(string.split(game:GetService("Players").LocalPlayer.PlayerGui.GameUI.ServerInfo.Text,"|")[1])

local ServerPlayersText = ServerInfoGroup:AddLabel("Players: "..tonumber(#game.Players:GetPlayers()))
game.Players.PlayerAdded:Connect(function()
    ServerPlayersText:SetText("Players: "..tonumber(#game.Players:GetPlayers()))
end)
game.Players.PlayerRemoving:Connect(function()
    ServerPlayersText:SetText("Players: "..tonumber(#game.Players:GetPlayers()))
end)

Library:Notify("Loaded "..string.sub(tostring(tick()-oldTick),3).."s",8)
Library:Notify("Status: Detected 🟥",8)
