local UIS, RS, Camera = game:GetService("UserInputService"), game:GetService("RunService"), workspace.CurrentCamera
local keybind, speed = Enum.KeyCode.K, 0.9  -- Adjust speed to a slower value
local droneCFrame = Camera.CFrame
local isFlying = false

local function toggleFreecam()
    isFlying = not isFlying
    if isFlying then
        droneCFrame = Camera.CFrame
    end
end

local function updateFreecam()
    if isFlying then
        local delta = UIS:GetMouseDelta()
        droneCFrame = droneCFrame * CFrame.Angles(-math.rad(delta.Y * 1), -math.rad(delta.X * 1), 0)

        local mv = Vector3.new()
        mv = mv + (UIS:IsKeyDown(Enum.KeyCode.W) and (droneCFrame.LookVector * speed) or Vector3.new())
        mv = mv + (UIS:IsKeyDown(Enum.KeyCode.S) and (-droneCFrame.LookVector * speed) or Vector3.new())
        mv = mv + (UIS:IsKeyDown(Enum.KeyCode.A) and (-droneCFrame.RightVector * speed) or Vector3.new())
        mv = mv + (UIS:IsKeyDown(Enum.KeyCode.D) and (droneCFrame.RightVector * speed) or Vector3.new())
        mv = mv + (UIS:IsKeyDown(Enum.KeyCode.C) and (droneCFrame.UpVector * speed) or Vector3.new())
        mv = mv + (UIS:IsKeyDown(Enum.KeyCode.Z) and (-droneCFrame.UpVector * speed) or Vector3.new())

        droneCFrame = droneCFrame + mv
        Camera.CFrame = droneCFrame
    end
end

UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == keybind then
        toggleFreecam()
    end
end)

RS.RenderStepped:Connect(updateFreecam)
