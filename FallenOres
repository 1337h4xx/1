local rs = game:GetService("RunService")
local camera = workspace.CurrentCamera

function itemesp(a, b)
    local item = Drawing.new("Text")
    item.Visible = false
    item.Outline = true
    item.Center = true
    item.Font = 2
    item.Color = Color3.fromRGB(128, 128, 128)
    item.Size = 13
    local renderstepped
    renderstepped = rs.RenderStepped:Connect(function()
        if a and workspace.Nodes:FindFirstChild(a.Name) and a:FindFirstChild("Main") then
            local item_pos, item_onscreen = camera:WorldToViewportPoint(a:FindFirstChild("Main").Position)
            if item_onscreen then
                if a.Name == "Stone_Node" then
                    item.Position = Vector2.new(item_pos.X, item_pos.Y)
                    item.Text = "Stone"
                    item.Visible = true
                    item.Color = Color3.fromRGB(128, 128, 128)
                elseif a.Name == "Phosphate_Node" then
                    item.Position = Vector2.new(item_pos.X, item_pos.Y)
                    item.Text = "Sulfur"
                    item.Visible = true
                    item.Color = Color3.fromRGB(255, 255, 0)
                elseif a.Name == "Metal_Node" then
                    item.Position = Vector2.new(item_pos.X, item_pos.Y)
                    item.Text = "Iron"
                    item.Visible = true
                    item.Color = Color3.fromRGB(101, 67, 33)
                end 
            else
                item.Visible = false
            end
        elseif a and workspace.Bases.Loners:FindFirstChild(a.Name) and a:FindFirstChild(b.Name) and a:FindFirstChild(b.Name):FindFirstChild("Main") then
            local item_pos, item_onscreen = camera:WorldToViewportPoint(a:FindFirstChild(b.Name):FindFirstChild("Main").Position)
            if item_onscreen then
                if string.match(b.Name, "Locked Metal Crate") then
                    item.Position = Vector2.new(item_pos.X, item_pos.Y)
                    item.Text = "Locked Metal Crate"
                    item.Visible = true
                    item.Color = Color3.fromRGB(128, 128, 128)
                elseif string.match(b.Name, "Locked Steel Crate") then
                    item.Position = Vector2.new(item_pos.X, item_pos.Y)
                    item.Text = "Locked Steel Crate"
                    item.Visible = true
                    item.Color = Color3.fromRGB(0, 0, 0)
                elseif string.match(b.Name, "Locked Wooden Crate") then
                    item.Position = Vector2.new(item_pos.X, item_pos.Y)
                    item.Text = "Locked Wooden Crate"
                    item.Visible = true
                    item.Color = Color3.fromRGB(101, 67, 33)
                elseif string.match(b.Name, "Wooden Crate") then
                    item.Position = Vector2.new(item_pos.X, item_pos.Y)
                    item.Text = "Wooden Crate"
                    item.Visible = true
                    item.Color = Color3.fromRGB(101, 67, 33)
                elseif string.match(b.Name, "Trash Can") then
                    item.Position = Vector2.new(item_pos.X, item_pos.Y)
                    item.Text = "Trash Can"
                    item.Visible = true
                    item.Color = Color3.fromRGB(128, 128, 128)
                elseif string.match(b.Name, "Food Crate")  then
                    item.Position = Vector2.new(item_pos.X, item_pos.Y)
                    item.Text = "Food Crate"
                    item.Visible = true
                    item.Color = Color3.fromRGB(255, 255, 0)
                elseif string.match(b.Name, "Oil Barrel") then
                    item.Position = Vector2.new(item_pos.X, item_pos.Y)
                    item.Text = "Oil Barrel"
                    item.Visible = true
                    item.Color = Color3.fromRGB(255, 0, 0)
                end
            else
                item.Visible = false
            end
        else
            renderstepped:Disconnect()
            item.Visible = false
            item:Remove()
        end
    end)
end

local function processLonersBase(base)
    if base:FindFirstChild(base.Name) then
        local count = 1
        for _, child in ipairs(base:GetChildren()) do
            if child.Name == base.Name then
                child.Name = base.Name .. count
                itemesp(base, child)
                count = count + 1
            end
        end
    end
end

for _, node in ipairs(workspace.Nodes:GetChildren()) do
    if node.Name == "Phosphate_Node" or node.Name == "Metal_Node" or node.Name == "Stone_Node" then
        itemesp(node)
    end
end

workspace.Nodes.ChildAdded:Connect(function(node)
    if node.Name == "Phosphate_Node" or node.Name == "Metal_Node" or node.Name == "Stone_Node" then
        itemesp(node)
    end
end)

for _, lonersBase in ipairs(workspace.Bases.Loners:GetChildren()) do
    if lonersBase.Name == "Locked Metal Crate" or lonersBase.Name == "Locked Steel Crate" or lonersBase.Name == "Locked Wooden Crate" or lonersBase.Name == "Wooden Crate" or lonersBase.Name == "Trash Can" or lonersBase.Name == "Food Crate" or lonersBase.Name == "Oil Barrel" then
        processLonersBase(lonersBase)
    end
end

workspace.Bases.Loners.ChildAdded:Connect(function(lonersBase)
    if lonersBase.Name == "Locked Metal Crate" or lonersBase.Name == "Locked Steel Crate" or lonersBase.Name == "Locked Wooden Crate" or lonersBase.Name == "Wooden Crate" or lonersBase.Name == "Trash Can" or lonersBase.Name == "Food Crate" or lonersBase.Name == "Oil Barrel" then
        processLonersBase(lonersBase)
    end                     
end)
