local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Settings = {
    Aimbot = false, ESP = false, AutoFire = false, BHop = false,
    FOV = 150, ShowFOV = false, Running = true, Key = "memochub2026", Unlocked = false
}

-- FOV Circle
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
KeyMain.BorderSizePixel = 2

local KeyInput = Instance.new("TextBox", KeyMain)
KeyInput.Size = UDim2.new(0, 260, 0, 40)
KeyInput.Position = UDim2.new(0, 20, 0, 40)
KeyInput.PlaceholderText = "Anahtari Buraya Yaz..."
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyInput.TextColor3 = Color3.new(1, 1, 1)

local KeyBtn = Instance.new("TextButton", KeyMain)
KeyBtn.Size = UDim2.new(0, 260, 0, 35)
KeyBtn.Position = UDim2.new(0, 20, 0, 95)
KeyBtn.Text = "Giris Yap"
KeyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
KeyBtn.TextColor3 = Color3.new(1, 1, 1)

-- MAIN MENU
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 220, 0, 400)
Main.Position = UDim2.new(0.5, -110, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(0, 0, 150)
Main.Visible = false
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Memoc Hub v1.4"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Title.BackgroundTransparency = 0.5

local function btn(txt, y, cb)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0, 180, 0, 35)
    b.Position = UDim2.new(0, 20, 0, y)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.MouseButton1Click:Connect(function() cb(b) end)
end

KeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == Settings.Key then
        Settings.Unlocked = true
        KeyMain.Visible = false
        Main.Visible = true
    else
        KeyBtn.Text = "HATALI KEY!"
        task.wait(1)
        KeyBtn.Text = "Giris Yap"
    end
end)

btn("Aim: OFF", 40, function(b) Settings.Aimbot = not Settings.Aimbot b.Text = "Aim: "..(Settings.Aimbot and "ON" or "OFF") end)
btn("ESP: OFF", 85, function(b) Settings.ESP = not Settings.ESP b.Text = "ESP: "..(Settings.ESP and "ON" or "OFF") end)
btn("Fire: OFF", 130, function(b) Settings.AutoFire = not Settings.AutoFire b.Text = "Fire: "..(Settings.AutoFire and "ON" or "OFF") end)
btn("B-Hop: OFF", 175, function(b) Settings.BHop = not Settings.BHop b.Text = "B-Hop: "..(Settings.BHop and "ON" or "OFF") end)
btn("Show FOV: OFF", 220, function(b) Settings.ShowFOV = not Settings.ShowFOV b.Text = "FOV: "..(Settings.ShowFOV and "ON" or "OFF") fov_circle.Visible = Settings.ShowFOV end)
btn("Scripti Sil", 340, function() Settings.Running = false fov_circle:Remove() ScreenGui:Destroy() end)

local function isVisible(part)
    local hit = Camera:GetPartsObscuringTarget({part.Position}, {LocalPlayer.Character, part.Parent})
    return #hit == 0
end

RunService.RenderStepped:Connect(function()
    if not Settings.Running or not Settings.Unlocked then return end
    
    if Settings.BHop and UIS:IsKeyDown(Enum.KeyCode.Space) then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.Jump = true
        end
    end

    fov_circle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)

    if Settings.Aimbot then
        local t = nil
        local dist = Settings.FOV
        for _, v in pairs(workspace:GetChildren()) do
            if v:FindFirstChild("Head") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v ~= LocalPlayer.Character then
                local pos, onScreen = Camera:WorldToViewportPoint(v.Head.Position)
                if onScreen and isVisible(v.Head) then
                    local mDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if mDist < dist then t = v.Head; dist = mDist end
                end
            end
        end
        if t then 
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Position)
            if Settings.AutoFire then
                if mouse1press then mouse1press() task.wait(0.02) mouse1release() end
            end
        end
    end

    if Settings.ESP then
        for _, v in pairs(workspace:GetChildren()) do
            if v:FindFirstChild("Humanoid") and v:FindFirstChild("Head") and v ~= LocalPlayer.Character then
                local esp = v.Head:FindFirstChild("MemocESP") or Instance.new("BillboardGui", v.Head)
                if not v.Head:FindFirstChild("MemocESP") then
                    esp.Name = "MemocESP"
                    esp.AlwaysOnTop = true
                    esp.Size = UDim2.new(4, 0, 5, 0)
                    local f = Instance.new("Frame", esp)
                    f.Size = UDim2.new(1, 0, 1, 0)
                    f.BackgroundTransparency = 0.7
                    f.BackgroundColor3 = Color3.new(1, 0, 0)
                end
                esp.Enabled = true
            end
        end
    end
end)

UIS.InputBegan:Connect(function(i, p) 
    if not p and i.KeyCode == Enum.KeyCode.F3 and Settings.Unlocked then Main.Visible = not Main.Visible end 
end)
