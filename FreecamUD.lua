local UIS, RS, Camera = game:GetService("UserInputService"), game:GetService("RunService"), workspace.CurrentCamera
local keybind, speed = Enum.KeyCode.Z, 0.2  -- Adjust speed to a slower value
local droneCFrame = Camera.CFrame
local isFlying = false

local function updateFreecam()
if UIS:IsKeyDown(keybind) then
if not isFlying then
droneCFrame = Camera.CFrame
isFlying = true
end

local delta = UIS:GetMouseDelta()
droneCFrame = droneCFrame * CFrame.Angles(-math.rad(delta.Y * 1), -math.rad(delta.X * 1), 0)

local mv = Vector3.new()
mv = mv + (UIS:IsKeyDown(Enum.KeyCode.W) and (droneCFrame.LookVector * speed) or Vector3.new())
mv = mv + (UIS:IsKeyDown(Enum.KeyCode.S) and (-droneCFrame.LookVector * speed) or Vector3.new())
mv = mv + (UIS:IsKeyDown(Enum.KeyCode.A) and (-droneCFrame.RightVector * speed) or Vector3.new())
mv = mv + (UIS:IsKeyDown(Enum.KeyCode.D) and (droneCFrame.RightVector * speed) or Vector3.new())
mv = mv + (UIS:IsKeyDown(Enum.KeyCode.E) and (droneCFrame.UpVector * speed) or Vector3.new())
mv = mv + (UIS:IsKeyDown(Enum.KeyCode.Q) and (-droneCFrame.UpVector * speed) or Vector3.new())

droneCFrame = droneCFrame + mv
Camera.CFrame = droneCFrame
else
isFlying = false  -- Reset when the key is released
end
end

RS.RenderStepped:Connect(updateFreecam)
