--[[
    LITEDIRT UI LIBRARY - Final Integrated Collapse & HUD Edition
]]--

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

-- Simpan status default lighting awal game
local defaultLighting = {
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Brightness = Lighting.Brightness,
    FogEnd = Lighting.FogEnd,
    ClockTime = Lighting.ClockTime,
    GeographicLatitude = Lighting.GeographicLatitude
}

-- Pelacakan Nilai Uang & Income Live
local startingMoney = 0
local sessionIncome = 0
local targetMoneyValue = nil

task.spawn(function()
    while true do
        pcall(function()
            local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
            if leaderstats then
                local moneyStat = leaderstats:FindFirstChild("Money") or leaderstats:FindFirstChild("Cash") or leaderstats:FindFirstChild("Coins") or leaderstats:FindFirstChild("$")
                if moneyStat then
                    targetMoneyValue = moneyStat
                    local currentMoney = moneyStat.Value
                    if startingMoney == 0 and currentMoney > 0 then
                        startingMoney = currentMoney
                    end
                    if startingMoney > 0 then
                        sessionIncome = currentMoney - startingMoney
                        if sessionIncome < 0 then sessionIncome = 0 end
                    end
                end
            end
        end)
        task.wait(1)
    end
end)

local LiteDirtLib = {}

function LiteDirtLib:CreateWindow(titleText)
    if CoreGui:FindFirstChild("LiteDirtLibrary") then
        CoreGui["LiteDirtLibrary"]:Destroy()
    end

    local LiteDirtLibrary = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local UIStroke = Instance.new("UIStroke")
    local TopBar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local CloseButton = Instance.new("TextButton")
    local CollapseButton = Instance.new("TextButton")
    local TopHUDText = Instance.new("TextLabel")

    local TabHeader = Instance.new("ScrollingFrame")
    local TabListLayout = Instance.new("UIListLayout")
    local TabPadding = Instance.new("UIPadding")

    LiteDirtLibrary.Name = "LiteDirtLibrary"
    LiteDirtLibrary.Parent = CoreGui
    LiteDirtLibrary.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    MainFrame.Name = "MainFrame"
    MainFrame.Parent = LiteDirtLibrary
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BackgroundTransparency = 0.35
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -190, 0.5, -140)
    MainFrame.Size = UDim2.new(0, 380, 0, 280)

    UICorner.CornerRadius = UDim.new(0, 16)
    UICorner.Parent = MainFrame

    UIStroke.Parent = MainFrame
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Transparency = 0.8
    UIStroke.Thickness = 1

    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundTransparency = 1.00
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(0, 380, 0, 35)

    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1.00
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = titleText or "[ LITEDIRT ]"
    Title.TextColor3 = Color3.fromRGB(245, 245, 245)
    Title.TextSize = 14.00
    Title.TextXAlignment = Enum.TextXAlignment.Center

    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TopBar
    CloseButton.BackgroundTransparency = 1.00
    CloseButton.Position = UDim2.new(0.9, 0, 0.15, 0)
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(200, 80, 80)
    CloseButton.TextSize = 13.00

    CloseButton.MouseButton1Click:Connect(function()
        LiteDirtLibrary:Destroy()
    end)

    local activeContainer = nil
    local isCollapsed = false

    CollapseButton.Name = "CollapseButton"
    CollapseButton.Parent = TopBar
    CollapseButton.BackgroundTransparency = 1.00
    CollapseButton.Position = UDim2.new(0.03, 0, 0.15, 0)
    CollapseButton.Size = UDim2.new(0, 25, 0, 25)
    CollapseButton.Font = Enum.Font.GothamBold
    CollapseButton.Text = "-"
    CollapseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    CollapseButton.TextSize = 16.00

    TopHUDText.Name = "TopHUDText"
    TopHUDText.Parent = TopBar
    TopHUDText.BackgroundTransparency = 1.00
    TopHUDText.Position = UDim2.new(0, 35, 0, 5)
    TopHUDText.Size = UDim2.new(0, 200, 0, 25)
    TopHUDText.Font = Enum.Font.GothamBold
    TopHUDText.TextColor3 = Color3.fromRGB(255, 255, 255)
    TopHUDText.TextSize = 10.00
    TopHUDText.Text = "MONEY: $0 | INCOME: +$0"
    TopHUDText.TextXAlignment = Enum.TextXAlignment.Left

    task.spawn(function()
        while TopHUDText and TopHUDText.Parent do
            pcall(function()
                if targetMoneyValue then
                    local currentMoney = targetMoneyValue.Value
                    TopHUDText.Text = string.format("     MONEY: $%d |                                                  | INCOME: +$%d", currentMoney, sessionIncome)
                end
            end)
            task.wait(1)
        end
    end)

    CollapseButton.MouseButton1Click:Connect(function()
        isCollapsed = not isCollapsed
        TabHeader.Visible = not isCollapsed
        if activeContainer then
            activeContainer.Visible = not isCollapsed
        end

        if isCollapsed then
            TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 380, 0, 35)}):Play()
            CollapseButton.Text = "+"
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 380, 0, 280)}):Play()
            CollapseButton.Text = "-"
        end
    end)

    TabHeader.Name = "TabHeader"
    TabHeader.Parent = MainFrame
    TabHeader.Active = true
    TabHeader.BackgroundTransparency = 1.00
    TabHeader.BorderSizePixel = 0
    TabHeader.Position = UDim2.new(0, 0, 0, 38)
    TabHeader.Size = UDim2.new(0, 380, 0, 35)
    TabHeader.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabHeader.ScrollBarThickness = 0
    TabHeader.ScrollingDirection = Enum.ScrollingDirection.X

    TabListLayout.Parent = TabHeader
    TabListLayout.FillDirection = Enum.FillDirection.Horizontal
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 8)

    TabPadding.Parent = TabHeader
    TabPadding.PaddingLeft = UDim.new(0, 15)

    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabHeader.CanvasSize = UDim2.new(0, TabListLayout.AbsoluteContentSize.X + 30, 0, 0)
    end)

    local dragging, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local Window = {}
    local firstTab = true

    function Window:AddTab(tabName)
        local TabButton = Instance.new("TextButton")
        local TabCorner = Instance.new("UICorner")
        local TabStroke = Instance.new("UIStroke")

        local Container = Instance.new("ScrollingFrame")
        local UIListLayout = Instance.new("UIListLayout")
        local UIPadding = Instance.new("UIPadding")

        TabButton.Name = "TabButton"
        TabButton.Parent = TabHeader
        TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.BackgroundTransparency = 0.85
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(0, 95, 0, 28)
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.TextColor3 = Color3.fromRGB(220, 220, 220)
        TabButton.TextSize = 12.00
        TabButton.Text = tabName

        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = TabButton

        TabStroke.Parent = TabButton
        TabStroke.Color = Color3.fromRGB(255, 255, 255)
        TabStroke.Transparency = 0.7
        TabStroke.Thickness = 1

        Container.Name = "Container"
        Container.Parent = MainFrame
        Container.Active = true
        Container.BackgroundTransparency = 1.00
        Container.BorderSizePixel = 0
        Container.Position = UDim2.new(0, 0, 0, 80)
        Container.Size = UDim2.new(0, 380, 0, 190)
        Container.CanvasSize = UDim2.new(0, 0, 0, 0)
        Container.ScrollBarThickness = 2
        Container.Visible = false

        UIListLayout.Parent = Container
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 10)

        UIPadding.Parent = Container
        UIPadding.PaddingTop = UDim.new(0, 5)

        UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
        end)

        if firstTab then
            Container.Visible = true
            activeContainer = Container
            TabButton.BackgroundTransparency = 0.50
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            firstTab = false
        end

        TabButton.MouseButton1Click:Connect(function()
            if isCollapsed then return end
            for _, v in pairs(MainFrame:GetChildren()) do
                if v:IsA("ScrollingFrame") and v.Name == "Container" then
                    v.Visible = false
                end
            end
            for _, v in pairs(TabHeader:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.2), {BackgroundTransparency = 0.85}):Play()
                    v.TextColor3 = Color3.fromRGB(180, 180, 180)
                end
            end
            Container.Visible = true
            activeContainer = Container
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.50}):Play()
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        local TabFunctions = {}

        function TabFunctions:AddBoard(noticeText, customHeight)
            local BoardFrame = Instance.new("Frame")
            local BoardCorner = Instance.new("UICorner")
            local BoardStroke = Instance.new("UIStroke")
            local BoardLabel = Instance.new("TextLabel")

            BoardFrame.Name = "NoticeBoard"
            BoardFrame.Parent = Container
            BoardFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            BoardFrame.BackgroundTransparency = 0.92
            BoardFrame.BorderSizePixel = 0
            BoardFrame.Size = UDim2.new(0, 350, 0, customHeight or 65)

            BoardCorner.CornerRadius = UDim.new(0, 10)
            BoardCorner.Parent = BoardFrame

            BoardStroke.Parent = BoardFrame
            BoardStroke.Color = Color3.fromRGB(255, 255, 255)
            BoardStroke.Transparency = 0.75
            BoardStroke.Thickness = 1

            BoardLabel.Name = "BoardText"
            BoardLabel.Parent = BoardFrame
            BoardLabel.BackgroundTransparency = 1.00
            BoardLabel.Position = UDim2.new(0.04, 0, 0.05, 0)
            BoardLabel.Size = UDim2.new(0.92, 0, 0.9, 0)
            BoardLabel.Font = Enum.Font.GothamMedium
            BoardLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
            BoardLabel.TextSize = 11.00
            BoardLabel.Text = noticeText
            BoardLabel.TextXAlignment = Enum.TextXAlignment.Left
            BoardLabel.TextYAlignment = Enum.TextYAlignment.Center
            BoardLabel.TextWrapped = true

            return BoardLabel
        end

        function TabFunctions:AddButton(buttonText, callback)
            local Button = Instance.new("TextButton")
            Button.Name = buttonText
            Button.Parent = Container
            Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Button.BackgroundTransparency = 0.90
            Button.BorderSizePixel = 0
            Button.Size = UDim2.new(0, 350, 0, 38)
            Button.Font = Enum.Font.GothamMedium
            Button.TextColor3 = Color3.fromRGB(220, 220, 220)
            Button.TextSize = 12.00
            Button.Text = buttonText or ""

            local ButtonCorner = Instance.new("UICorner", Button)
            ButtonCorner.CornerRadius = UDim.new(0, 10)

            local ButtonStroke = Instance.new("UIStroke", Button)
            ButtonStroke.Color = Color3.fromRGB(255, 255, 255)
            ButtonStroke.Transparency = 0.7
            ButtonStroke.Thickness = 1

            local toggled = false

            Button.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                if buttonText == "Auto Job" or buttonText:find("Graphics") then
                    if toggled then
                        if buttonText:find("Graphics") then
                            for _, child in pairs(Container:GetChildren()) do
                                if child:IsA("TextButton") and child.Name:find("Graphics") and child ~= Button then
                                    child:SetAttribute("ForceOff", true)
                                end
                            end
                        end

                        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(46, 204, 113), BackgroundTransparency = 0.5}):Play()
                        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                    else
                        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.90}):Play()
                        Button.TextColor3 = Color3.fromRGB(220, 220, 220)
                    end
                else
                    TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundTransparency = 0.75}):Play()
                    task.wait(0.1)
                    TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundTransparency = 0.90}):Play()
                end

                if callback then
                    pcall(function()
                        callback(toggled)
                    end)
                end
            end)

            return Button
        end

        function TabFunctions:AddLabel(labelText)
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.Parent = Container
            Label.BackgroundTransparency = 1.00
            Label.Size = UDim2.new(0, 350, 0, 20)
            Label.Font = Enum.Font.GothamMedium
            Label.TextColor3 = Color3.fromRGB(180, 180, 180)
            Label.TextSize = 12.00
            Label.Text = labelText
            Label.TextXAlignment = Enum.TextXAlignment.Left
        end

        return TabFunctions
    end

    return Window
