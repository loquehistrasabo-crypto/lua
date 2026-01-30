--[[
    FF2 2017 UI - Entirely new script
    Classic 2017-style UI | QB Aimbot | Mags | Automatics | Player
    No remote load - runs locally only
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- // 2017 theme
local Theme = {
    Background = Color3.fromRGB(22, 22, 22),
    Sidebar = Color3.fromRGB(28, 28, 28),
    Card = Color3.fromRGB(35, 35, 35),
    Border = Color3.fromRGB(55, 55, 55),
    Accent = Color3.fromRGB(220, 60, 60),
    Text = Color3.fromRGB(220, 220, 220),
    TextDim = Color3.fromRGB(140, 140, 140),
}

local function Create(cls, props)
    local o = Instance.new(cls)
    for k, v in pairs(props or {}) do
        if type(k) == "string" then
            o[k] = v
        end
    end
    return o
end

local function Drag(gui)
    local dragging, dragStart, startPos
    gui.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = gui.Position
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

-- // Build 2017 UI
local ScreenGui = Create("ScreenGui", {
    Name = "FF2_2017",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = (RunService:IsStudio() and LocalPlayer:FindFirstChild("PlayerGui")) or gethui and gethui() or LocalPlayer.PlayerGui
})

-- FOV circle for Mags (drawn when magsFovCircle is on)
local MagsFOVCircle = Create("Frame", {
    Name = "MagsFOVCircle",
    Size = UDim2.new(0, 400, 0, 400),
    Position = UDim2.new(0.5, -200, 0.5, -200),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Active = false,
    Parent = ScreenGui
})
Create("UICorner", { Parent = MagsFOVCircle, CornerRadius = UDim.new(1, 0) })
Create("UIStroke", { Parent = MagsFOVCircle, Color = Theme.Accent, Thickness = 2 })
MagsFOVCircle.Visible = false

local Main = Create("Frame", {
    Name = "Main",
    Size = UDim2.fromScale(0.32, 0.48),
    Position = UDim2.fromScale(0.34, 0.26),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    Parent = ScreenGui
})
Create("UICorner", { Parent = Main, CornerRadius = UDim.new(0, 6) })
Create("UIStroke", { Parent = Main, Color = Theme.Border, Thickness = 1 })
Drag(Main)

local TopBar = Create("Frame", {
    Name = "TopBar",
    Size = UDim2.new(1, 0, 0, 28),
    BackgroundColor3 = Theme.Sidebar,
    BorderSizePixel = 0,
    Parent = Main
})
Create("UICorner", { Parent = TopBar, CornerRadius = UDim.new(0, 6) })

local Title = Create("TextLabel", {
    Parent = TopBar,
    Size = UDim2.new(1, -12, 1, 0),
    Position = UDim2.new(0, 8, 0, 0),
    BackgroundTransparency = 1,
    Text = "  FF2 • 2017",
    TextColor3 = Theme.Text,
    TextSize = 14,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left
})

local Sidebar = Create("Frame", {
    Name = "Sidebar",
    Size = UDim2.new(0, 100, 1, -28),
    Position = UDim2.new(0, 0, 0, 28),
    BackgroundColor3 = Theme.Sidebar,
    BorderSizePixel = 0,
    Parent = Main
})
Create("UIPadding", { Parent = Sidebar, PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), PaddingLeft = UDim.new(0, 4) })

local Content = Create("ScrollingFrame", {
    Name = "Content",
    Size = UDim2.new(1, -108, 1, -36),
    Position = UDim2.new(0, 100, 0, 32),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Theme.Accent,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    Parent = Main
})
Create("UIPadding", { Parent = Content, PaddingTop = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4) })
Create("UIListLayout", { Parent = Content, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center })

local TabLayout = Create("UIListLayout", { Parent = Sidebar, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder })

local Tabs = {}
local CurrentTab = nil

local function TabButton(name, order)
    local btn = Create("TextButton", {
        Name = name,
        Size = UDim2.new(1, -8, 0, 28),
        BackgroundColor3 = Theme.Card,
        BorderSizePixel = 0,
        Text = "",
        Parent = Sidebar,
        LayoutOrder = order
    })
    Create("UICorner", { Parent = btn, CornerRadius = UDim.new(0, 4) })
    local lbl = Create("TextLabel", {
        Name = "TabLabel",
        Parent = btn,
        Size = UDim2.new(1, -8, 1, 0),
        Position = UDim2.new(0, 6, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Theme.TextDim,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    btn.MouseButton1Click:Connect(function()
        if CurrentTab then CurrentTab.Visible = false end
        Tabs[name].Visible = true
        CurrentTab = Tabs[name]
        lbl.TextColor3 = Theme.Accent
        for _, c in ipairs(Sidebar:GetChildren()) do
            if c:IsA("TextButton") and c ~= btn then
                local otherLbl = c:FindFirstChild("TabLabel")
                if otherLbl then otherLbl.TextColor3 = Theme.TextDim end
            end
        end
    end)
    return btn
end

local function AddTab(name, order)
    local frame = Create("Frame", {
        Name = name,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = Content.Parent
    })
    frame.Parent = Main
    frame.Size = UDim2.new(1, -108, 1, -36)
    frame.Position = UDim2.new(0, 100, 0, 32)
    local list = Create("UIListLayout", { Parent = frame, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder })
    local pad = Create("UIPadding", { Parent = frame, PaddingTop = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4) })
    Tabs[name] = frame
    TabButton(name, order)
    return frame
end

local function Section(parent, title)
    local f = Create("Frame", {
        Size = UDim2.new(1, -8, 0, 0),
        BackgroundColor3 = Theme.Card,
        BorderSizePixel = 0,
        Parent = parent,
        AutomaticSize = Enum.AutomaticSize.Y
    })
    Create("UICorner", { Parent = f, CornerRadius = UDim.new(0, 4) })
    Create("UIStroke", { Parent = f, Color = Theme.Border, Thickness = 1 })
    local list = Create("UIListLayout", { Parent = f, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder })
    Create("UIPadding", { Parent = f, PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })
    if title and title ~= "" then
        local t = Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = Theme.TextDim,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = f,
            LayoutOrder = 0
        })
    end
    return f
end

local function Toggle(parent, label, default, callback)
    local on = default
    local row = Create("Frame", { Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Parent = parent, AutomaticSize = Enum.AutomaticSize.Y })
    local lbl = Create("TextLabel", {
        Size = UDim2.new(1, -60, 0, 24),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Theme.Text,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row
    })
    local box = Create("TextButton", {
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -44, 0, 2),
        BackgroundColor3 = on and Theme.Accent or Theme.Border,
        BorderSizePixel = 0,
        Text = "",
        Parent = row
    })
    Create("UICorner", { Parent = box, CornerRadius = UDim.new(0, 4) })
    box.MouseButton1Click:Connect(function()
        on = not on
        box.BackgroundColor3 = on and Theme.Accent or Theme.Border
        if callback then callback(on) end
    end)
    row.LayoutOrder = 999
    return row
