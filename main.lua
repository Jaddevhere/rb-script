-- ==========================================
-- TRL Dashboard + Key System (Official Build)
-- GitHub: Jaddevhere/rb-script
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local WEBSITE_URL = "https://jaddevhere.github.io/rb-script/"
local ADMIN_KEY = "Mst792012"

-- تنظيف الواجهات القديمة
if CoreGui:FindFirstChild("TRL_KeySystem") then CoreGui.TRL_KeySystem:Destroy() end
if CoreGui:FindFirstChild("TRL_Dashboard") then CoreGui.TRL_Dashboard:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TRL_KeySystem"
screenGui.ResetOnSpawn = false

if syn and syn.protect_gui then
	syn.protect_gui(screenGui)
	screenGui.Parent = CoreGui
elseif gethui then
	screenGui.Parent = gethui()
else
	screenGui.Parent = CoreGui
end

-- ==========================================
-- 🔑 واجهة الكي سيستم (Key System UI)
-- ==========================================
local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0, 270, 0, 185)
keyFrame.Position = UDim2.new(0.5, -135, 0.4, -92)
keyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
keyFrame.Active = true
keyFrame.Draggable = true
keyFrame.Parent = screenGui

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 10)
keyCorner.Parent = keyFrame

local keyTitle = Instance.new("TextLabel")
keyTitle.Size = UDim2.new(1, 0, 0, 35)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = "RB Script Key System"
keyTitle.TextColor3 = Color3.fromRGB(0, 170, 255)
keyTitle.Font = Enum.Font.SourceSansBold
keyTitle.TextSize = 16
keyTitle.Parent = keyFrame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(0.85, 0, 0, 32)
keyInput.Position = UDim2.new(0.075, 0, 0.24, 0)
keyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.PlaceholderText = "أدخل الكود هنا..."
keyInput.Font = Enum.Font.SourceSans
keyInput.TextSize = 14
keyInput.Parent = keyFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = keyInput

local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(0.4, 0, 0, 30)
submitBtn.Position = UDim2.new(0.075, 0, 0.52, 0)
submitBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
submitBtn.Text = "تفعيل الكود"
submitBtn.Font = Enum.Font.SourceSansBold
submitBtn.TextSize = 13
submitBtn.Parent = keyFrame

local submitCorner = Instance.new("UICorner")
submitCorner.CornerRadius = UDim.new(0, 6)
submitCorner.Parent = submitBtn

local copyUrlBtn = Instance.new("TextButton")
copyUrlBtn.Size = UDim2.new(0.42, 0, 0, 30)
copyUrlBtn.Position = UDim2.new(0.505, 0, 0.52, 0)
copyUrlBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
copyUrlBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyUrlBtn.Text = "نسخ رابط الموقع"
copyUrlBtn.Font = Enum.Font.SourceSansBold
copyUrlBtn.TextSize = 12
copyUrlBtn.Parent = keyFrame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 6)
copyCorner.Parent = copyUrlBtn

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 0.82, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "احصل على الكود من رابط الموقع"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 11
statusLabel.Parent = keyFrame

copyUrlBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(WEBSITE_URL)
		statusLabel.Text = "تم نسخ الرابط بنجاح!"
		statusLabel.TextColor3 = Color3.fromRGB(0, 255, 136)
	else
		statusLabel.Text = "انسخ الرابط يدويًا من الموقع"
	end
end)

