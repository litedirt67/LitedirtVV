-- PurpleLib.lua & LITEDIRT HUB (Final English Version)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local Lib = {}

----------------------------------------------------------------
-- THEME & DYNAMIC COLORS (BACKGROUND REMAINS UNTOUCHED)
----------------------------------------------------------------
local WHITE = Color3.new(1, 1, 1)
local TXT = Color3.fromRGB(246, 242, 255)
local DIM = Color3.fromRGB(190, 170, 230)
local ACCENT = Color3.fromRGB(150, 85, 255)

local PURPLE_BASE = Color3.fromRGB(175, 115, 255)
local SHADE = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(150, 110, 200))

local allThemeSurfaces = {}
local currentGlow, currentBorderGradient

local function new(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do o[k] = v end
	if parent then o.Parent = parent end
	return o
end

local function corner(parent, r) return new("UICorner", { CornerRadius = UDim.new(0, r or 8) }, parent) end
local function stroke(parent, color, thickness, transparency)
	return new("UIStroke", { Color = color or WHITE, Thickness = thickness or 1, Transparency = transparency or 0.8, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, parent)
end

local function purpleSurface(obj)
	obj.BackgroundColor3 = PURPLE_BASE
	local grad = new("UIGradient", { Rotation = 90, Color = SHADE }, obj)
	table.insert(allThemeSurfaces, obj)
	return grad
end

local function gloss(parent, r)
	local g = new("Frame", {
		Size = UDim2.new(1, -6, 0.5, -2),
		Position = UDim2.new(0, 3, 0, 2),
		BackgroundColor3 = WHITE,
		BorderSizePixel = 0,
	}, parent)
	corner(g, r or 8)
	new("UIGradient", {
		Rotation = 90,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.3),
			NumberSequenceKeypoint.new(1, 0.95),
		}),
	}, g)
	return g
end

local function updateThemeColor(newColor)
	PURPLE_BASE = newColor
	ACCENT = newColor
	
	-- Only buttons, tabs, glows, and borders change. Background stays safe!
	for _, obj in ipairs(allThemeSurfaces) do
		if obj and obj.Parent then
			obj.BackgroundColor3 = newColor
		end
	end
	
	if currentGlow and currentGlow.Parent then
		currentGlow.BackgroundColor3 = Color3.new(newColor.R * 0.85, newColor.G * 0.85, newColor.B * 0.85)
	end
	
	if currentBorderGradient and currentBorderGradient.Parent then
		currentBorderGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(math.min(newColor.R * 1.3, 1), math.min(newColor.G * 1.3, 1), math.min(newColor.B * 1.3, 1))),
			ColorSequenceKeypoint.new(0.5, newColor),
			ColorSequenceKeypoint.new(1, Color3.new(math.min(newColor.R * 1.3, 1), math.min(newColor.G * 1.3, 1), math.min(newColor.B * 1.3, 1))),
		})
	end
end

