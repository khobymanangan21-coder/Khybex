local CustomUIHub = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local windows = {}
local notifications = {}

local function createNotification(text, duration)
    local screenGui = playerGui:FindFirstChild("CustomUINotifs") or Instance.new("ScreenGui")
    screenGui.Name = "CustomUINotifs"
    screenGui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 60)
    frame.Position = UDim2.new(1, -320, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
    
    local tweenIn = TweenService:Create(frame, TweenInfo.new(0.3), {Position = UDim2.new(1, -320, 0, 20)})
    local tweenOut = TweenService:Create(frame, TweenInfo.new(0.3), {Position = UDim2.new(1, 0, 0, 20)})
    
    tweenIn:Play()
    game:GetService("Debris"):AddItem(frame, duration or 3)
    
    frame:GetPropertyChangedSignal("Parent"):Connect(function()
        if not frame.Parent then tweenOut:Play() end
    end)
end

function CustomUIHub:MakeWindow(options)
    options = options or {}
    local name = options.Name or "Hub"
    local hidePremium = options.HidePremium or false
    local configFolder = options.ConfigFolder or "CustomHub"
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CustomUIHub"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 550, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 35)
    topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = name
    title.TextColor3 = Color3.new(1,1,1)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 2.5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = topBar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    corner.Parent = topBar
    
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.ZIndex = mainFrame.ZIndex - 1
    shadow.Parent = mainFrame
    
    -- Draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    local tabsFrame = Instance.new("Frame")
    tabsFrame.Size = UDim2.new(1, 0, 0, 40)
    tabsFrame.Position = UDim2.new(0, 0, 0, 35)
    tabsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    tabsFrame.BorderSizePixel = 0
    tabsFrame.Parent = mainFrame
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -10, 1, -85)
    contentFrame.Position = UDim2.new(0, 5, 0, 80)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    local tabs = {}
    
    local windowObj = {
        tabs = {},
        notify = createNotification
    }
    
    function windowObj:MakeTab(options)
        options = options or {}
        local name = options.Name or "Tab"
        local icon = options.Icon or ""
        
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(0, 100, 1, 0)
        tabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        tabBtn.Text = name
        tabBtn.TextColor3 = Color3.new(1,1,1)
        tabBtn.TextScaled = true
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.BorderSizePixel = 0
        tabBtn.Parent = tabsFrame
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = tabBtn
        
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 6
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Visible = false
        tabContent.Parent = contentFrame
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 8)
        listLayout.Parent = tabContent
        
        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
        end)
        
        for i, child in pairs(tabsFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child.Size = UDim2.new(0, 100, 1, 0)
            end
        end
        
        tabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(tabs) do
                t.content.Visible = false
                t.btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            end
            tabContent.Visible = true
            tabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end)
        
        -- Show first tab
        if #tabs == 0 then
            tabContent.Visible = true
            tabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
        
        table.insert(tabs, {btn = tabBtn, content = tabContent})
        
        local tabObj = {}
        
        function tabObj:AddButton(options)
            options = options or {}
            local name = options.Name or "Button"
            local callback = options.Callback or function() end
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -20, 0, 40)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            btn.Text = name
            btn.TextColor3 = Color3.new(1,1,1)
            btn.TextScaled = true
            btn.Font = Enum.Font.Gotham
            btn.BorderSizePixel = 0
            btn.Parent = tabContent
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(callback)
            
            windowObj.notify("Button added!")
        end
        
        function tabObj:AddToggle(options)
            options = options or {}
            local name = options.Name or "Toggle"
            local default = options.Default or false
            local callback = options.Callback or function() end
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -20, 0, 40)
            frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            frame.BorderSizePixel = 0
            frame.Parent = tabContent
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 6)
            frameCorner.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -60, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = Color3.new(1,1,1)
            label.TextScaled = true
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Size = UDim2.new(0, 50, 0, 25)
            toggleBtn.Position = UDim2.new(1, -55, 0.5, -12.5)
            toggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
            toggleBtn.Text = ""
            toggleBtn.BorderSizePixel = 0
            toggleBtn.Parent = frame
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 12)
            toggleCorner.Parent = toggleBtn
            
            local toggled = default
            toggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                toggleBtn.BackgroundColor3 = toggled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
                callback(toggled)
            end)
        end
        
        function tabObj:AddSlider(options)
            options = options or {}
            local name = options.Name or "Slider"
            local min = options.Min or 0
            local max = options.Max or 100
            local default = options.Default or min
            local callback = options.Callback or function() end
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -20, 0, 60)
            frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            frame.BorderSizePixel = 0
            frame.Parent = tabContent
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 6)
            frameCorner.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 25)
            label.BackgroundTransparency = 1
            label.Text = name .. ": " .. default
            label.TextColor3 = Color3.new(1,1,1)
            label.TextScaled = true
            label.Font = Enum.Font.Gotham
            label.Parent = frame
            
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, -20, 0, 20)
            sliderFrame.Position = UDim2.new(0, 10, 0, 35)
            sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            sliderFrame.BorderSizePixel = 0
            sliderFrame.Parent = frame
            
            local sliderCorner = Instance.new("UICorner")
            sliderCorner.CornerRadius = UDim.new(0, 10)
            sliderCorner.Parent = sliderFrame
            
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            fill.BorderSizePixel = 0
            fill.Parent = sliderFrame
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(0, 10)
            fillCorner.Parent = fill
            
            local draggingSlider = false
            
            sliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = true
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = false
                end
            end)
            
            RunService.RenderStepped:Connect(function()
                if draggingSlider then
                    local mouse = player:GetMouse()
                    local relativeX = math.clamp((mouse.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (max - min) * relativeX)
                    fill.Size = UDim2.new(relativeX, 0, 1, 0)
                    label.Text = name .. ": " .. value
                    callback(value)
                end
            end)
        end
        
        return tabObj
    end
    
    table.insert(windows, windowObj)
    return windowObj
end

return CustomUIHub
new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 35)
    toggleFrame.BackgroundColor3 = Theme.Secondary
    toggleFrame.Parent = parent
    createCorner(toggleFrame, 8)
    createStroke(toggleFrame)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Theme.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame

    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0, 40, 0, 20)
    switch.Position = UDim2.new(1, -45, 0.5, -10)
    switch.BackgroundColor3 = default and Theme.Accent or Theme.Border
    switch.Parent = toggleFrame
    createCorner(switch, 10)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = default and UDim2.new(0.55, 0, 0.1, 0) or UDim2.new(0.1, 0, 0.1, 0)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.Parent = switch
    createCorner(knob, 9)

    local state = default
    local function update(state)
        Flags[flag] = state
        saveConfig()
        tween(switch, {BackgroundColor3 = state and Theme.Accent or Theme.Border}, 0.2)
        tween(knob, {Position = state and UDim2.new(0.55, 0, 0.1, 0) or UDim2.new(0.1, 0, 0.1, 0)}, 0.2)
        callback(state)
    end
    update(default)

    switch.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            update(state)
        end
    end)

    return toggleFrame
