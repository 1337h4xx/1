local longneck = { LongNeckEnabled = false, UpperLimitDefault = 8.75, LowerLimitDefault = 8.85, }
local keybind = 'V'
local function toggleLongNeck()
    longneck.LongNeckEnabled = not longneck.LongNeckEnabled
    if not longneck.LongNeckEnabled then
        game:GetService("Workspace").Ignore.LocalCharacter.Bottom.PrismaticConstraint.UpperLimit = longneck.UpperLimitDefault
        game:GetService("Workspace").Ignore.LocalCharacter.Bottom.PrismaticConstraint.LowerLimit = longneck.LowerLimitDefault
    else
        game:GetService("Workspace").Ignore.LocalCharacter.Bottom.PrismaticConstraint.UpperLimit = 4
        game:GetService("Workspace").Ignore.LocalCharacter.Bottom.PrismaticConstraint.LowerLimit = 1.75
    end
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode[keybind] then
        toggleLongNeck()
    end
end)

local longneck = { LongNeckEnabled = false, UpperLimitDefault = 0.00, LowerLimitDefault = 0.00, }
local keybind = 'P'
local function toggleLongNeck()
    longneck.LongNeckEnabled = not longneck.LongNeckEnabled
    if not longneck.LongNeckEnabled then
        game:GetService("Workspace").Ignore.LocalCharacter.Bottom.PrismaticConstraint.UpperLimit = longneck.UpperLimitDefault
        game:GetService("Workspace").Ignore.LocalCharacter.Bottom.PrismaticConstraint.LowerLimit = longneck.LowerLimitDefault
    else
        game:GetService("Workspace").Ignore.LocalCharacter.Bottom.PrismaticConstraint.UpperLimit = 4
        game:GetService("Workspace").Ignore.LocalCharacter.Bottom.PrismaticConstraint.LowerLimit = 1.75
    end
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode[keybind] then
        toggleLongNeck()
    end
end)

local longneck = { LongNeckEnabled = false, UpperLimitDefault = -8.59, LowerLimitDefault = -8.59, }
local keybind = 'O'
local function toggleLongNeck()
    longneck.LongNeckEnabled = not longneck.LongNeckEnabled
    if not longneck.LongNeckEnabled then
        game:GetService("Workspace").Ignore.LocalCharacter.Bottom.PrismaticConstraint.UpperLimit = longneck.UpperLimitDefault
        game:GetService("Workspace").Ignore.LocalCharacter.Bottom.PrismaticConstraint.LowerLimit = longneck.LowerLimitDefault
    else
        game:GetService("Workspace").Ignore.LocalCharacter.Bottom.PrismaticConstraint.UpperLimit = 4
        game:GetService("Workspace").Ignore.LocalCharacter.Bottom.PrismaticConstraint.LowerLimit = 1.75
    end
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode[keybind] then
        toggleLongNeck()
    end
end)

local longneck = { LongNeckEnabled = false, UpperLimitDefault = -2.90, LowerLimitDefault = -2.90, }
local keybind = 'K'
local function toggleLongNeck()
    longneck.LongNeckEnabled = not longneck.LongNeckEnabled
    if not longneck.LongNeckEnabled then
        game:GetService("Workspace").Ignore.LocalCharacter.Bottom.PrismaticConstraint.UpperLimit = longneck.UpperLimitDefault
        game:GetService("Workspace").Ignore.LocalCharacter.Bottom.PrismaticConstraint.LowerLimit = longneck.LowerLimitDefault
    else
        game:GetService("Workspace").Ignore.LocalCharacter.Bottom.PrismaticConstraint.UpperLimit = 4
        game:GetService("Workspace").Ignore.LocalCharacter.Bottom.PrismaticConstraint.LowerLimit = 1.75
    end
end

local longneck = { LongNeckEnabled = false, UpperLimitDefault = -3.50, LowerLimitDefault = -3.50, }
local keybind = 'L'
local function toggleLongNeck()
    longneck.LongNeckEnabled = not longneck.LongNeckEnabled
    if not longneck.LongNeckEnabled then
        game:GetService("Workspace").Ignore.LocalCharacter.Bottom.PrismaticConstraint.UpperLimit = longneck.UpperLimitDefault
        game:GetService("Workspace").Ignore.LocalCharacter.Bottom.PrismaticConstraint.LowerLimit = longneck.LowerLimitDefault
    else
        game:GetService("Workspace").Ignore.LocalCharacter.Bottom.PrismaticConstraint.UpperLimit = 4
        game:GetService("Workspace").Ignore.LocalCharacter.Bottom.PrismaticConstraint.LowerLimit = 1.75
    end
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode[keybind] then
        toggleLongNeck()
    end
end)