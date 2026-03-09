-- Khybex Hub : Blox Fruits

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/khobymanangan21-coder/Khybex/refs/heads/main/KhybexUI.Lua"))()

local UI = Library:Init()

local Window = UI:MakeWindow({
    Name = "Khybex Hub : Blox Fruits",
    IntroText = "Welcome to Khybex Hub | Blox Fruits Edition!"
})

local Tab1 = Window:MakeTab({
    Name = "Main Tab"
})

Tab1:AddSection({
    Name = "Controls / Features"
})

Tab1:AddButton({
    Name = "Print Hello",
    Callback = function()
        print("Hello from Khybex Hub!")
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Khybex Hub",
            Text = "Button clicked!",
            Duration = 3
        })
    end
})

Tab1:AddToggle({
    Name = "Enable Auto Farm (Example)",
    Default = false,
    Callback = function(value)
        print("Auto Farm toggled:", value)
        -- You can put real autofarm logic here later
    end
})

Tab1:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 300,
    Default = 50,
    Callback = function(value)
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
        print("WalkSpeed set to:", value)
    end
})

Tab1:AddDropdown({
    Name = "Choose Fruit Mode",
    Options = {"Buddha", "Dough", "Dragon", "Leopard", "Control"},
    Default = "Buddha",
    Callback = function(selected)
        print("Selected fruit focus:", selected)
        -- You could add fruit notifier / snipe logic here
    end
})

local Tab2 = Window:MakeTab({
    Name = "Settings / Misc"
})

Tab2:AddSection({
    Name = "Options"
})

Tab2:AddButton({
    Name = "Reset Character",
    Callback = function()
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character:BreakJoints()
        end
        print("Character reset!")
    end
})

Tab2:AddButton({
    Name = "Copy Discord Invite",
    Callback = function()
        setclipboard("https://discord.gg/yourserver")  -- change to real link
        print("Discord link copied!")
    end
})

-- Optional: Show a welcome notification
UI:MakeNotification({
    Name = "Khybex Hub",
    Content = "UI Loaded Successfully! Enjoy Blox Fruits scripting.",
    Time = 6
})

-- Optional: Add minimize / destroy button if your library supports it
-- Window:AddMinimizeButton({...})   -- if you added this feature