end

function Elements:CreateButton(parent, settings)
    local name = settings.Name
    local callback = settings.Callback

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Theme.Accent
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = parent
    createCorner(btn, 8)
    createStroke(btn, 1.5)

    btn.MouseButton1Click:Connect(function()
        tween(btn, {BackgroundColor3 = Theme.Accent:lerp(Color3.new(1,1,1), 0.2)}, 0.1)
        wait(0.1)
        tween(btn, {BackgroundColor3 = Theme.Accent}, 0.1)
        callback()
    end)

    btn.MouseEnter:Connect(function() tween(btn, {Size = UDim2.new(1, 4, 0, 35)}, 0.2) end)
    btn.MouseLeave:Connect(function() tween(btn, {Size = UDim2.new(1, 0, 0, 35)}, 0.2) end)

    return btn
end

function Elements:CreateSlider(parent, settings)
    local name = settings.Name
    local min = settings.Min or 0
    local max = settings.Max or 100
    local default = math.clamp(Flags[settings.Flag] or settings.Default or min, min, max)
    local callback = settings.Callback
    local flag = settings.Flag or name
    local suffix = settings.Suffix or ""

    Flags[flag] = default

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 50)
    sliderFrame.BackgroundColor3 = Theme.Secondary
    sliderFrame.Parent = parent
    createCorner(sliderFrame, 8)
    createStroke(sliderFrame)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Theme.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Parent = sliderFrame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -20, 0, 6)
    bar.Position = UDim2.new(0, 10, 0.7, 0)
    bar.BackgroundColor3 = Theme.Border
    bar.Parent = sliderFrame
    createCorner(bar, 3)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    fill.BackgroundColor3 = Theme.Accent
    fill.Parent = bar
    createCorner(fill, 3)
    createStroke(fill, 1)

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 60, 1, 0)
    valueLabel.Position = UDim2.new(1, -70, 0.65, 0)
    valueLabel.BackgroundColor3 = Theme.Background
    valueLabel.Text = default .. suffix
    valueLabel.TextColor3 = Theme.Text
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 12
    valueLabel.Parent = sliderFrame
    createCorner(valueLabel, 4)

    local dragging = false
    bar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging then
            local mouse = UserInputService:GetMouseLocation()
            local rel = math.clamp((mouse.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * rel)
            Flags[flag] = val
            saveConfig()
            tween(fill, {Size = UDim2.new(rel, 0, 1, 0)})
            valueLabel.Text = val .. suffix
            callback(val)
        end
    end)

    return sliderFrame
end