end

-- ========================================================
-- IMPLEMENTASI UTAMA
-- ========================================================

local Window = LiteDirtLib:CreateWindow("[ LITEDIRT ]")

-- TAB HOME
local Tab1 = Window:AddTab("Home")
Tab1:AddBoard("Tutorial:\n1. Take job | Ambil pekerjaan\n2. Subscribe | Berlangganan\n3. Turn on auto job | Nyalakan auto", 60)

local autoJobRunning = false

Tab1:AddButton("Auto Job", function(state)
    autoJobRunning = state
    
    if autoJobRunning then
        pcall(function()
            if targetMoneyValue then
                startingMoney = targetMoneyValue.Value
            end
        end)
        
        task.spawn(function()
            local coords = {
                {Y = 2078, X = -1587, Z = -1820},
                {Y = 2111, X = 13968, Z = 7278},
                {Y = 2076, X = -1074, Z = -7919},
                {Y = 2231, X = -4278, Z = 22925}
            }
            
            while autoJobRunning do
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local hrp = character.HumanoidRootPart
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    
                    for _, pos in ipairs(coords) do
                        if not autoJobRunning then break end
                        
                        pcall(function()
                            if humanoid then humanoid.Sit = false end
                            hrp.Anchored = true
                            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            hrp.CFrame = CFrame.new(pos.X, pos.Y + 3, pos.Z)
                            task.wait(0.15)
                            hrp.Anchored = false
                        end)
                        
                        local startTime = tick()
                        while autoJobRunning and (tick() - startTime < 0.5) do
                            for _, obj in pairs(Workspace:GetDescendants()) do
                                if obj:IsA("ProximityPrompt") then
                                    local parentPart = obj.Parent
                                    if parentPart and parentPart:IsA("BasePart") then
                                        local distance = (hrp.Position - parentPart.Position).Magnitude
                                        if distance <= 15 then
                                            local parentName = parentPart.Name:lower()
                                            local promptText = (obj.ActionText .. " " .. obj.ObjectText):lower()
                                            
                                            if not parentName:find("car") and not parentName:find("vehicle") and not parentName:find("bike") then
                                                if promptText:find("delivery") or promptText:find("job") or promptText:find("take") then
                                                    pcall(function()
                                                        obj.HoldDuration = 0
                                                        fireproximityprompt(obj)
                                                    end)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            task.wait(0.02)
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

-- TAB MISC
local Tab2 = Window:AddTab("Misc")
Tab2:AddLabel("Pilihan Grafik / Graphics")

local function resetGraphicsToDefault()
    pcall(function()
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") or v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") or v:IsA("BlurEffect") then
                v:Destroy()
            end
        end
        Lighting.GlobalShadows = defaultLighting.GlobalShadows
        Lighting.Ambient = defaultLighting.Ambient
        Lighting.OutdoorAmbient = defaultLighting.OutdoorAmbient
        Lighting.Brightness = defaultLighting.Brightness
        Lighting.FogEnd = defaultLighting.FogEnd
        Lighting.ClockTime = defaultLighting.ClockTime
        Lighting.GeographicLatitude = defaultLighting.GeographicLatitude
    end)
end

Tab2:AddButton("Graphics 1", function(state)
    if state then
        resetGraphicsToDefault()
        Lighting.GlobalShadows = true
        Lighting.Brightness = 1.2
        Lighting.ClockTime = 6.5
        Lighting.GeographicLatitude = 45
        Lighting.Ambient = Color3.fromRGB(150, 180, 210)
        Lighting.OutdoorAmbient = Color3.fromRGB(120, 160, 200)
        Lighting.FogEnd = 2500
        Lighting.FogColor = Color3.fromRGB(160, 190, 220)
        local atmosphere = Instance.new("Atmosphere", Lighting)
        atmosphere.Name = "LiteDirtAtmosphere"
        atmosphere.Density = 0.35
        atmosphere.Offset = 0.25
        atmosphere.Color = Color3.fromRGB(170, 200, 230)
        atmosphere.Decay = Color3.fromRGB(90, 120, 160)
        atmosphere.Glare = 0.1
        atmosphere.Haze = 1.5
        local bloom = Instance.new("BloomEffect", Lighting)
        bloom.Name = "LiteDirtBloom"
        bloom.Intensity = 0.2
        bloom.Size = 32
        bloom.Threshold = 0.8
        local colorCorrection = Instance.new("ColorCorrectionEffect", Lighting)
        colorCorrection.Name = "LiteDirtCC"
        colorCorrection.Saturation = 0.05
        colorCorrection.Contrast = 0.15
        colorCorrection.TintColor = Color3.fromRGB(210, 230, 255)
    else
        resetGraphicsToDefault()
    end
end)

Tab2:AddButton("Graphics 2", function(state)
    if state then
        resetGraphicsToDefault()
        pcall(function()
            loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-HD-graphics-206215"))()
        end)
    else
        resetGraphicsToDefault()
    end
end)