end

local function Slider(parent, label, minVal, maxVal, default, callback)
    local val = math.clamp(default or minVal, minVal, maxVal)
    local row = Create("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Parent = parent })
    local lbl = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        Text = label .. " (" .. tostring(val) .. ")",
        TextColor3 = Theme.Text,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row
    })
    local track = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 0, 20),
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,
        Parent = row
    })
    Create("UICorner", { Parent = track, CornerRadius = UDim.new(1, 0) })
    local fill = Create("Frame", {
        Size = UDim2.new((val - minVal) / (maxVal - minVal), 0, 1, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Parent = track
    })
    Create("UICorner", { Parent = fill, CornerRadius = UDim.new(1, 0) })
    local grab
    local function update(input)
        local rel = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
        val = math.clamp(math.floor(minVal + rel * (maxVal - minVal) + 0.5), minVal, maxVal)
        fill.Size = UDim2.new((val - minVal) / (maxVal - minVal), 0, 1, 0)
        lbl.Text = label .. " (" .. tostring(val) .. ")"
        if callback then callback(val) end
    end
    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then grab = true update(i) end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then grab = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if grab and i.UserInputType == Enum.UserInputType.MouseMovement then update(i) end
    end)
    row.LayoutOrder = 999
    return row
end

local function Dropdown(parent, label, options, default, callback)
    local cur = default or (options and options[1])
    local row = Create("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, Parent = parent })
    local lbl = Create("TextLabel", {
        Size = UDim2.new(1, -80, 0, 18),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Theme.Text,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row
    })
    local btn = Create("TextButton", {
        Size = UDim2.new(0, 72, 0, 22),
        Position = UDim2.new(1, -76, 0, 0),
        BackgroundColor3 = Theme.Card,
        BorderSizePixel = 0,
        Text = tostring(cur),
        TextColor3 = Theme.TextDim,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        Parent = row
    })
    Create("UICorner", { Parent = btn, CornerRadius = UDim.new(0, 4) })
    local open = false
    btn.MouseButton1Click:Connect(function()
        open = not open
        if open and options and #options > 0 then
            local idx = (table.find(options, cur) or 1)
            idx = (idx % #options) + 1
            cur = options[idx]
            btn.Text = tostring(cur)
            if callback then callback(cur) end
        end
        open = false
    end)
    row.LayoutOrder = 999
    return row
end

-- // QB Aimbot
local function GetScreenPoint(part)
    return Camera:WorldToViewportPoint(part.Position)
end

local function GetNearestToMouse(teamCheck, includeBots)
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    local nearest = nil
    local nearestDist = math.huge
    local myChar = LocalPlayer.Character
    local myTeam = LocalPlayer.Team
    if not myChar then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and not (teamCheck and myTeam and p.Team == myTeam) then
            local c = p.Character
            if c then
                local hrp = c:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local screen, onScreen = GetScreenPoint(hrp)
                    local v2 = Vector2.new(screen.X, screen.Y)
                    local d = (v2 - mousePos).Magnitude
                    if d < nearestDist then
                        nearestDist = d
                        nearest = hrp
                    end
                end
            end
        end
    end
    if includeBots then
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj.Name == "npcwr" then
                local a, b = obj:FindFirstChild("a"), obj:FindFirstChild("b")
                for _, set in ipairs({ a, b }) do
                    if set then
                        for _, bot in ipairs(set:GetChildren()) do
                            local hrp = bot:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local screen, _ = GetScreenPoint(hrp)
                                local v2 = Vector2.new(screen.X, screen.Y)
                                local d = (v2 - mousePos).Magnitude
                                if d < nearestDist then
                                    nearestDist = d
                                    nearest = hrp
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return nearest
end

local aimbotOn = false
local aimbotTeamCheck = true
local aimbotBots = true
local aimbotFov = 200
local silentAim = false -- camera lock style

-- // ========== FULL QB AIMBOT (throw math, beam, lead, fireServer) ========== --
local FF2Grav = 28
local QBThrowType = "Dime"
local QBData = {
	Direction = Vector3.new(0, 0, 0),
	NormalPower = 55,
	BulletModeAngle = 5,
	FadeModeAngle = 55,
	LowestPower = 40,
	MaxPower = 95,
	Angle = 45,
	MaxAngle = 55,
	lowestAngle = 10
}
local QBThrowingTab = { Direction = Vector3.new(0, 0, 0) }
local QBClosestPlr = nil
local QBIsLocked = false
local dradius = 20

-- Returns (target, targetHrp) - target is Player or Model (bot), targetHrp is HumanoidRootPart
local function GetNearestTargetToMouse()
	local mousePos = Vector2.new(Mouse.X, Mouse.Y)
	local nearest, nearestHrp = nil, nil
	local nearestDist = math.huge
	local myTeam = LocalPlayer.Team
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and (not aimbotTeamCheck or not myTeam or p.Team == myTeam) then
			local c = p.Character
			if c then
				local hrp = c:FindFirstChild("HumanoidRootPart")
				if hrp then
					local screen = Camera:WorldToViewportPoint(hrp.Position)
					local v2 = Vector2.new(screen.X, screen.Y)
					local d = (v2 - mousePos).Magnitude
					if d < nearestDist then
						nearestDist = d
						nearest = p
						nearestHrp = hrp
					end
				end
			end
		end
	end
	if aimbotBots then
		for _, obj in ipairs(Workspace:GetChildren()) do
			if obj.Name == "npcwr" then
				local a, b = obj:FindFirstChild("a"), obj:FindFirstChild("b")
				for _, set in ipairs({ a, b }) do
					if set then
						for _, bot in ipairs(set:GetChildren()) do
							local hrp = bot:FindFirstChild("HumanoidRootPart")
							if hrp then
								local screen = Camera:WorldToViewportPoint(hrp.Position)
								local v2 = Vector2.new(screen.X, screen.Y)
								local d = (v2 - mousePos).Magnitude
								if d < nearestDist then
									nearestDist = d
									nearest = bot
									nearestHrp = hrp
								end
							end
						end
					end
				end
			end
		end
	end
	return nearest, nearestHrp
end

local function QBClampNum(val, lo, hi)
	return math.min(math.max(val, lo), hi)
end

local function GetQBThrowType()
	return QBThrowType
end

local function isMovingQB(target)
	if not target then return false end
	if target:IsA("Player") then
		local c = target.Character
		local hum = c and c:FindFirstChild("Humanoid")
		return hum and hum.MoveDirection.Magnitude > 0
	end
	return false
end

local function isBotMovingQB(vel)
	return vel and vel.Magnitude > 0.1
end

local function getFieldOrientationQB(throwerPos, moveDir)
	if moveDir.Z > 0 then return 1 else return -1 end
end

local function CalculateRouteofPlayerQB(plr)
	if not plr then return "Straight" end
	if plr:IsA("Model") and (string.find(tostring(plr.Name), "bot 1") or string.find(tostring(plr.Name), "bot 3")) then
		return "Straight"
	end
	local c = plr.Character
	if not c then return "Straight" end
	local hum = c:FindFirstChild("Humanoid")
	local hrp = c:FindFirstChild("HumanoidRootPart")
	local myHrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp or not myHrp then return "Straight" end
	local dirMoving = hum.MoveDirection
	local dist = (hrp.Position - myHrp.Position)
	local direction = dist.Unit
	local Z2 = direction * Vector3.new(0, 0, getFieldOrientationQB(myHrp.Position, dirMoving) == -1 and -1 or 1)
	local dot = dirMoving:Dot(Z2)
	local routeType = "Straight"
	if dot >= 0.80 or dot <= -0.80 then routeType = "Straight"
	elseif dot >= 0.45 or dot <= -0.45 then routeType = "Post"
	elseif dot >= 0.2 or dot <= -0.2 then routeType = "Slant"
	elseif dot == 0 then routeType = "Still" end
	if dirMoving:Dot(dist) < 0 then routeType = "Comeback" end
	return routeType
end

local function HorizontalRangeOfProjectileQB(target)
	if not target then return 0 end
	local head
	if target:IsA("Model") and (string.find(tostring(target.Name), "bot 1") or string.find(tostring(target.Name), "bot 3")) then
		head = target:FindFirstChild("Head")
	elseif target.Character then
		head = target.Character:FindFirstChild("Head")
	end
	local myHrp = char and char:FindFirstChild("HumanoidRootPart")
	if not head or not myHrp then return 0 end
	local pr = myHrp.Position - head.Position
	return Vector2.new(pr.X, pr.Z).Magnitude
end

local function HighSpeedLowAngleCalcsQB(grav, speed)
	local tgt = QBClosestPlr or GetNearestTargetToMouse()
	if not tgt then return 0.5 end
	local RP = HorizontalRangeOfProjectileQB(tgt)
	local route = CalculateRouteofPlayerQB(tgt)
	local asin = math.asin
	local eq
	if route == "Comeback" then
		eq = RP < 150 and 0.52 or 0.47
	elseif route == "Still" then
		eq = 0.6
	elseif route == "Post" then
		eq = RP < 150 and 0.85 or 0.88
	else
		eq = RP < 150 and 0.87 or 0.9
	end
	return eq * asin((RP * grav) / (speed * speed))
end

local function calculateLaunchAngleQB(grav, speed)
	local tgt = QBClosestPlr or GetNearestTargetToMouse()
	local RP = HorizontalRangeOfProjectileQB(tgt)
	return math.asin(grav * RP / (speed * speed))
end

local function GetTimeOfFlightProjectileQB(initialVel, angle, grav)
	return (2 * initialVel * math.sin(angle)) / grav
end

local function OverallVelocityNeededToReachAPositionQB(ang, startPos, endPos, gravity, time)
	local velNeeded = (endPos - startPos - 0.5 * gravity * time * time) / time
	local Y = (endPos - startPos)
	local xz2 = Vector2.new(Y.X, Y.Z).Magnitude
	if xz2 < 0.001 then return Vector3.new(0,0,0), (endPos - startPos).Unit, 50 end
	local velOverTime = xz2 / time
	local notVec = Vector3.new(Y.X * 0.25, 0, Y.Z * 0.25).Unit
	local eqDerived = notVec * velOverTime
	local estVel = eqDerived + Vector3.new(0, velNeeded.Y, 0)
	local direction = (startPos + estVel - startPos).Unit
	local pow = estVel.Magnitude + 0.05
	if highPowerModeOn then
		return estVel, direction, QBClampNum(math.round(pow), 85, 95)
	end
	return estVel, direction, QBClampNum(math.round(pow), 0, 95)
end

local function KeepPosInBoundsQB(pos, minX, minZ)
	local x = math.clamp(pos.X, -minX, minX)
	local z = math.clamp(pos.Z, -minZ, minZ)
	return Vector3.new(x, pos.Y, z)
end

local function getMostIsolatedPlayerQB(radius)
	local mostIsolated, minCount = nil, math.huge
	local function countNearby(ply)
		local count = 0
		local pos = ply.Character and ply.Character:FindFirstChild("HumanoidRootPart") and ply.Character.HumanoidRootPart.Position
		if not pos then return count end
		for _, other in ipairs(Players:GetPlayers()) do
			if other ~= ply and other ~= LocalPlayer and other.Character then
				local op = other.Character:FindFirstChild("HumanoidRootPart")
				if op and (not LocalPlayer.Team or other.Team ~= LocalPlayer.Team) and (pos - op.Position).Magnitude <= radius then
					count = count + 1
				end
			end
		end
		return count
	end
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Team == LocalPlayer.Team then
			local cnt = countNearby(p)
			if cnt < minCount then minCount = cnt mostIsolated = p end
		end
		end
	return mostIsolated
end

local function BotEstimatedVelQB(time, bot)
	local hrp = bot:FindFirstChild("HumanoidRootPart")
	if not hrp then return bot.Position end
	local speed = hrp.Velocity
	local typ = GetQBThrowType()
	local leadBot3 = { Dime = Vector3.new(-1,1.25,-6), Mag = Vector3.new(-2,2,-11), Dive = Vector3.new(-1.25,1.5,-9), Dot = Vector3.new(-0.09,0.09,-4), Fade = Vector3.new(0,0,0), Bullet = Vector3.new(-5,-1,-1.25), Jump = Vector3.new(-1,2.25,-5) }
	local leadBot1 = { Dime = Vector3.new(1,1.25,6), Mag = Vector3.new(2,2,11), Dive = Vector3.new(1.25,1.5,9), Dot = Vector3.new(0.09,0.09,4), Fade = Vector3.new(0,0,0), Bullet = Vector3.new(5,1,1.25), Jump = Vector3.new(1,2,5) }
	if not isBotMovingQB(speed) then
		leadBot3 = { Dime = Vector3.new(0,0,0), Mag = Vector3.new(0,0,0), Dive = Vector3.new(0,0,0), Dot = Vector3.new(0,0,0), Fade = Vector3.new(0,0,0), Bullet = Vector3.new(0,0,0), Jump = Vector3.new(0,4,0) }
		leadBot1 = { Dime = Vector3.new(0,0,0), Mag = Vector3.new(0,0,0), Dive = Vector3.new(0,0,0), Dot = Vector3.new(0,0,0), Fade = Vector3.new(0,0,0), Bullet = Vector3.new(0,0,0), Jump = Vector3.new(0,5,0) }
	end
	local tab = (tostring(bot.Name):find("bot 3") and leadBot3) or leadBot1
	local lead = tab[typ] or Vector3.new(0,0,0)
	local timeAcc = speed * time
	local moving = isBotMovingQB(speed)
	if tostring(bot.Name):find("bot 3") then
		return hrp.Position + (moving and (timeAcc + lead) or lead)
	end
	-- bot 1: moving = timeAcc + lead, not moving = position only (original)
	return hrp.Position + (moving and (timeAcc + lead) or Vector3.new(0,0,0))
end

local function GetTargetPositionForWRQB(time, wr)
	local c = wr.Character
	if not c then return Vector3.new(0,0,0) end
	local wrHrp = c:FindFirstChild("HumanoidRootPart")
	local hum = c:FindFirstChild("Humanoid")
	if not wrHrp or not hum then return wrHrp and wrHrp.Position or Vector3.new(0,0,0) end
	local moveDir = hum.MoveDirection
	local typ = GetQBThrowType()
	local myHrp = char and char:FindFirstChild("HumanoidRootPart")
	if not myHrp then return wrHrp.Position end
	local fieldOr = getFieldOrientationQB(myHrp.Position, moveDir)
	local leadTab
	if isMovingQB(wr) then
		leadTab = fieldOr == 1 and
			{ Dime = Vector3.new(1,1.65,9), Mag = Vector3.new(2,2,11), Dive = Vector3.new(1.25,1.86,9.5), Dot = Vector3.new(1,1.2,7), Fade = Vector3.new(0,0,0), Bullet = Vector3.new(5,1,1), Jump = Vector3.new(1,2.25,7.5) } or
			{ Dime = Vector3.new(1,1.65,-9), Mag = Vector3.new(2,2,-11), Dive = Vector3.new(1.25,1.86,-9.5), Dot = Vector3.new(1,1.2,-7), Fade = Vector3.new(0,0,0), Bullet = Vector3.new(-5,1,-1), Jump = Vector3.new(1,2.25,-7.5) }
	else
		leadTab = { Dime = Vector3.new(0,0,0), Mag = Vector3.new(0,0,0), Dive = Vector3.new(0,0,0), Dot = Vector3.new(0,0,0), Fade = Vector3.new(0,0,0), Bullet = Vector3.new(0,0,0), Jump = Vector3.new(0,5,0) }
	end
	local leadAdd = leadTab[typ] or Vector3.zero
	local mult = customLeadOn and customLeadDist or (typ == "Dot" and 17.5 or typ == "Bullet" and 21 or typ == "Jump" and 18.5 or typ == "Dime" and 18.9 or typ == "Dive" and 19.3 or typ == "Mag" and 19.7 or 18.9)
	local throwAcc = (typ == "Bullet" and Vector3.new(moveDir.X, 0, moveDir.Z) * mult * time) or (moveDir * mult * time)
	if highPowerModeOn then throwAcc = wrHrp.Velocity * time end
	local base = highPowerModeOn and wrHrp.Position or (wr.Character and wr.Character.Head and wr.Character.Head.Position or wrHrp.Position)
	if isMovingQB(wr) then
		return base + throwAcc + leadAdd
	end
	if typ == "Jump" then return base + throwAcc + Vector3.new(0, 6, 0) end
	return base
end

local function calculateThrowTypeQB(tgt)
	if not tgt then return "Dime" end
	local RP = HorizontalRangeOfProjectileQB(tgt)
	local r = CalculateRouteofPlayerQB(tgt)
	if tgt:IsA("Model") and (tostring(tgt.Name):find("bot 1") or tostring(tgt.Name):find("bot 3")) then
		return "Dime"
	end
	if RP <= 100 and r == "Slant" then return "Bullet" end
	if RP > 100 and r == "Slant" then return "Dive" end
	if RP <= 150 and r == "Straight" then return "Dive" end
	if RP > 150 and r == "Straight" then return "Dime" end
	if RP <= 150 and r == "Post" then return "Dive" end
	if RP > 150 and r == "Post" then return "Dime" end
	if RP <= 100 and r == "Still" then return "Dot" end
	if RP > 100 and r == "Still" then return "Dime" end
	if RP <= 150 and r == "Comeback" then return "Dime" end
	if RP > 150 and r == "Comeback" then return "Dive" end
	return "Dime"
end

local function beamProjectileQB(g, v0, x0, t1)
	local c = 0.5*0.5*0.5
	local p3 = 0.5*g*t1*t1 + v0*t1 + x0
	local p2 = p3 - (g*t1*t1 + v0*t1)/3
	local p1 = (c*g*t1*t1 + 0.5*v0*t1 + x0 - c*(x0+p3))/(3*c) - p2
	local curve0 = (p1 - x0).Magnitude
	local curve1 = (p2 - p3).Magnitude
	local b = (x0 - p3).Unit
	local r1 = (p1 - x0).Unit
	local u1 = r1:Cross(b).Unit
	local r2 = (p2 - p3).Unit
	local u2 = r2:Cross(b).Unit
	b = u1:Cross(r1).Unit
	local cf1 = CFrame.new(x0.x,x0.y,x0.z, r1.x,u1.x,b.x, r1.y,u1.y,b.y, r1.z,u1.z,b.z)
	local cf2 = CFrame.new(p3.x,p3.y,p3.z, r2.x,u2.x,b.x, r2.y,u2.y,b.y, r2.z,u2.z,b.z)
	return curve0, -curve1, cf1, cf2
end

local function isVector3ValidQB(v)
	return type(v) == "userdata" and v.X == v.X and v.Y == v.Y and v.Z == v.Z
end

-- Beam & Highlight for trajectory
local QBBeam = Instance.new("Beam", workspace.Terrain)
local QBAttach0 = Instance.new("Attachment", workspace.Terrain)
local QBAttach1 = Instance.new("Attachment", workspace.Terrain)
QBBeam.Attachment0 = QBAttach0
QBBeam.Attachment1 = QBAttach1
QBBeam.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Theme.Accent), ColorSequenceKeypoint.new(1, Theme.Accent) })
QBBeam.Width0 = 0.5
QBBeam.Width1 = 0.5
QBBeam.Segments = 500
QBBeam.Enabled = false
local QBVisPart = Instance.new("Part")
QBVisPart.Size = Vector3.new(2.2, 0.1, 2.2)
QBVisPart.Anchored = true
QBVisPart.CanCollide = false
QBVisPart.Transparency = 1
QBVisPart.Parent = Workspace
local QBHighlight = Instance.new("Highlight")
QBHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
QBHighlight.OutlineTransparency = 0
QBHighlight.FillColor = Color3.fromRGB(87, 87, 255)
QBHighlight.OutlineColor = Color3.fromRGB(205, 229, 240)