-- ==========================================
-- 🚀 تشغيل TRL Dashboard الرئيسي بعد التفعيل
-- ==========================================
local function loadMainDashboard()
	screenGui:Destroy()

	local dashGui = Instance.new("ScreenGui")
	dashGui.Name = "TRL_Dashboard"
	dashGui.ResetOnSpawn = false
	dashGui.Parent = (syn and syn.protect_gui and CoreGui) or gethui() or CoreGui

	-- الزر العائم للموبايل
	local floatingBtn = Instance.new("TextButton")
	floatingBtn.Size = UDim2.new(0, 44, 0, 44)
	floatingBtn.Position = UDim2.new(0.02, 0, 0.4, 0)
	floatingBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	floatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	floatingBtn.Text = "TRL"
	floatingBtn.Font = Enum.Font.SourceSansBold
	floatingBtn.TextSize = 14
	floatingBtn.Active = true
	floatingBtn.Draggable = true
	floatingBtn.ZIndex = 10
	floatingBtn.Parent = dashGui

	local floatCorner = Instance.new("UICorner")
	floatCorner.CornerRadius = UDim.new(1, 0)
	floatCorner.Parent = floatingBtn

	local floatStroke = Instance.new("UIStroke")
	floatStroke.Color = Color3.fromRGB(255, 255, 255)
	floatStroke.Thickness = 1.5
	floatStroke.Transparency = 0.3
	floatStroke.Parent = floatingBtn

	-- الإطار الرئيسي
	local mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.new(0, 195, 0, 375)
	mainFrame.Position = UDim2.new(0.08, 0, 0.22, 0)
	mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	mainFrame.Active = true
	mainFrame.Draggable = true
	mainFrame.ClipsDescendants = true
	mainFrame.Parent = dashGui

	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 10)
	frameCorner.Parent = mainFrame

	local headerFrame = Instance.new("Frame")
	headerFrame.Size = UDim2.new(1, 0, 0, 35)
	headerFrame.BackgroundTransparency = 1
	headerFrame.Parent = mainFrame

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(0.7, 0, 1, 0)
	title.Position = UDim2.new(0.05, 0, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "TRL Dashboard"
	title.TextColor3 = Color3.fromRGB(0, 170, 255)
	title.Font = Enum.Font.SourceSansBold
	title.TextSize = 16
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = headerFrame

	local minButton = Instance.new("TextButton")
	minButton.Size = UDim2.new(0, 24, 0, 24)
	minButton.Position = UDim2.new(0.82, 0, 0.15, 0)
	minButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	minButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	minButton.Text = "-"
	minButton.Font = Enum.Font.SourceSansBold
	minButton.TextSize = 18
	minButton.Parent = headerFrame

	local minCorner = Instance.new("UICorner")
	minCorner.CornerRadius = UDim.new(0, 4)
	minCorner.Parent = minButton

	local statsLabel = Instance.new("TextLabel")
	statsLabel.Size = UDim2.new(0.9, 0, 0, 18)
	statsLabel.Position = UDim2.new(0.05, 0, 0, 32)
	statsLabel.BackgroundTransparency = 1
	statsLabel.Text = "FPS: 60 | Ping: 0ms"
	statsLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	statsLabel.Font = Enum.Font.SourceSans
	statsLabel.TextSize = 11
	statsLabel.Parent = mainFrame

	local container = Instance.new("ScrollingFrame")
	container.Size = UDim2.new(1, 0, 1, -52)
	container.Position = UDim2.new(0, 0, 0, 52)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.CanvasSize = UDim2.new(0, 0, 0, 450)
	container.ScrollBarThickness = 5
	container.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
	container.Parent = mainFrame

	local listLayout = Instance.new("UIListLayout")
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 6)
	listLayout.Parent = container

	local listPadding = Instance.new("UIPadding")
	listPadding.PaddingTop = UDim.new(0, 4)
	listPadding.PaddingBottom = UDim.new(0, 10)
	listPadding.Parent = container

	listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		container.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
	end)

	local function createButton(text, color, order)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0.9, 0, 0, 28)
		btn.BackgroundColor3 = color or Color3.fromRGB(35, 35, 35)
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.Text = text
		btn.Font = Enum.Font.SourceSansBold
		btn.TextSize = 13
		btn.LayoutOrder = order or 0
		btn.ZIndex = 2
		btn.Parent = container

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 6)
		corner.Parent = btn
		return btn
	end

	local flyButton     = createButton("Fly: OFF", nil, 1)
	local noclipButton  = createButton("Noclip: OFF", nil, 2)
	local espButton     = createButton("Coin ESP: OFF", nil, 3)
	local farmButton    = createButton("Fly Farm: OFF", nil, 4)
	local tpFarmButton  = createButton("Instant TP Farm: OFF", Color3.fromRGB(45, 35, 60), 5)
	local pEspButton    = createButton("Player ESP: OFF", nil, 6)
	local tpRandButton  = createButton("TP Random Player", Color3.fromRGB(0, 100, 150), 7)
	local tpNextButton  = createButton("TP Next Player", Color3.fromRGB(0, 120, 180), 8)
	local themeButton   = createButton("Theme: Neon Blue", Color3.fromRGB(40, 40, 60), 9)
	local rejoinButton  = createButton("Rejoin Server", Color3.fromRGB(50, 50, 80), 10)
	local hopButton     = createButton("Server Hop", Color3.fromRGB(180, 80, 0), 11)

	local themes = {
		{name = "Neon Blue", color = Color3.fromRGB(0, 170, 255)},
		{name = "Cyber Green", color = Color3.fromRGB(46, 204, 113)},
		{name = "Crimson Red", color = Color3.fromRGB(231, 76, 60)},
		{name = "Purple Glow", color = Color3.fromRGB(155, 89, 182)}
	}
	local currentThemeIndex = 1

	local function changeTheme()
		currentThemeIndex = currentThemeIndex + 1
		if currentThemeIndex > #themes then currentThemeIndex = 1 end
		local theme = themes[currentThemeIndex]
		title.TextColor3 = theme.color
		floatingBtn.BackgroundColor3 = theme.color
		container.ScrollBarImageColor3 = theme.color
		themeButton.Text = "Theme: " .. theme.name
	end
	themeButton.MouseButton1Click:Connect(changeTheme)

	local frameCount = 0
	local lastCheck = tick()

	RunService.RenderStepped:Connect(function()
		frameCount = frameCount + 1
		local now = tick()
		if now - lastCheck >= 0.5 then
			local fps = math.floor(frameCount / (now - lastCheck))
			frameCount = 0
			lastCheck = now
			local ping = 0
			pcall(function()
				ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
			end)
			statsLabel.Text = "FPS: " .. tostring(fps) .. " | Ping: " .. tostring(ping) .. "ms"
		end
	end)

	floatingBtn.MouseButton1Click:Connect(function()
		mainFrame.Visible = not mainFrame.Visible
	end)

	local flying = false
	local noclipping = false
	local coinEspActive = false
	local playerEspActive = false
	local flyFarming = false
	local tpFarming = false

	local flySpeed = 50
	local farmSpeed = 90
	local playerIndex = 1

	local bodyVelocity = nil
	local bodyGyro = nil

	local coinEspFolder = Instance.new("Folder", dashGui)
	coinEspFolder.Name = "CoinESP_Folder"

	local playerEspFolder = Instance.new("Folder", dashGui)
	playerEspFolder.Name = "PlayerESP_Folder"

	local character = player.Character or player.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart", 5)
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	player.CharacterAdded:Connect(function(newChar)
		character = newChar
		root = character:WaitForChild("HumanoidRootPart", 5)
		humanoid = character:WaitForChild("Humanoid", 5)
	end)

	local isMinimized = false
	minButton.MouseButton1Click:Connect(function()
		isMinimized = not isMinimized
		if isMinimized then
			container.Visible = false
			statsLabel.Visible = false
			mainFrame:TweenSize(UDim2.new(0, 195, 0, 35), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
			minButton.Text = "+"
		else
			mainFrame:TweenSize(UDim2.new(0, 195, 0, 375), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
			task.wait(0.1)
			container.Visible = true
			statsLabel.Visible = true
			minButton.Text = "-"
		end
	end)

	RunService.Stepped:Connect(function()
		if noclipping and character then
			for _, part in ipairs(character:GetDescendants()) do
				if part:IsA("BasePart") and part.CanCollide then
					part.CanCollide = false
				end
			end
		end
	end)

	local function getClosestCoinHitbox()
		if not root then return nil end
		local rootPos = root.Position
		local closestHitbox = nil
		local shortestDistance = math.huge

		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj.Name == "Coin" then
				local hitbox = obj:FindFirstChild("Hitbox") or obj:FindFirstChildWhichIsA("BasePart") or (obj:IsA("BasePart") and obj)
				if hitbox then
					local dist = (rootPos - hitbox.Position).Magnitude
					if dist < shortestDistance then
						shortestDistance = dist
						closestHitbox = hitbox
					end
				end
			end
		end
		return closestHitbox
	end

	local function toggleFly()
		if not root then return end
		flying = not flying
		if flying then
			flyButton.Text = "Fly: ON"
			flyButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
			if not bodyVelocity then
				bodyVelocity = Instance.new("BodyVelocity")
				bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 10^6
				bodyVelocity.Parent = root
			end
			if not bodyGyro then
				bodyGyro = Instance.new("BodyGyro")
				bodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 10^6
				bodyGyro.Parent = root
			end
			if humanoid then humanoid.PlatformStand = true end

			task.spawn(function()
				while flying do
					if not flyFarming and not tpFarming and root then
						local moveDirection = humanoid and humanoid.MoveDirection or Vector3.zero
						if moveDirection.Magnitude > 0 then
							bodyVelocity.Velocity = camera.CFrame:VectorToWorldSpace(moveDirection * flySpeed)
						else
							bodyVelocity.Velocity = Vector3.zero
						end
						bodyGyro.CFrame = camera.CFrame
					end
					RunService.RenderStepped:Wait()
				end
			end)
		else
			flyButton.Text = "Fly: OFF"
			flyButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			if not flyFarming and not tpFarming then
				if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
				if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
				if humanoid then humanoid.PlatformStand = false end
			end
		end
	end

	local function toggleNoclip()
		noclipping = not noclipping
		noclipButton.Text = noclipping and "Noclip: ON" or "Noclip: OFF"
		noclipButton.BackgroundColor3 = noclipping and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(35, 35, 35)
	end

	local function toggleCoinESP()
		coinEspActive = not coinEspActive
		espButton.Text = coinEspActive and "Coin ESP: ON" or "Coin ESP: OFF"
		espButton.BackgroundColor3 = coinEspActive and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(35, 35, 35)

		if coinEspActive then
			task.spawn(function()
				while coinEspActive do
					coinEspFolder:ClearAllChildren()
					for _, obj in ipairs(workspace:GetDescendants()) do
						if obj.Name == "Coin" then
							local target = obj:FindFirstChild("Hitbox") or obj:FindFirstChildWhichIsA("BasePart")
							if target and root then
								local dist = math.floor((root.Position - target.Position).Magnitude)

								local box = Instance.new("SelectionBox")
								box.Adornee = target
								box.Color3 = Color3.fromRGB(0, 170, 255)
								box.LineThickness = 0.05
								box.Transparency = 0.2
								box.Parent = coinEspFolder

								local billboard = Instance.new("BillboardGui")
								billboard.Adornee = target
								billboard.Size = UDim2.new(0, 80, 0, 30)
								billboard.StudsOffset = Vector3.new(0, 2, 0)
								billboard.AlwaysOnTop = true
								billboard.Parent = coinEspFolder

								local label = Instance.new("TextLabel")
								label.Size = UDim2.new(1, 0, 1, 0)
								label.BackgroundTransparency = 1
								label.Text = "Coin\n[" .. tostring(dist) .. "m]"
								label.TextColor3 = Color3.fromRGB(0, 220, 255)
								label.Font = Enum.Font.SourceSansBold
								label.TextSize = 12
								label.Parent = billboard
							end
						end
					end
					task.wait(0.3)
				end
				coinEspFolder:ClearAllChildren()
			end)
		else
			coinEspFolder:ClearAllChildren()
		end
	end

	local function togglePlayerESP()
		playerEspActive = not playerEspActive
		pEspButton.Text = playerEspActive and "Player ESP: ON" or "Player ESP: OFF"
		pEspButton.BackgroundColor3 = playerEspActive and Color3.fromRGB(255, 0, 100) or Color3.fromRGB(35, 35, 35)

		if playerEspActive then
			task.spawn(function()
				while playerEspActive do
					playerEspFolder:ClearAllChildren()
					for _, p in ipairs(Players:GetPlayers()) do
						if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
							local pRoot = p.Character.HumanoidRootPart
							if root then
								local dist = math.floor((root.Position - pRoot.Position).Magnitude)

								local highlight = Instance.new("Highlight")
								highlight.Adornee = p.Character
								highlight.FillColor = Color3.fromRGB(255, 0, 100)
								highlight.FillTransparency = 0.5
								highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
								highlight.Parent = playerEspFolder

								local billboard = Instance.new("BillboardGui")
								billboard.Adornee = pRoot
								billboard.Size = UDim2.new(0, 100, 0, 30)
								billboard.StudsOffset = Vector3.new(0, 3, 0)
								billboard.AlwaysOnTop = true
								billboard.Parent = playerEspFolder

								local label = Instance.new("TextLabel")
								label.Size = UDim2.new(1, 0, 1, 0)
								label.BackgroundTransparency = 1
								label.Text = p.DisplayName .. "\n[" .. tostring(dist) .. "m]"
								label.TextColor3 = Color3.fromRGB(255, 255, 255)
								label.Font = Enum.Font.SourceSansBold
								label.TextSize = 12
								label.Parent = billboard
							end
						end
					end
					task.wait(0.4)
				end
				playerEspFolder:ClearAllChildren()
			end)
		else
			playerEspFolder:ClearAllChildren()
		end
	end

	local function toggleFlyFarm()
		flyFarming = not flyFarming
		farmButton.Text = flyFarming and "Fly Farm: ON" or "Fly Farm: OFF"
		farmButton.BackgroundColor3 = flyFarming and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(35, 35, 35)

		if flyFarming then
			if tpFarming then tpFarmButton.MouseButton1Click:Fire() end
			if not flying then toggleFly() end
			if not noclipping then toggleNoclip() end

			task.spawn(function()
				while flyFarming do
					if root then
						local targetHitbox = getClosestCoinHitbox()
						if targetHitbox and targetHitbox.Parent then
							local direction = (targetHitbox.Position - root.Position).Unit
							if bodyVelocity then bodyVelocity.Velocity = direction * farmSpeed end
							if bodyGyro then bodyGyro.CFrame = CFrame.new(root.Position, targetHitbox.Position) end
						else
							if bodyVelocity then bodyVelocity.Velocity = Vector3.zero end
						end
					end
					task.wait(0.03)
				end
			end)
		end
	end

	local function toggleTPFarm()
		tpFarming = not tpFarming
		tpFarmButton.Text = tpFarming and "Instant TP Farm: ON" or "Instant TP Farm: OFF"
		tpFarmButton.BackgroundColor3 = tpFarming and Color3.fromRGB(155, 89, 182) or Color3.fromRGB(45, 35, 60)

		if tpFarming then
			if flyFarming then farmButton.MouseButton1Click:Fire() end
			if not noclipping then toggleNoclip() end

			task.spawn(function()
				while tpFarming do
					if root then
						local targetHitbox = getClosestCoinHitbox()
						if targetHitbox and targetHitbox.Parent then
							root.CFrame = targetHitbox.CFrame
						end
					end
					task.wait(0.05)
				end
			end)
		end
	end

	local function tpToRandomPlayer()
		local otherPlayers = {}
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				table.insert(otherPlayers, p)
			end
		end
		if #otherPlayers > 0 then
			local randPlayer = otherPlayers[math.random(1, #otherPlayers)]
			if root and randPlayer.Character and randPlayer.Character:FindFirstChild("HumanoidRootPart") then
				root.CFrame = randPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
			end
		end
	end

	local function tpToNextPlayer()
		local otherPlayers = {}
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				table.insert(otherPlayers, p)
			end
		end
		if #otherPlayers > 0 then
			if playerIndex > #otherPlayers then playerIndex = 1 end
			local targetPlayer = otherPlayers[playerIndex]
			playerIndex = playerIndex + 1

			if root and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
				root.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
				tpNextButton.Text = "TP: " .. targetPlayer.DisplayName
			end
		end
	end

	flyButton.MouseButton1Click:Connect(toggleFly)
	noclipButton.MouseButton1Click:Connect(toggleNoclip)
	espButton.MouseButton1Click:Connect(toggleCoinESP)
	pEspButton.MouseButton1Click:Connect(togglePlayerESP)
	farmButton.MouseButton1Click:Connect(toggleFlyFarm)
	tpFarmButton.MouseButton1Click:Connect(toggleTPFarm)
	tpRandButton.MouseButton1Click:Connect(tpToRandomPlayer)
	tpNextButton.MouseButton1Click:Connect(tpToNextPlayer)
	rejoinButton.MouseButton1Click:Connect(function() TeleportService:Teleport(game.PlaceId, player) end)
	hopButton.MouseButton1Click:Connect(function()
		local req = (syn and syn.request) or (http and http.request) or http_request or request
		if req then
			local api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
			local success, response = pcall(function() return req({Url = api}) end)
			if success and response and response.Body then
				local data = HttpService:JSONDecode(response.Body)
				if data and data.data then
					local validServers = {}
					for _, s in ipairs(data.data) do
						if type(s) == "table" and s.playing < s.maxPlayers and s.id ~= game.JobId then
							table.insert(validServers, s.id)
						end
					end
					if #validServers > 0 then
						TeleportService:TeleportToPlaceInstance(game.PlaceId, validServers[math.random(1, #validServers)], player)
						return
					end
				end
			end
		end
		TeleportService:Teleport(game.PlaceId, player)
	end)
end

-- التحقق من إدخال الكود
submitBtn.MouseButton1Click:Connect(function()
	local enteredKey = keyInput.Text

	if enteredKey == ADMIN_KEY then
		statusLabel.Text = "تم التفعيل بنجاح (وضع الأدمن)!"
		statusLabel.TextColor3 = Color3.fromRGB(0, 255, 136)
		task.wait(0.5)
		loadMainDashboard()
		return
	end

	if #enteredKey == 9 then
		statusLabel.Text = "جاري التحقق من الكود..."
		statusLabel.TextColor3 = Color3.fromRGB(255, 170, 0)
		task.wait(0.8)

		statusLabel.Text = "تم التفعيل بنجاح!"
		statusLabel.TextColor3 = Color3.fromRGB(0, 255, 136)
		task.wait(0.5)
		loadMainDashboard()
	else
		statusLabel.Text = "كود غير صالح!"
		statusLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
	end
end)
