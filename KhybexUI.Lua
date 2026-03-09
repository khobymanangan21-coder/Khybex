-- SimpleUI Library (loadstring compatible - inspired by Orion style)
-- Paste this entire code into a raw GitHub file or Pastebin

return (function()
    local SimpleUI = {}

    -- Helper to create ScreenGui (client-side safe)
    local function createScreenGui()
        local gui = Instance.new("ScreenGui")
        gui.Name = "SimpleUI"
        gui.ResetOnSpawn = false
        
        -- Modern safe parenting (works in exploit & normal environments)
        if syn and syn.protect_gui then
            syn.protect_gui(gui)
            gui.Parent = game:GetService("CoreGui")
        elseif gethui then
            gui.Parent = gethui()
        else
            gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        end
        
        return gui
    end

    function SimpleUI:Init()
        local self = {}
        local screenGui = createScreenGui()
        
        function self:MakeWindow(options)
            local window = {}
            options = options or {}
            local name = options.Name or "Simple UI"
            local introText = options.IntroText or ""
            
            local mainFrame = Instance.new("Frame")
            mainFrame.Name = "Main"
            mainFrame.Size = UDim2.new(0, 450, 0, 350)
            mainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
            mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            mainFrame.BorderSizePixel = 0
            mainFrame.Parent = screenGui
            
            -- Simple title bar (you can add dragging later)
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, 0, 0, 35)
            title.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            title.Text = "  " .. name
            title.TextColor3 = Color3.fromRGB(220, 220, 220)
            title.TextSize = 18
            title.Font = Enum.Font.GothamBold
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = mainFrame
            
            local tabBar = Instance.new("Frame")
            tabBar.Name = "TabBar"
            tabBar.Size = UDim2.new(1, 0, 0, 35)
            tabBar.Position = UDim2.new(0, 0, 0, 35)
            tabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            tabBar.Parent = mainFrame
            
            local content = Instance.new("Frame")
            content.Name = "Content"
            content.Size = UDim2.new(1, 0, 1, -70)
            content.Position = UDim2.new(0, 0, 0, 70)
            content.BackgroundTransparency = 1
            content.Parent = mainFrame
            
            local tabs = {}
            local activeTabFrame = nil
            
            function window:MakeTab(options)
                local tab = {}
                options = options or {}
                local tabName = options.Name or "Tab"
                
                -- Tab button
                local tabBtn = Instance.new("TextButton")
                tabBtn.Size = UDim2.new(0, 120, 1, 0)
                tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                tabBtn.Text = tabName
                tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                tabBtn.Font = Enum.Font.Gotham
                tabBtn.TextSize = 14
                tabBtn.Parent = tabBar
                
                -- Tab content
                local tabFrame = Instance.new("ScrollingFrame")
                tabFrame.Size = UDim2.new(1, 0, 1, 0)
                tabFrame.BackgroundTransparency = 1
                tabFrame.ScrollBarThickness = 4
                tabFrame.Visible = false
                tabFrame.Parent = content
                
                local list = Instance.new("UIListLayout")
                list.Padding = UDim.new(0, 6)
                list.SortOrder = Enum.SortOrder.LayoutOrder
                list.Parent = tabFrame
                
                tabBtn.MouseButton1Click:Connect(function()
                    if activeTabFrame then
                        activeTabFrame.Visible = false
                    end
                    tabFrame.Visible = true
                    activeTabFrame = tabFrame
                end)
                
                -- Auto-open first tab
                if #tabs == 0 then
                    tabFrame.Visible = true
                    activeTabFrame = tabFrame
                end
                
                table.insert(tabs, tabBtn)
                
                local currentY = 0
                
                function tab:AddSection(text)
                    local sec = Instance.new("TextLabel")
                    sec.Size = UDim2.new(1, 0, 0, 24)
                    sec.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    sec.Text = "  " .. (text or "Section")
                    sec.TextColor3 = Color3.fromRGB(180, 180, 180)
                    sec.TextSize = 15
                    sec.Font = Enum.Font.GothamSemibold
                    sec.TextXAlignment = Enum.TextXAlignment.Left
                    sec.Parent = tabFrame
                    currentY = currentY + 30
                    tabFrame.CanvasSize = UDim2.new(0,0,0,currentY)
                end
                
                function tab:AddButton(options)
                    options = options or {}
                    local btn = Instance.new("TextButton")
                    btn.Size = UDim2.new(1, -12, 0, 32)
                    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                    btn.Text = options.Name or "Button"
                    btn.TextColor3 = Color3.fromRGB(240, 240, 240)
                    btn.Font = Enum.Font.Gotham
                    btn.TextSize = 14
                    btn.Parent = tabFrame
                    
                    btn.MouseButton1Click:Connect(options.Callback or function() end)
                    
                    currentY = currentY + 38
                    tabFrame.CanvasSize = UDim2.new(0,0,0,currentY)
                end
                
                -- You can add Toggle, Slider, Dropdown the same way as before...
                -- (copy-paste & adapt from your previous code)
                
                return tab
            end
            
            function window:Destroy()
                mainFrame:Destroy()
            end
            
            return window
        end
        
        function self:Notify(options)
            options = options or {}
            local n = Instance.new("Frame")
            n.Size = UDim2.new(0, 220, 0, 70)
            n.Position = UDim2.new(1, -230, 1, -80)
            n.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            n.Parent = screenGui
            
            local t = Instance.new("TextLabel")
            t.Size = UDim2.new(1,0,0.35,0)
            t.Text = options.Title or "Notification"
            t.TextColor3 = Color3.new(1,1,1)
            t.BackgroundTransparency = 1
            t.Parent = n
            
            local c = Instance.new("TextLabel")
            c.Size = UDim2.new(1,0,0.65,0)
            c.Position = UDim2.new(0,0,0.35,0)
            c.Text = options.Content or ""
            c.TextColor3 = Color3.fromRGB(200,200,200)
            c.BackgroundTransparency = 1
            c.TextWrapped = true
            c.Parent = n
            
            task.delay(options.Time or 5, function()
                n:Destroy()
            end)
        end
        
        return self
    end

    return SimpleUI
end)()