-- C = cycle throw type, Q = lock on, R/F = angle, Z/X = power
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	local tt = GetQBThrowType()
	if input.KeyCode == Enum.KeyCode.C then
		if not autoModeSelectionOn then
			local nextType = (tt == "Dime" and "Dive") or (tt == "Dive" and "Dot") or (tt == "Dot" and "Mag") or (tt == "Mag" and "Bullet") or (tt == "Bullet" and "Fade") or "Dime"
			QBThrowType = nextType
		end
	end
	if input.KeyCode == Enum.KeyCode.Q then
		QBIsLocked = not QBIsLocked
	end
	if not autoAngleOn then
		if input.KeyCode == Enum.KeyCode.R then
			if tt == "Bullet" and QBData.BulletModeAngle < 20 then QBData.BulletModeAngle = QBData.BulletModeAngle + 5
			elseif tt == "Fade" and QBData.FadeModeAngle < 75 then QBData.FadeModeAngle = QBData.FadeModeAngle + 5
			elseif QBData.Angle < 55 then QBData.Angle = QBData.Angle + 5 end
		end
		if input.KeyCode == Enum.KeyCode.F then
			if tt == "Bullet" and QBData.BulletModeAngle > 5 then QBData.BulletModeAngle = QBData.BulletModeAngle - 5
			elseif tt == "Fade" and QBData.FadeModeAngle > 55 then QBData.FadeModeAngle = QBData.FadeModeAngle - 5
			elseif QBData.Angle > 10 then QBData.Angle = QBData.Angle - 5 end
		end
	end
	if not autoPowerOn then
		if input.KeyCode == Enum.KeyCode.Z and QBData.NormalPower < QBData.MaxPower then QBData.NormalPower = QBData.NormalPower + 5 end
		if input.KeyCode == Enum.KeyCode.X and QBData.NormalPower > QBData.LowestPower then QBData.NormalPower = QBData.NormalPower - 5 end
	end
