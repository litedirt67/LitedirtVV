-- ==========================================
-- LITEDIRT SCRIPT HUB (NEW UI)
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function getSafeGuiParent()
    local success, parent = pcall(function() if gethui then return gethui() end end)
    if success and parent then return parent end
    
    success, parent = pcall(function() return game:GetService("CoreGui") end)
    if success and parent then return parent end
    
    return LocalPlayer:WaitForChild("PlayerGui")
end

local GuiParent = getSafeGuiParent()

pcall(function()
    if GuiParent:FindFirstChild("LitedirtHubUI") then GuiParent.LitedirtHubUI:Destroy() end
    if GuiParent:FindFirstChild("DeltaModernUI") then GuiParent.DeltaModernUI:Destroy() end
end)

local function applyCorner(gui, radius)
    pcall(function()
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, radius or 12)
        corner.Parent = gui
    end)
end

local function applyStroke(gui, color, thickness)
    pcall(function()
        local stroke = Instance.new("UIStroke")
        stroke.Color = color or Color3.fromRGB(255, 255, 255)
        stroke.Thickness = thickness or 1
        stroke.Transparency = 0.7
        stroke.Parent = gui
    end)
end

local successStart, err = pcall(function()
    local HubGui = Instance.new("ScreenGui")
    HubGui.Name = "LitedirtHubUI"
    HubGui.ResetOnSpawn = false
    HubGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    HubGui.Parent = GuiParent

    local HubFrame = Instance.new("Frame")
    HubFrame.Size = UDim2.new(0, 340, 0, 260) 
    HubFrame.Position = UDim2.new(0.5, -170, 0.5, -130)
    HubFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    HubFrame.BackgroundTransparency = 0.25
    HubFrame.Active = true
    HubFrame.Draggable = true
    HubFrame.Parent = HubGui
    applyCorner(HubFrame, 16)
    applyStroke(HubFrame, Color3.fromRGB(200, 200, 200), 1.2)

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundTransparency = 1
    TitleBar.Parent = HubFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Text = "LITEDIRT HUB"
    Title.TextColor3 = Color3.fromRGB(240, 240, 240)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position = UDim2.new(1, -38, 0, 11)
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    CloseBtn.BackgroundTransparency = 0.5
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 18
    CloseBtn.Parent = HubFrame
    applyCorner(CloseBtn, 8)
    applyStroke(CloseBtn, Color3.fromRGB(255, 255, 255), 0.5)

    CloseBtn.MouseButton1Click:Connect(function()
        HubGui:Destroy()
    end)

    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -30, 0, 1)
    Divider.Position = UDim2.new(0, 15, 0, 50)
    Divider.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Divider.BackgroundTransparency = 0.8
    Divider.BorderSizePixel = 0
    Divider.Parent = HubFrame

    local ScrollList = Instance.new("ScrollingFrame")
    ScrollList.Size = UDim2.new(1, -30, 1, -70)
    ScrollList.Position = UDim2.new(0, 15, 0, 60)
    ScrollList.BackgroundTransparency = 1
    ScrollList.BorderSizePixel = 0
    ScrollList.ScrollBarThickness = 3
    ScrollList.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 200)
    ScrollList.Parent = HubFrame
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = ScrollList
    ListLayout.Padding = UDim.new(0, 10)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local function buatTombolScript(nama, urlRawGithub)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 44)
        btn.Text = "    " .. nama
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.BackgroundTransparency = 0.4
        btn.TextColor3 = Color3.fromRGB(230, 230, 230)
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = ScrollList
        applyCorner(btn, 10)
        applyStroke(btn, Color3.fromRGB(150, 150, 150), 0.8)

        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        end)

        btn.MouseButton1Down:Connect(function()
            btn.Text = "    Loading..."
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            task.wait(0.4) 
            pcall(function() HubGui:Destroy() end)
            
            loadstring(game:HttpGet(urlRawGithub))()
        end)
    end

    buatTombolScript(
        "Ride Storm 🌌", 
        "https://raw.githubusercontent.com/litedirt67/LitedirtVV/refs/heads/Litedirt-scriptlua/WMWMWMWMWMWMWMWMWMWM.LUA"
    )

    buatTombolScript(
        "Ride a Pet 🐾", 
        "https://raw.githubusercontent.com/litedirt67/LitedirtVV/refs/heads/Litedirt-scriptlua/Ride_a_pet"
    )

    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end)
end)

if not successStart then
    print("GUI load failed: ", tostring(err))
end
