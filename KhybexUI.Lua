loadstring([[
-- Khybex Hub : Bloxfruits
-- Loadstring by Grok (xAI)
-- Toggle: Insert Key
-- For Blox Fruits only

if game.PlaceId ~= 2753915549 then return end
if getgenv().KhybexHub then return end
getgenv().KhybexHub = true

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Flags for config
local Flags = {}
local ConfigFile = "khybex_config.json"
if isfile and isfile(ConfigFile) then
    Flags = HttpService:JSONDecode(readfile(ConfigFile))
end

-- Theme
local Theme = {
    Background = Color3.fromRGB(25, 25, 35),
    Secondary = Color3.fromRGB(35, 35, 45),
    Accent = Color3.fromRGB(100, 50, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(200, 200, 200),
    Border = Color3.fromRGB(50, 50, 60),
    Shadow = Color3.fromRGB(0, 0, 0)
}

-- Utility Functions
local function tween(obj, props, time)
    time = time or 0.3
    local ti = TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tw = TweenService:Create(obj, ti, props)
    tw:Play()
    return tw
end

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function createStroke(parent, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or Theme.Border
    stroke.Parent = parent
    return stroke
end

local function createGradient(parent, color1, color2)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, color1 or Theme.Accent),
        ColorSequenceKeypoint.new(1, color2 or Theme.Background)
    }
    grad.Rotation = 45
    grad.Parent = parent
    return grad
end

local function addShadow(parent)
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 14, 1, 14)
    shadow.Position = UDim2.new(0, -7, 0, -7)
    shadow.BackgroundColor3 = Theme.Shadow
    shadow.BackgroundTransparency = 0.8
    shadow.ZIndex = parent.ZIndex - 1
    createCorner(shadow, 12)
    shadow.Parent = parent.Parent
    return shadow
end

local function saveConfig()
    if isfile then
        writefile(ConfigFile, HttpService:JSONEncode(Flags))
    end
end

-- Draggable
local dragging, dragStart, startPos, dragObj
local function makeDraggable(frame)
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            dragObj = frame
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            dragObj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KhybexHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Mini Icon
local MiniIcon = Instance.new("Frame")
MiniIcon.Size = UDim2.new(0, 60, 0, 60)
MiniIcon.Position = UDim2.new(1, -80, 1, -80)
MiniIcon.BackgroundColor3 = Theme.Accent
MiniIcon.Parent = ScreenGui
createCorner(MiniIcon, 30)
createGradient(MiniIcon)
createStroke(MiniIcon, 2)
addShadow(MiniIcon)
makeDraggable(MiniIcon)

local MiniLabel = Instance.new("TextLabel")
MiniLabel.Size = UDim2.new(1, 0, 1, 0)
MiniLabel.BackgroundTransparency = 1
MiniLabel.Text = "◆"
MiniLabel.TextColor3 = Color3.new(1,1,1)
MiniLabel.Font = Enum.Font.GothamBold
MiniLabel.TextSize = 32
MiniLabel.Parent = MiniIcon

-- Main Window
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
createCorner(MainFrame, 12)
createStroke(MainFrame)
addShadow(MainFrame)

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Theme.Accent
TopBar.Parent = MainFrame
createCorner(TopBar, 12, 0, 0, 0, 12) -- Top only
createGradient(TopBar)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Khybex Hub : Bloxfruits"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

makeDraggable(TopBar)

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -65, 0.5, -15)
MinimizeBtn.BackgroundColor3 = Theme.Secondary
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Theme.Text
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 20
MinimizeBtn.Parent = TopBar
createCorner(MinimizeBtn, 6)
createStroke(MinimizeBtn)

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.Parent = TopBar
createCorner(CloseBtn, 6)

-- Content Frame
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -50)
Content.Position = UDim2.new(0, 10, 0, 45)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Tab Buttons
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, 0, 0, 40)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = Content

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 5)
TabLayout.Parent = TabFrame

-- Pages
local Pages = Instance.new("Frame")
Pages.Size = UDim2.new(1, 0, 1, -45)
Pages.Position = UDim2.new(0, 0, 0, 45)
Pages.BackgroundTransparency = 1
Pages.Parent = Content

local PageLayout = Instance.new("UIPageLayout")
PageLayout.Parent = Pages

-- Elements Library
local Elements = {}

function Elements:CreateTab(name)
    local tab = {}
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 120, 1, 0)
    tabBtn.BackgroundColor3 = Theme.Secondary
    tabBtn.Text = name
    tabBtn.TextColor3 = Theme.TextDark
    tabBtn.Font = Enum.Font.Gotham
    tabBtn.TextSize = 14
    tabBtn.Parent = TabFrame
    createCorner(tabBtn, 8)
    createStroke(tabBtn)

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Theme.Accent
    page.Parent = Pages
    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 8)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = page
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 20)
    end)

    local selected = false
    tabBtn.MouseButton1Click:Connect(function()
        PageLayout:JumpTo(page)
        for _, btn in pairs(TabFrame:GetChildren()) do
            if btn:IsA("TextButton") then
                tween(btn, {TextColor3 = Theme.TextDark, BackgroundColor3 = Theme.Secondary})
            end
        end
        tween(tabBtn, {TextColor3 = Theme.Text, BackgroundColor3 = Theme.Accent})
    end)

    tab.Page = page
    tab.Button = tabBtn
    return tab
end

function Elements:CreateSection(parent, name)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -20, 0, 35)
    section.BackgroundTransparency = 1
    section.Parent = parent.Page
    section.LayoutOrder = parent.LayoutOrder or 1

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Theme.Text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = section

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 2)
    line.Position = UDim2.new(0, 0, 1, -3)
    line.BackgroundColor3 = Theme.Accent
    line.Parent = section
    createCorner(line, 1)

    local cont = Instance.new("Frame")
    cont.Size = UDim2.new(1, 0, 0, 0)
    cont.BackgroundTransparency = 1
    cont.Parent = parent.Page
    local contLayout = Instance.new("UIListLayout")
    contLayout.Padding = UDim.new(0, 5)
    contLayout.Parent = cont
    contLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        cont.Size = UDim2.new(1, 0, 0, contLayout.AbsoluteContentSize.Y)
    end)

    parent.LayoutOrder = (parent.LayoutOrder or 0) + 1
    return cont
end

function Elements:CreateToggle(parent, settings)
    local name = settings.Name
    local flag = settings.Flag or name:gsub(" ", "")
    local default = Flags[flag] or settings.Default or false
    local callback = settings.Callback

    Flags[flag] = default

    local toggleFrame = Instance.new("Frame")
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