end)

-- Throw on left click (when HIKE + InPlay + Throwable + QB Aimbot on)
local function canThrowNow()
	local rsValues = ReplicatedStorage:FindFirstChild("Values")
	if not rsValues then return false end
	local status = rsValues:FindFirstChild("Status")
	local throwable = rsValues:FindFirstChild("Throwable")
	local pg = LocalPlayer:FindFirstChild("PlayerGui")
	local mainGui = pg and pg:FindFirstChild("MainGui")
	local msg = mainGui and mainGui:FindFirstChild("Message")
	return status and status.Value == "InPlay" and throwable and throwable.Value and (not msg or msg.Text == "HIKE")
end

UserInputService.InputBegan:Connect(function(input, gpe)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 or gpe then return end
	if not aimbotOn or not char then return end
	local football = char:FindFirstChildOfClass("Tool")
	if not football or football.Name ~= "Football" then return end
	if not canThrowNow() then return end
	local start = (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")).Position
	if not QBIsLocked then
		QBClosestPlr = (autoSelectWROn and getMostIsolatedPlayerQB(dradius)) or select(1, GetNearestTargetToMouse())
	end
	if QBIsLocked and not QBClosestPlr then
		QBClosestPlr = (autoSelectWROn and getMostIsolatedPlayerQB(dradius)) or select(1, GetNearestTargetToMouse())
	end
	local closest = QBClosestPlr
	if not closest then return end
	local throwType = autoModeSelectionOn and calculateThrowTypeQB(closest) or GetQBThrowType()
	local whichAngle = (throwType == "Fade" and QBData.FadeModeAngle) or (throwType == "Bullet" and QBData.BulletModeAngle) or QBData.Angle
	local initial = highPowerModeOn and 95 or (autoPowerOn and 95 or QBData.NormalPower)
	local toLaunchAngle
	if highPowerModeOn then
		toLaunchAngle = autoAngleOn and HighSpeedLowAngleCalcsQB(FF2Grav, initial) or math.rad(whichAngle)
	else
		toLaunchAngle = autoAngleOn and (throwType == "Fade" and math.rad(75) or throwType == "Bullet" and QBClampNum(HighSpeedLowAngleCalcsQB(FF2Grav, initial), 0, 0.296706) or QBClampNum(calculateLaunchAngleQB(FF2Grav, initial), 0, 0.975)) or math.rad(whichAngle)
	end
	local tof = GetTimeOfFlightProjectileQB(initial, toLaunchAngle, FF2Grav)
	local yesEnd
	if closest:IsA("Model") and (tostring(closest.Name):find("bot 1") or tostring(closest.Name):find("bot 3")) then
		yesEnd = game.PlaceId == 8206123457 and BotEstimatedVelQB(tof, closest) or KeepPosInBoundsQB(BotEstimatedVelQB(tof, closest), 70.5, 175.5)
	else
		yesEnd = game.PlaceId == 8206123457 and GetTargetPositionForWRQB(tof, closest) or KeepPosInBoundsQB(GetTargetPositionForWRQB(tof, closest), 70.5, 175.5)
	end
	local vel, dir, pow = OverallVelocityNeededToReachAPositionQB(toLaunchAngle, start, yesEnd, Vector3.new(0, -FF2Grav, 0), tof)
	local powerSir = autoPowerOn and (throwType == "Fade" and 95 or throwType == "Bullet" and QBClampNum(pow, 90, 95) or pow) or QBData.NormalPower
	QBThrowingTab.Direction = dir
	local newOrigin = start + dir * 5
	local remote = football:FindFirstChild("Handle") and football.Handle:FindFirstChild("RemoteEvent")
	if remote then
		local anims = ReplicatedStorage:FindFirstChild("Animations")
		local throwAnim = anims and char:FindFirstChild("Humanoid") and char.Humanoid:LoadAnimation(anims:FindFirstChild("Throw") or anims:FindFirstChild("Throw1") or Instance.new("Animation"))
		if throwAnim then pcall(function() throwAnim:Play() end) end
		remote:FireServer("Clicked", start, newOrigin + dir * 10000, (game.PlaceId == 8206123457 and powerSir) or 95, powerSir)
	end
end)

-- Heartbeat: update beam & highlight when QB Aimbot on and have target
RunService.Heartbeat:Connect(function()
	if not aimbotOn then
		QBBeam.Enabled = false
		QBHighlight.Adornee = nil
		QBHighlight.Parent = nil
		return
	end
	if not QBIsLocked then
		QBClosestPlr = (autoSelectWROn and getMostIsolatedPlayerQB(dradius)) or select(1, GetNearestTargetToMouse())
	end
	local closest = QBClosestPlr
	if not char or not char:FindFirstChild("Football") or not closest then
		QBBeam.Enabled = false
		QBHighlight.Adornee = nil
		QBHighlight.Parent = nil
		return
	end
	local throwType = autoModeSelectionOn and calculateThrowTypeQB(closest) or GetQBThrowType()
	local whichAngle = (throwType == "Fade" and QBData.FadeModeAngle) or (throwType == "Bullet" and QBData.BulletModeAngle) or QBData.Angle
	local initial = highPowerModeOn and 95 or (autoPowerOn and 95 or QBData.NormalPower)
	local toLaunchAngle
	if highPowerModeOn then
		toLaunchAngle = autoAngleOn and HighSpeedLowAngleCalcsQB(FF2Grav, initial) or math.rad(whichAngle)
	else
		toLaunchAngle = autoAngleOn and (throwType == "Fade" and math.rad(75) or throwType == "Bullet" and QBClampNum(HighSpeedLowAngleCalcsQB(FF2Grav, initial), 0, 0.296706) or QBClampNum(calculateLaunchAngleQB(FF2Grav, initial), 0, 0.975)) or math.rad(whichAngle)
	end
	local tof = GetTimeOfFlightProjectileQB(initial, toLaunchAngle, FF2Grav)
	local start = (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")).Position
	local targetPos
	if closest:IsA("Model") and (tostring(closest.Name):find("bot 1") or tostring(closest.Name):find("bot 3")) then
		targetPos = game.PlaceId == 8206123457 and BotEstimatedVelQB(tof, closest) or KeepPosInBoundsQB(BotEstimatedVelQB(tof, closest), 70.5, 175.5)
	else
		targetPos = game.PlaceId == 8206123457 and GetTargetPositionForWRQB(tof, closest) or KeepPosInBoundsQB(GetTargetPositionForWRQB(tof, closest), 70.5, 175.5)
	end
	local vel, dir, pow = OverallVelocityNeededToReachAPositionQB(toLaunchAngle, start, targetPos, Vector3.new(0, -FF2Grav, 0), tof)
	if not isVector3ValidQB(dir) or not isVector3ValidQB(targetPos) then return end
	QBThrowingTab.Direction = dir
	local beamTime = fullBeamLengthOn and 10 or tof
	local curve0, curve1, cf0, cf1 = beamProjectileQB(Vector3.new(0, -FF2Grav, 0), (autoPowerOn and pow or QBData.NormalPower) * dir, start + dir * 5, beamTime)
	QBBeam.CurveSize0 = curve0
	QBBeam.CurveSize1 = curve1
	QBAttach0.CFrame = QBAttach0.Parent.CFrame:Inverse() * cf0
	QBAttach1.CFrame = QBAttach1.Parent.CFrame:Inverse() * cf1
	QBBeam.Enabled = ballTrajectoryBeamOn
	if not removeBeamEndOn then
		local sum = (QBAttach1.CFrame - QBAttach1.Position):Inverse()
		QBVisPart.CFrame = QBAttach1.CFrame * sum
	end
	QBVisPart.Position = QBAttach1.Position
	if closest:IsA("Player") and closest.Character then
		QBHighlight.Adornee = closest.Character
		QBHighlight.Parent = closest.Character
	elseif closest:IsA("Model") then
		QBHighlight.Adornee = closest
		QBHighlight.Parent = closest
	end
end)

-- // ========== END QB AIMBOT ========== --

local VIM = game:GetService("VirtualInputManager")
local char = LocalPlayer.Character
LocalPlayer.CharacterAdded:Connect(function(c) char = c end)

-- // Automatics
local autoCatchOn, autoJumpOn, autoSwatOn, autoRushOn, autoCapOn = false, false, false, false, false
local distCatch, distJump, distSwat, distRush = 17, 17, 17, 20
local agDist = 20

local function DoCatch()
    if VIM then
        pcall(function()
            VIM:SendMouseButtonEvent(0, 0, 0, true, nil, 0)
            task.wait(0.05)
            VIM:SendMouseButtonEvent(0, 0, 0, false, nil, 0)
        end)
    end
end

local function DoJump()
    if VIM then
        pcall(function()
            VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait(0.05)
            VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end)
    end
end

local function DoSwat()
    if VIM then
        pcall(function()
            VIM:SendKeyEvent(true, Enum.KeyCode.R, false, game)
            task.wait(0.05)
            VIM:SendKeyEvent(false, Enum.KeyCode.R, false, game)
        end)
    end
end

-- // Player
local jumpPowerOn, jumpPowerVal = false, 50
local speedBoostOn, speedBoostVal = false, 3
local angleEnhancerOn, antiJamOn, antiBlockOn = false, false, false
local ballPullOn, ballPullStr, ballPullDist = false, 10, 20

-- // Mags (extra / misc)
local magsEnabled = false
local magsFovCircle = false
local magsHighlightTarget = false

-- // Catching (magnets from original)
local magnetsOn = false
local magnetVersion = "Magnets V1"  -- "Magnets V1" | "Magnets V2 (RISKY)"
local magnetType = "Blatant"        -- "Blatant" | "Legit" | "Regular" | "Leauge"
local bldist, regdist, legmagdist, leaugdist = 25, 20, 10, 4
local msSecondVerRange = 20
local pullVectorOn, pvStrength, pvDist = false, 10, 20

-- // QB extras (from original t3)
local autoAngleOn, autoPowerOn, highPowerModeOn = false, false, false
local autoModeSelectionOn, autoSelectWROn = false, false
local qbLockOn = false

-- // QB Configs (from original t4)
local fullBeamLengthOn, removeBeamEndOn = false, false
local customLeadOn = false
local customLeadDist = 18.9

-- // Kicker
local perfectKickerOn = false

-- // Visuals (from original t6)
local magnetHitboxVizOn = false
local ballTrajectoryBeamOn = false

-- // Auto Captain (PlaceId 8206123457) - uses autoCapOn from Automatics tab

-- Build tabs and content
local tabAimbot = AddTab("QB Aimbot", 1)
local tabCatching = AddTab("Catching", 2)
local tabAuto = AddTab("Automatics", 3)
local tabPlayer = AddTab("Player", 4)
local tabQB = AddTab("QB", 5)
local tabQBConfigs = AddTab("QB Configs", 6)
local tabKicker = AddTab("Kicker", 7)
local tabMags = AddTab("Mags", 8)
local tabVisuals = AddTab("Visuals", 9)

-- QB Aimbot tab
do
    local s = Section(tabAimbot, "QB Aimbot")
    Toggle(s, "Enable QB Aimbot", false, function(v) aimbotOn = v end)
    Toggle(s, "Team check (ignore teammates)", true, function(v) aimbotTeamCheck = v end)
    Toggle(s, "Include bots (npcwr)", true, function(v) aimbotBots = v end)
    Toggle(s, "Silent aim (camera)", false, function(v) silentAim = v end)
    Slider(s, "FOV (px)", 50, 400, 200, function(v) aimbotFov = v end)
end

-- Catching tab (magnets + pull vector from original t1)
do
    local s = Section(tabCatching, "Magnets")
    Dropdown(s, "Magnet Version", {"None", "Magnets V1", "Magnets V2 (RISKY)"}, "Magnets V1", function(v) magnetVersion = v end)
    Toggle(s, "Magnets", false, function(v) magnetsOn = v end)
    Dropdown(s, "Magnet Type", {"Blatant", "Legit", "Regular", "Leauge"}, "Blatant", function(v) magnetType = v end)
    Slider(s, "Blatant Mag Range", 20, 30, 25, function(v) bldist = v end)
    Slider(s, "Regular Mag Range", 15, 25, 20, function(v) regdist = v end)
    Slider(s, "Legit Mag Range", 5, 10, 10, function(v) legmagdist = v end)
    Slider(s, "Leauge Mag Range", 0, 5, 4, function(v) leaugdist = v end)
    Slider(s, "Magnets V2 Range", 0, 30, 20, function(v) msSecondVerRange = v end)
    Toggle(s, "Pull Vector", false, function(v) pullVectorOn = v end)
    Slider(s, "Pull Vector Strength", 1, 30, 10, function(v) pvStrength = v end)
    Slider(s, "Pull Vector Distance", 1, 30, 20, function(v) pvDist = v end)
end

-- Automatics tab
do
    local s = Section(tabAuto, "Auto actions (Football)")
    Toggle(s, "Auto Catch", false, function(v) autoCatchOn = v end)
    Slider(s, "Catch distance", 5, 25, 17, function(v) distCatch = v end)
    Toggle(s, "Auto Jump", false, function(v) autoJumpOn = v end)
    Slider(s, "Jump distance", 5, 25, 17, function(v) distJump = v end)
    Toggle(s, "Auto Swat", false, function(v) autoSwatOn = v end)
    Slider(s, "Swat distance", 5, 25, 17, function(v) distSwat = v end)
    Toggle(s, "Auto Rush", false, function(v) autoRushOn = v end)
    Slider(s, "Rush distance", 10, 30, 20, function(v) distRush = v end)
    Toggle(s, "Auto Captain", false, function(v) autoCapOn = v end)
end

-- Player tab
do
    local s = Section(tabPlayer, "Movement")
    Toggle(s, "Jump Power", false, function(v) jumpPowerOn = v end)
    Slider(s, "Jump Power strength", 40, 80, 50, function(v) jumpPowerVal = v end)
    Toggle(s, "Speed Boost (F)", false, function(v) speedBoostOn = v end)
    Slider(s, "Speed Boost strength", 1, 8, 3, function(v) speedBoostVal = v end)
    Toggle(s, "Angle Enhancer", false, function(v) angleEnhancerOn = v end)
    Toggle(s, "Anti Jam", false, function(v) antiJamOn = v end)
    Toggle(s, "Anti Block", false, function(v) antiBlockOn = v end)
    Toggle(s, "Ball pull (velocity)", false, function(v) ballPullOn = v end)
    Slider(s, "Ball pull strength", 5, 25, 10, function(v) ballPullStr = v end)
    Slider(s, "Ball pull distance", 10, 30, 20, function(v) ballPullDist = v end)
end

-- Mags tab (full magnet controls + FOV/highlight)
do
    local s1 = Section(tabMags, "Magnets")
    Toggle(s1, "Mags enabled", false, function(v) magnetsOn = v magsEnabled = v end)
    Dropdown(s1, "Magnet Version", {"None", "Magnets V1", "Magnets V2 (RISKY)"}, "Magnets V1", function(v) magnetVersion = v end)
    Dropdown(s1, "Magnet Type", {"Blatant", "Legit", "Regular", "Leauge"}, "Blatant", function(v) magnetType = v end)
    Slider(s1, "Blatant Mag Range", 20, 30, 25, function(v) bldist = v end)
    Slider(s1, "Regular Mag Range", 15, 25, 20, function(v) regdist = v end)
    Slider(s1, "Legit Mag Range", 5, 10, 10, function(v) legmagdist = v end)
    Slider(s1, "Leauge Mag Range", 0, 5, 4, function(v) leaugdist = v end)
    Slider(s1, "Magnets V2 Range", 0, 30, 20, function(v) msSecondVerRange = v end)
    Toggle(s1, "Pull Vector", false, function(v) pullVectorOn = v end)
    Slider(s1, "Pull Vector Strength", 1, 30, 10, function(v) pvStrength = v end)
    Slider(s1, "Pull Vector Distance", 1, 30, 20, function(v) pvDist = v end)
    local s2 = Section(tabMags, "Mags visuals")
    Toggle(s2, "FOV circle", false, function(v) magsFovCircle = v end)
    Toggle(s2, "Highlight target", false, function(v) magsHighlightTarget = v end)
    Slider(s2, "Mags FOV size", 50, 350, 200, function(v) aimbotFov = v end)
end

-- QB tab (from original t3)
do
    local s = Section(tabQB, "QB")
    Toggle(s, "Auto Angle", false, function(v) autoAngleOn = v end)
    Toggle(s, "Auto Power", false, function(v) autoPowerOn = v end)
    Toggle(s, "High Power Mode", false, function(v) highPowerModeOn = v end)
    Toggle(s, "Auto Mode Selection", false, function(v) autoModeSelectionOn = v end)
    Toggle(s, "Auto Select WR", false, function(v) autoSelectWROn = v end)
    Toggle(s, "Q to lock on", false, function(v) qbLockOn = v end)
end

-- QB Configs tab (from original t4)
do
    local s = Section(tabQBConfigs, "QB Configs")
    Toggle(s, "Full Beam Length", false, function(v) fullBeamLengthOn = v end)
    Toggle(s, "Remove Beam End Part", false, function(v) removeBeamEndOn = v end)
    Toggle(s, "Custom Lead", false, function(v) customLeadOn = v end)
    Slider(s, "Lead Distance", 15, 20, 18, function(v) customLeadDist = v end)
end

-- Kicker tab (from original t7)
do
    local s = Section(tabKicker, "Kicker")
    Toggle(s, "Perfect Kicker Aimbot", false, function(v) perfectKickerOn = v end)
end

-- Visuals tab (from original t6)
do
    local s = Section(tabVisuals, "Visuals")
    Toggle(s, "Magnet Hitbox Visualizer", false, function(v) magnetHitboxVizOn = v end)
    Toggle(s, "Ball Trajectory Beam", false, function(v) ballTrajectoryBeamOn = v end)
    Toggle(s, "Show FOV circle", false, function(v) magsFovCircle = v end)
end

-- Set first tab active
local firstTabName = "QB Aimbot"
CurrentTab = Tabs[firstTabName]
if CurrentTab then CurrentTab.Visible = true end
for _, c in ipairs(Sidebar:GetChildren()) do
    local tabLbl = c:FindFirstChild("TabLabel")
    if tabLbl then
        tabLbl.TextColor3 = (c.Name == firstTabName) and Theme.Accent or Theme.TextDim
    end
end

-- Aimbot loop
RunService.RenderStepped:Connect(function()
    if not aimbotOn or not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local target = GetNearestToMouse(aimbotTeamCheck, aimbotBots)
    if not target then return end
    local screen, onScreen = GetScreenPoint(target)
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    local v2 = Vector2.new(screen.X, screen.Y)
    if (v2 - mousePos).Magnitude > aimbotFov then return end
    if silentAim then
        -- Silent: point camera at target
        local root = target.Position
        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, root)
    end
end)

-- Automatics loop (ball)
RunService.RenderStepped:Connect(function()
    local c = LocalPlayer.Character
    if not c then return end
    local myHrp = c:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj.Name == "Football" and obj:IsA("BasePart") then
            local dist = (myHrp.Position - obj.Position).Magnitude
            if autoCatchOn and dist <= distCatch then DoCatch() end
            if autoJumpOn and dist <= distJump then DoJump() end
            if autoSwatOn and dist <= distSwat then DoSwat() end
            local usePull = ballPullOn or pullVectorOn
            local pullD = pullVectorOn and pvDist or ballPullDist
            local pullS = pullVectorOn and pvStrength or ballPullStr
            if usePull and dist <= pullD then
                local dir = (obj.Position - myHrp.Position).Unit
                myHrp.Velocity = dir * pullS
            end
        end
    end
end)

-- Auto Rush (chase ball carrier)
local QBValues = ReplicatedStorage:FindFirstChild("Values")
RunService.RenderStepped:Connect(function()
    if not autoRushOn or not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    local vals = QBValues and QBValues:FindFirstChild("QB")
    local ballCarrier = vals and vals.Value
    if not ballCarrier or ballCarrier == LocalPlayer then return end
    local enemyChar = ballCarrier.Character
    if not enemyChar then return end
    local enemyHrp = enemyChar:FindFirstChild("HumanoidRootPart")
    local enemyHum = enemyChar:FindFirstChild("Humanoid")
    if not enemyHrp or not enemyHum then return end
    if LocalPlayer.Team and ballCarrier.Team == LocalPlayer.Team then return end
    local d = (enemyHrp.Position - hrp.Position).Magnitude
    if d <= distRush then
        local pos = enemyHrp.Position + enemyHum.MoveDirection * (d / 20) * 20
        hum:MoveTo(pos)
    end
end)

-- Jump Power
RunService.RenderStepped:Connect(function()
    if not jumpPowerOn or not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    if hum.FloorMaterial == Enum.Material.Grass and hum.Jump then
        hrp.Velocity = Vector3.new(hrp.Velocity.X, math.min(80, jumpPowerVal), hrp.Velocity.Z)
    end
end)

-- Speed Boost (F)
UserInputService.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.F and speedBoostOn and char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * speedBoostVal
        end
    end
end)

