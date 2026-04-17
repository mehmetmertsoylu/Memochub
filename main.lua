local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Settings = {
    Aimbot = false, ESP = false, AutoFire = false, BHop = false,
    Fly = false, Speed = 16, NoClip = false,
    FOV = 150, ShowFOV = false, Running = true, Key = "memochub2026", Unlocked = false
}

local fov_circle = Drawing.new("Circle")
fov_circle.Thickness = 1
fov_circle.Radius = Settings.FOV
fov_circle.Visible = false
fov_circle.Color = Color3.new(1, 1, 1)

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

-- KEY UI
local KeyMain = Instance.new("Frame", ScreenGui)
KeyMain.Size = UDim2.new(0, 300, 0, 150)
KeyMain.Position = UDim2.new(0.5, -150, 0.5, -75)
KeyMain.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
local KeyInput = Instance.new("TextBox", KeyMain)
KeyInput.Size = UDim2.new(0, 260, 0, 40)
KeyInput.Position = UDim2.new(0, 20, 0, 40)
KeyInput.PlaceholderText = "Key: memochub2026"
KeyInput.Text = ""
local KeyBtn = Instance.new("TextButton", KeyMain)
KeyBtn.Size = UDim2.new(0, 260, 0, 35)
KeyBtn.Position = UDim2.new(0, 20, 0, 95)
KeyBtn.Text = "Giris Yap"

-- BÜYÜK MODERN MENÜ
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 550, 0, 400)
Main.Position = UDim2.new(0.5, -275, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
Main.Visible = false
Main.Active = true
Main.Draggable = true

-- ARKA PLAN GÜLEN YÜZ (SMILEY)
local Smiley = Instance.new("TextLabel", Main)
Smiley.Size = UDim2.new(1, 0, 1, 0)
Smiley.Text = "🙂"
Smiley.TextSize = 250
Smiley.TextColor3 = Color3.new(1, 1, 1)
Smiley.TextTransparency = 0.92
Smiley.BackgroundTransparency = 1
Smiley.ZIndex = 1

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "Memoc Hub v1.5 | Premium Edition"
Title.TextSize = 22
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(0, 85, 255)
Title.ZIndex = 2

local function CreateSection(name, pos)
    local s = Instance.new("ScrollingFrame", Main)
    s.Size = UDim2.new(0, 160, 0, 320)
    s.Position = pos
    s.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    s.BorderSizePixel = 0
    s.ZIndex = 2
    local l = Instance.new("TextLabel", s)
    l.Size = UDim2.new(1, 0, 0, 30)
    l.Text = name
    l.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    l.TextColor3 = Color3.new(1, 1, 1)
    return s
end

local AimS = CreateSection("AIMLOCK", UDim2.new(0, 15, 0, 60))
local VisS = CreateSection("VISUALS", UDim2.new(0, 195, 0, 60))
local MovS = CreateSection("MOVEMENT", UDim2.new(0, 375, 0, 60))

local function AddToggle(parent, text, y, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0, 140, 0, 35)
    b.Position = UDim2.new(0, 10, 0, y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.ZIndex = 3
    b.MouseButton1Click:Connect(function() callback(b) end)
end

-- AIMLOCK & AUTO FIRE
AddToggle(AimS, "Aimlock: OFF", 40, function(b) Settings.Aimbot = not Settings.Aimbot b.Text = "Aimlock: "..(Settings.Aimbot and "ON" or "OFF") end)
AddToggle(AimS, "Auto Fire: OFF", 85, function(b) Settings.AutoFire = not Settings.AutoFire b.Text = "Fire: "..(Settings.AutoFire and "ON" or "OFF") end)
AddToggle(AimS, "Show FOV", 130, function() Settings.ShowFOV = not Settings.ShowFOV fov_circle.Visible = Settings.ShowFOV end)

-- VISUALS
AddToggle(VisS, "ESP: OFF", 40, function(b) Settings.ESP = not Settings.ESP b.Text = "ESP: "..(Settings.ESP and "ON" or "OFF") end)

-- MOVEMENT
AddToggle(MovS, "B-Hop: OFF", 40, function(b) Settings.BHop = not Settings.BHop b.Text = "B-Hop: "..(Settings.BHop and "ON" or "OFF") end)
AddToggle(MovS, "Fly: OFF", 85, function(b) Settings.Fly = not Settings.Fly b.Text = "Fly: "..(Settings.Fly and "ON" or "OFF") end)
AddToggle(MovS, "Speed: 50", 130, function(b) Settings.Speed = (Settings.Speed == 16 and 50 or 16) b.Text = "Speed: "..Settings.Speed end)
AddToggle(MovS, "No-Clip: OFF", 175, function(b) Settings.NoClip = not Settings.NoClip b.Text = "No-Clip: "..(Settings.NoClip and "ON" or "OFF") end)

KeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == Settings.Key then Settings.Unlocked = true KeyMain.Visible = false Main.Visible = true end
end)

local function isVisible(part)
    local hit = Camera:GetPartsObscuringTarget({part.Position}, {LocalPlayer.Character, part.Parent})
    return #hit == 0
end

-- ANA DÖNGÜ (AIMLOCK & FIRE)
RunService.RenderStepped:Connect(function()
    if not Settings.Unlocked or not LocalPlayer.Character then return end
    
    local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = Settings.Speed
        if Settings.Fly then LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 2, 0) end
        if Settings.BHop and UIS:IsKeyDown(Enum.KeyCode.Space) then hum.Jump = true end
    end

    if Settings.NoClip then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end

    fov_circle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)

    for _, v in pairs(workspace:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v ~= LocalPlayer.Character and v.Humanoid.Health > 0 then
            -- ESP
            local head = v:FindFirstChild("Head")
            if Settings.ESP and head then
                local e = head:FindFirstChild("MemocESP") or Instance.new("BillboardGui", head)
                if not head:FindFirstChild("MemocESP") then
                    e.Name = "MemocESP"; e.AlwaysOnTop = true; e.Size = UDim2.new(4,0,5,0)
                    local f = Instance.new("Frame", e); f.Size = UDim2.new(1,0,1,0); f.BackgroundColor3 = Color3.new(1,0,0); f.BackgroundTransparency = 0.7
                end
                e.Enabled = true
            end
            
            -- AIMLOCK & AUTO FIRE
            if Settings.Aimbot and head then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                local mDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if onScreen and mDist < Settings.FOV and isVisible(head) then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position) -- Aimlock
                    if Settings.AutoFire then
                        keypress(0x01) -- Sol Tık Bas
                        task.wait(0.01)
                        keyrelease(0x01) -- Sol Tık Bırak
                    end
                end
            end
        end
    end
end)

UIS.InputBegan:Connect(function(i, p) if not p and i.KeyCode == Enum.KeyCode.F3 then Main.Visible = not Main.Visible end end)