----------------------------------------------------------------
-- WINDOW BUILDER
----------------------------------------------------------------
function Lib.Window(titleText)
	local pg = player:WaitForChild("PlayerGui")
	local guiName = "PurpleLib_" .. tostring(titleText)
	local old = pg:FindFirstChild(guiName)
	if old then old:Destroy() end

	local gui = new("ScreenGui", { Name = guiName, ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling }, pg)
	local BAR_H, SIDE_W, W, H = 36, 104, 420, 310
	local FULL = UDim2.new(0, W, 0, H)

	local win = new("Frame", {
		Size = FULL,
		Position = UDim2.new(0.5, -W / 2, 0.5, -H / 2),
		BackgroundColor3 = WHITE,
		BackgroundTransparency = 0.2,
		BorderSizePixel = 0,
	}, gui)
	corner(win, 18)
	
	local split = SIDE_W / W
	new("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 14, 50)),
			ColorSequenceKeypoint.new(split, Color3.fromRGB(26, 14, 50)),
			ColorSequenceKeypoint.new(split + 0.001, Color3.fromRGB(48, 28, 86)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(48, 28, 86)),
		}),
	}, win)

	local shine = new("Frame", {
		Size = UDim2.new(1, 0, 0.5, 0),
		BackgroundColor3 = WHITE,
		BorderSizePixel = 0,
	}, win)
	corner(shine, 18)
	new("UIGradient", {
		Rotation = 90,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.74),
			NumberSequenceKeypoint.new(1, 1),
		}),
	}, shine)

	local edge = new("Frame", {
		Size = UDim2.new(1, -36, 0, 1),
		Position = UDim2.new(0, 18, 0, 2),
		BackgroundColor3 = WHITE,
		BorderSizePixel = 0,
	}, win)
	new("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.5, 0.35),
			NumberSequenceKeypoint.new(1, 1),
		}),
	}, edge)

	currentGlow = new("Frame", {
		Size = UDim2.new(1, 0, 0.45, 0),
		Position = UDim2.new(0, 0, 0.55, 0),
		BackgroundColor3 = Color3.fromRGB(150, 80, 255),
		BorderSizePixel = 0,
	}, win)
	corner(currentGlow, 18)
	new("UIGradient", {
		Rotation = 90,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(1, 0.7),
		}),
	}, currentGlow)

	local border = stroke(win, WHITE, 2, 0.1)
	currentBorderGradient = new("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(215, 165, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(125, 65, 240)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(215, 165, 255)),
		})
	}, border)
	
	pcall(function()
		TweenService:Create(currentBorderGradient, TweenInfo.new(6, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), { Rotation = 360 }):Play()
		TweenService:Create(border, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { Transparency = 0.5 }):Play()
	end)

	new("Frame", {
		Size = UDim2.new(0, 1, 1, -24),
		Position = UDim2.new(0, SIDE_W, 0, 12),
		BackgroundColor3 = WHITE,
		BackgroundTransparency = 0.85,
		BorderSizePixel = 0,
	}, win)

	local bar = new("Frame", {
		Size = UDim2.new(1, 0, 0, BAR_H),
		BackgroundTransparency = 1,
		Active = true,
	}, win)

	new("TextLabel", {
		Size = UDim2.new(0, SIDE_W - 8, 1, 0),
		Position = UDim2.new(0, 14, 0, 0),
		BackgroundTransparency = 1,
		Text = titleText,
		TextColor3 = TXT,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, bar)

	local function circleBtn(xOffset, baseColor, text)
		local holder = new("Frame", {
			Size = UDim2.new(0, 24, 0, 24),
			Position = UDim2.new(1, xOffset, 0.5, -12),
			BackgroundTransparency = 0.05,
			BorderSizePixel = 0,
		}, bar)
		holder.BackgroundColor3 = baseColor
		new("UIGradient", { Rotation = 90, Color = SHADE }, holder)
		corner(holder, 12)
		stroke(holder, WHITE, 1, 0.5)
		gloss(holder, 10)

		return new("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = text,
			TextColor3 = WHITE,
			Font = Enum.Font.GothamBold,
			TextSize = 13,
			AutoButtonColor = false,
			BorderSizePixel = 0,
		}, holder)
	end

	local closeBtn = circleBtn(-34, Color3.fromRGB(240, 120, 240), "X")
	local collapseBtn = circleBtn(-64, Color3.fromRGB(180, 130, 255), "–")

	local body = new("Frame", {
		Size = UDim2.new(1, 0, 1, -BAR_H),
		Position = UDim2.new(0, 0, 0, BAR_H),
		BackgroundTransparency = 1,
	}, win)

	local sidebar = new("Frame", {
		Size = UDim2.new(0, SIDE_W, 1, -8),
		BackgroundTransparency = 1,
	}, body)
	new("UIListLayout", { Padding = UDim.new(0, 6) }, sidebar)
	new("UIPadding", {
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
		PaddingTop = UDim.new(0, 4),
	}, sidebar)

	local content = new("Frame", {
		Size = UDim2.new(1, -(SIDE_W + 22), 1, -12),
		Position = UDim2.new(0, SIDE_W + 14, 0, 2),
		BackgroundTransparency = 1,
	}, body)

	local collapsed = false
	collapseBtn.MouseButton1Click:Connect(function()
		collapsed = not collapsed
		body.Visible = not collapsed
		win.Size = collapsed and UDim2.new(0, W, 0, BAR_H) or FULL
		collapseBtn.Text = collapsed and "+" or "–"
	end)
	closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

	local dragging, dragStart, startPos
	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = win.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local d = input.Position - dragStart
			win.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + d.X,
				startPos.Y.Scale, startPos.Y.Offset + d.Y
			)
		end
	end)

	local window = { Gui = gui }
	local tabs = {}

	local function selectTab(t)
		for _, other in ipairs(tabs) do
			local on = (other == t)
			other.page.Visible = on
			other.holder.BackgroundTransparency = on and 0.05 or 1
			other.gloss.Visible = on
			other.outline.Transparency = on and 0.5 or 1
			other.btn.TextColor3 = on and WHITE or DIM
		end
	end

	function window:AddTab(name)
		local holder = new("Frame", { Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, BorderSizePixel = 0 }, sidebar)
		purpleSurface(holder)
		corner(holder, 10)
		local outline = stroke(holder, WHITE, 1, 1)
		local tabGloss = gloss(holder, 8)
		tabGloss.Visible = false

		local btn = new("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, Text = name, TextColor3 = DIM, Font = Enum.Font.GothamMedium, TextSize = 12, AutoButtonColor = false }, holder)
		local page = new("ScrollingFrame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, ScrollBarImageColor3 = ACCENT }, content)
		new("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, page)
		new("UIPadding", { PaddingRight = UDim.new(0, 4) }, page)

		local tab = { btn = btn, holder = holder, gloss = tabGloss, outline = outline, page = page }
		table.insert(tabs, tab)
		btn.MouseButton1Click:Connect(function() selectTab(tab) end)
		if #tabs == 1 then selectTab(tab) end

		function tab:AddSection(text)
			return new("TextLabel", { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = string.upper(text), TextColor3 = Color3.fromRGB(215, 175, 255), Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left }, page)
		end
		function tab:AddLabel(text)
			return new("TextLabel", { Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = text, TextColor3 = DIM, Font = Enum.Font.Gotham, TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left }, page)
		end
		function tab:AddButton(text, callback)
			local holder2 = new("Frame", { Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 0.05, BorderSizePixel = 0 }, page)
			purpleSurface(holder2)
			corner(holder2, 10)
			stroke(holder2, WHITE, 1, 0.5)
			gloss(holder2, 8)
			local b = new("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, Text = text, TextColor3 = WHITE, Font = Enum.Font.GothamBold, TextSize = 13, AutoButtonColor = false }, holder2)
			b.MouseButton1Click:Connect(callback)
			return b
		end
		function tab:AddToggle(text, default, callback)
			local row = new("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1 }, page)
			new("TextLabel", { Size = UDim2.new(1, -60, 1, 0), BackgroundTransparency = 1, Text = text, TextColor3 = TXT, Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left }, row)

			local OFF = Color3.fromRGB(140, 130, 165)
			local track = new("Frame", { Size = UDim2.new(0, 46, 0, 26), Position = UDim2.new(1, -46, 0.5, -13), BackgroundColor3 = OFF, BackgroundTransparency = 0.4, BorderSizePixel = 0 }, row)
			corner(track, 13)
			stroke(track, WHITE, 1, 0.6)
			local shade = new("UIGradient", { Rotation = 90, Color = SHADE, Enabled = false }, track)
			gloss(track, 10)
			local knob = new("Frame", { Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(0, 2, 0.5, -11), BackgroundColor3 = WHITE, BorderSizePixel = 0 }, track)
			corner(knob, 11)
			local hit = new("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false }, track)

			local state = default and true or false
			local function render()
				shade.Enabled = state
				track.BackgroundColor3 = state and PURPLE_BASE or OFF
				track.BackgroundTransparency = state and 0.02 or 0.4
				knob.Position = state and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
			end
			render()
			hit.MouseButton1Click:Connect(function()
				state = not state
				render()
				callback(state)
			end)
			return { Set = function(v) state = v and true or false render() end }
		end
		return tab
	end
	return window
end

----------------------------------------------------------------
-- CONTENT (LITEDIRT HUB - AUTOFARM MAXSPEED)
----------------------------------------------------------------
local win = Lib.Window("LITEDIRT HUB")

-- Pattern Coordinates: 1-1-2-2-3-3-4-4-1
local P1 = Vector3.new(-1586, 2078, -1820)
local P2 = Vector3.new(13969, 2112, 7280)
local P3 = Vector3.new(-1076, 2077, -7919)
local P4 = Vector3.new(-4282, 2231, 22922)

local coords = {
	P1, P1,
	P2, P2,
	P3, P3,
	P4, P4,
	P1
}

local function getClosestPrompt()
	local char = player.Character
	if not char then return nil end
	local rootPart = char:FindFirstChild("HumanoidRootPart")
	if not rootPart then return nil end
	
	local closestPrompt = nil
	local shortestDistance = 35
	
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("ProximityPrompt") then
			local parentPart = obj.Parent
			if parentPart and parentPart:IsA("BasePart") then
				local distance = (parentPart.Position - rootPart.Position).Magnitude
				if distance < shortestDistance then
					shortestDistance = distance
					closestPrompt = obj
				end
			end
		end
	end
	return closestPrompt
end

local function teleportAndSmartInteract(pos)
	local char = player.Character
	if not char then return end
	local rootPart = char:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end
	
	rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
	char:PivotTo(CFrame.new(pos))
	rootPart.CFrame = CFrame.new(pos)
	
	task.wait(0.15)
	
	local targetPrompt = getClosestPrompt()
	if targetPrompt then
		pcall(function()
			fireproximityprompt(targetPrompt)
		end)
	end
end

-- AUTOFARM Tab
local tabInteract = win:AddTab("AUTOFARM")
tabInteract:AddSection("Autofarm - delivery")

local autoDeliveryActive = false

task.spawn(function()
	while true do
		if autoDeliveryActive then
			for i, pos in ipairs(coords) do
				if not autoDeliveryActive then break end
				teleportAndSmartInteract(pos)
				task.wait(0.2)
			end
		end
		task.wait(0.05)
	end
end)

tabInteract:AddToggle("AUTO DELIVERY", false, function(on)
	autoDeliveryActive = on
end)

-- Settings Tab (Theme Customizer)
local tabSettings = win:AddTab("Settings")
tabSettings:AddSection("UI Color Customization")
tabSettings:AddLabel("Select Hub theme color:")

tabSettings:AddButton("Classic Purple (Default)", function()
	updateThemeColor(Color3.fromRGB(175, 115, 255))
end)

tabSettings:AddButton("Vibrant Red", function()
	updateThemeColor(Color3.fromRGB(255, 75, 75))
end)

tabSettings:AddButton("Electric Blue", function()
	updateThemeColor(Color3.fromRGB(85, 130, 255))
end)

tabSettings:AddButton("Neon Green", function()
	updateThemeColor(Color3.fromRGB(85, 255, 120))
end)

tabSettings:AddButton("Golden Yellow", function()
	updateThemeColor(Color3.fromRGB(255, 205, 75))
end)

-- Info Tab (With Owner, Copyright & Discord Link)
local tabInfo = win:AddTab("Info")
tabInfo:AddSection("Script Information")
tabInfo:AddLabel("Script Owner: @litedirt67")
tabInfo:AddLabel("Copyright (C) 2026 litedirt67. All Rights Reserved. Unauthorized copying, modification, or redistribution is strictly prohibited!")
tabInfo:AddSection("Discord Community")
tabInfo:AddLabel("Join our Discord for updates & more scripts:")
tabInfo:AddLabel("https://discord.gg/uxbwvhV9X")