-- Anti Jam / Anti Block
RunService.Heartbeat:Connect(function()
    if not antiJamOn and not antiBlockOn then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local ch = p.Character
            if ch then
                for _, part in ipairs(ch:GetChildren()) do
                    if part:IsA("BasePart") or part:IsA("MeshPart") then
                        part.CanCollide = not (antiJamOn or antiBlockOn)
                    end
                end
            end
        end
    end
end)

-- Magnets loop (Catching tab - from original)
local function getMagDist()
    if magnetType == "Blatant" then return bldist end
    if magnetType == "Regular" then return regdist end
    if magnetType == "Legit" then return legmagdist end
    if magnetType == "Leauge" then return leaugdist end
    return bldist
end

task.spawn(function()
    while task.wait(0.03) do
        if magnetsOn and magnetVersion ~= "None" then
            local c = LocalPlayer.Character
            if c then
                local catchRight = c:FindFirstChild("CatchRight")
                local hrp = c:FindFirstChild("HumanoidRootPart")
                if catchRight and hrp then
                    local magDist = (magnetVersion == "Magnets V2 (RISKY)") and msSecondVerRange or getMagDist()
                    for _, obj in ipairs(Workspace:GetChildren()) do
                        if obj:IsA("BasePart") and obj.Name == "Football" then
                            local dist = (hrp.Position - obj.Position).Magnitude
                            if dist <= magDist then
                                if firetouchinterest then
                                    firetouchinterest(catchRight, obj, 1)
                                    firetouchinterest(catchRight, obj, 0)
                                else
                                    local dir = (obj.Position - catchRight.Position).Unit
                                    catchRight.CFrame = (obj.CFrame + dir)
                                    task.wait()
                                    catchRight.CFrame = catchRight.CFrame
                                end
                                task.wait(0.05)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Perfect Kicker Aimbot (from original t7)
LocalPlayer.PlayerGui.ChildAdded:Connect(function(child)
    if child.Name ~= "KickerGui" or not perfectKickerOn then return end
    local c = LocalPlayer.Character
    if not c or not c:FindFirstChild("Humanoid") then return end
    task.spawn(function()
        local cursor = child:FindFirstChild("Cursor", true)
        if not cursor or not VIM then return end
        VIM:SendMouseButtonEvent(0, 0, 0, true, nil, 0)
        while cursor and cursor.Position and cursor.Position.Y and cursor.Position.Y.Scale and cursor.Position.Y.Scale > 0.03 do
            task.wait()
        end
        VIM:SendMouseButtonEvent(0, 0, 0, true, nil, 0)
        while cursor and cursor.Position and cursor.Position.Y and cursor.Position.Y.Scale and cursor.Position.Y.Scale < 0.89 do
            task.wait()
        end
        VIM:SendMouseButtonEvent(0, 0, 0, false, nil, 0)
    end)
end)

-- Auto Captain (PlaceId 8206123457 - from original)
if game.PlaceId == 8206123457 then
    local models = Workspace:FindFirstChild("Models")
    local lockerRoom = models and models:FindFirstChild("LockerRoomA")
    local finishLine = lockerRoom and lockerRoom:FindFirstChild("FinishLine")
    if finishLine then
        finishLine:GetPropertyChangedSignal("Position"):Connect(function()
            if not autoCapOn or not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local offset = Vector3.new(2.1, 2.1, 2.1)
            task.wait(0.13)
            hrp.CFrame = finishLine.CFrame + offset
            for _ = 1, 5 do
                task.wait(0.25)
                hrp.CFrame = finishLine.CFrame + offset
            end
        end)
    end
end

-- Mags FOV circle (on-screen circle when magsFovCircle is on)
RunService.Heartbeat:Connect(function()
    MagsFOVCircle.Visible = magsFovCircle
    if magsFovCircle then
        local r = math.clamp(aimbotFov, 50, 400)
        MagsFOVCircle.Size = UDim2.new(0, r * 2, 0, r * 2)
        MagsFOVCircle.Position = UDim2.new(0.5, -r, 0.5, -r)
    end
end)

-- Magnet Hitbox Visualizer (simple: highlight ball when in mag range and viz on)
local magVizPart = nil
RunService.Heartbeat:Connect(function()
    if not magnetHitboxVizOn or not magnetsOn then
        if magVizPart then magVizPart.Parent = nil magVizPart = nil end
        return
    end
    local c = LocalPlayer.Character
    local hrp = c and c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local magDist = getMagDist()
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("BasePart") and obj.Name == "Football" then
            local dist = (hrp.Position - obj.Position).Magnitude
            if dist <= magDist then
                if not magVizPart then
                    magVizPart = Create("Part", { Size = Vector3.new(4, 4, 4), Shape = Enum.PartType.Ball, Anchored = true, CanCollide = false, Transparency = 0.7, Color = Theme.Accent })
                    magVizPart.Parent = Workspace
                end
                magVizPart.Position = obj.Position
                magVizPart.Parent = Workspace
                return
            end
        end
    end
    if magVizPart then magVizPart.Parent = nil end
end)

print("[FF2 2017] Loaded. No remote scripts.")
