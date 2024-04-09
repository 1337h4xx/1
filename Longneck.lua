--Thread1
local Thread1 = coroutine.create(function()
--//8.93 is max longneck
local longneck = { LongNeckEnabled = false, UpperLimitDefault = 8.93, LowerLimitDefault = 8.93, }
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
end)
coroutine.resume(Thread1)

--Thread2
local Thread2 = coroutine.create(function()
local longneck = { LongNeckEnabled = false, UpperLimitDefault = 0.00, LowerLimitDefault = 0.00, }
local keybind = 'X'
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
end)
coroutine.resume(Thread2)

--Thread3
local Thread3 = coroutine.create(function()
local longneck = { LongNeckEnabled = false, UpperLimitDefault = 6.5, LowerLimitDefault = 6.5, }
local keybind = 'T'
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
end)
coroutine.resume(Thread3)