function Elements:CreateDropdown(parent, settings)
    local name = settings.Name
    local options = settings.Options
    local default = settings.Default or options[1]
    local flag = settings.Flag or name
    local callback = settings.Callback

    Flags[flag] = default

    local dropFrame = Instance.new("Frame")
    dropFrame.Size = UDim2.new(1, 0, 0, 35)
    dropFrame.BackgroundColor3 = Theme.Secondary
    dropFrame.Parent = parent
    createCorner(dropFrame, 8)
    createStroke(dropFrame)

    local dropLabel = Instance.new("TextLabel")
    dropLabel.Size = UDim2.new(0.8, 0, 1, 0)
    dropLabel.BackgroundTransparency = 1
    dropLabel.Text = name .. ": " .. default
    dropLabel.TextColor3 = Theme.Text
    dropLabel.Font = Enum.Font.Gotham
    dropLabel.TextSize = 14
    dropLabel.TextXAlignment = Enum.TextXAlignment.Left
    dropLabel.Parent = dropFrame

    local arrow = Instance.new("TextButton")
    arrow.Size = UDim2.new(0, 25, 1, 0)
    arrow.Position = UDim2.new(1, -25, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Theme.TextDark
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 14
    arrow.Parent = dropFrame

    local listFrame = Instance.new("Frame")
    listFrame.Size = UDim2.new(1, 0, 0, 0)
    listFrame.Position = UDim2.new(0, 0, 1, 5)
    listFrame.BackgroundColor3 = Theme.Background
    listFrame.Visible = false
    listFrame.Parent = dropFrame
    createCorner(listFrame, 8)
    createStroke(listFrame)
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = listFrame

    for _, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 30)
        optBtn.BackgroundTransparency = 1
        optBtn.Text = opt
        optBtn.TextColor3 = Theme.TextDark
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 13
        optBtn.Parent = listFrame
        optBtn.MouseButton1Click:Connect(function()
            Flags[flag] = opt
            saveConfig()
            dropLabel.Text = name .. ": " .. opt
            callback(opt)
            listFrame.Visible = false
        end)
        optBtn.MouseEnter:Connect(function() optBtn.TextColor3 = Theme.Text end)
        optBtn.MouseLeave:Connect(function() optBtn.TextColor3 = Theme.TextDark end)
    end
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        listFrame.Size = UDim2.new(1, 0, 0, listLayout.AbsoluteContentSize.Y)
        dropFrame.Size = UDim2.new(1, 0, 0, 35 + (listFrame.Visible and listLayout.AbsoluteContentSize.Y + 5 or 0))
    end)

    local open = false
    arrow.MouseButton1Click:Connect(function()
        open = not open
        listFrame.Visible = open
        arrow.Text = open and "▲" or "▼"
        dropFrame.Size = UDim2.new(1, 0, 0, 35 + (open and listLayout.AbsoluteContentSize.Y + 5 or 0))
        arrow.TextColor3 = open and Theme.Accent or Theme.TextDark
    end)

    return dropFrame
end

-- Teleport Positions (Common Blox Fruits)
local Teleports = {
    -- First Sea
    ["Marine Starter"] = CFrame.new(3981.15, 37.58, 137.99),
    ["Jungle"] = CFrame.new(-1320.67, 13.99, 3862.34),
    ["Middle Town"] = CFrame.new(-690, 15, 4427),
    ["Pirate Village"] = CFrame.new(1061, 16, 1547),
    ["Desert"] = CFrame.new(1447, 28, 104),
    ["Frozen Village"] = CFrame.new(1198, 16, -1098),
    ["Skylands"] = CFrame.new(-4842, 717, -2623),
    ["Fountain City"] = CFrame.new(5079, 8, 1946),
    ["Prison"] = CFrame.new(4854, 5, 741),
    ["Colosseum"] = CFrame.new(-1428, 55, 4174),
    ["Magma Village"] = CFrame.new(3860, 6, -3270),
    -- Second Sea
    ["Kingdom of Rose"] = CFrame.new(-1255, 213, 5825),
    ["Green Zone"] = CFrame.new(-2448, 73, -3210),
    ["Port Town"] = CFrame.new(-293, 44, 5376),
    ["Hydra Island"] = CFrame.new(5432, 602, -640),
    ["Castle on the Sea"] = CFrame.new(-5075, 300, 5950),
    -- Third Sea (examples)
    ["Great Tree"] = CFrame.new(144, 492, -8491),
    ["Floating Turtle"] = CFrame.new(-13200, 428, -7750)
}

local function getNearestEnemy()
    local char = Player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local closest, dist = nil, math.huge
    for _, npc in pairs(Workspace.Enemies:GetChildren()) do
        local nhrp = npc:FindFirstChild("HumanoidRootPart")
        if nhrp and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
            local d = (hrp.Position - nhrp.Position).Magnitude
            if d < dist then
                closest = npc
                dist = d
            end
        end
    end
    return closest
end

-- Create Tabs
local MainTab = Elements:CreateTab("Main")
local PlayerTab = Elements:CreateTab("Player")
local TeleportTab = Elements:CreateTab("Teleports
