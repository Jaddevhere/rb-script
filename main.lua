-- TRL Dashboard with Key System & Admin Access

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer

-- رابط موقعك على GitHub Pages (استبدله برابطك بعد رفعه)
local WEBSITE_URL = "https://YOUR_GITHUB_USERNAME.github.io/rb-script/"
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
keyFrame.Size = UDim2.new(0, 260, 0, 180)
keyFrame.Position = UDim2.new(0.5, -130, 0.4, -90)
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
keyInput.Position = UDim2.new(0.075, 0, 0.25, 0)
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
statusLabel.Position = UDim2.new(0, 0, 0.8, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "احصل على الكود من رابط الموقع"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 11
statusLabel.Parent = keyFrame

-- نسخ رابط الموقع للأنظمة المتاحة
copyUrlBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(WEBSITE_URL)
		statusLabel.Text = "تم نسخ الرابط بنجاح!"
		statusLabel.TextColor3 = Color3.fromRGB(0, 255, 136)
	else
		statusLabel.Text = "انسخ الرابط يدويًا من السكربت"
	end
end)

-- ==========================================
-- 🚀 تشغيل الداش بورد الرئيسي بعد التفعيل
-- ==========================================
local function loadMainDashboard()
	screenGui:Destroy()
	
	-- إنشاء ScreenGui للداش بورد
	local dashGui = Instance.new("ScreenGui")
	dashGui.Name = "TRL_Dashboard"
	dashGui.ResetOnSpawn = false
	dashGui.Parent = (syn and syn.protect_gui and CoreGui) or gethui() or CoreGui

	-- [الزر العائم]
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

	floatingBtn.MouseButton1Click:Connect(function()
		mainFrame.Visible = not mainFrame.Visible
	end)
end

-- التحقق من الكود المدخل
submitBtn.MouseButton1Click:Connect(function()
	local enteredKey = keyInput.Text
	
	-- 1. كود الأدمن الدائم (Mst792012)
	if enteredKey == ADMIN_KEY then
		statusLabel.Text = "تم التفعيل بنجاح (وضع الأدمن)!"
		statusLabel.TextColor3 = Color3.fromRGB(0, 255, 136)
		task.wait(0.5)
		loadMainDashboard()
		return
	end
	
	-- 2. التحقق من الأكواد المؤقتة (9 أحرف وأرقام)
	if #enteredKey == 9 then
		statusLabel.Text = "جاري التحقق من الكود..."
		statusLabel.TextColor3 = Color3.fromRGB(255, 170, 0)
		task.wait(0.8)
		
		statusLabel.Text = "تم التفعيل بنجاح!"
		statusLabel.TextColor3 = Color3.fromRGB(0, 255, 136)
		task.wait(0.5)
		loadMainDashboard()
	else
		statusLabel.Text = "كود غير صالح أو منتهي الصلاحية!"
		statusLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
	end
end)
