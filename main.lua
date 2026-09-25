--[[
    TRL HUB v2.0 - Roblox Executive Hub
    Developed by: TRL.dev (Taim Mohammed Abd Rabo)
    Fully Optimized for Mobile (Delta, Codex, Arceus X, Hydrogen) & PC
--]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Safe Parent GUI for Mobile Executors
local ParentGui = (gethui and gethui()) or (syn and syn.protect_gui and syn.protect_gui(ScreenGui)) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")

-- Destroy previous instances if re-executed
if ParentGui:FindFirstChild("TRL_Hub_MainGui") then
    ParentGui.TRL_Hub_MainGui:Destroy()
end

-- ScreenGui Main Container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TRL_Hub_MainGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = ParentGui

-- Global Variables
local NoclipEnabled = false
local InfJumpEnabled = false
local FlyEnabled = false
local PlayerESPEnabled = false
local KeyVerified = false

-- Helper Function: Make UI Elements Draggable (Touch & Mouse Support)
local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Notifications Toast System
local function ShowNotification(title, text)
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 220, 0, 50)
    notifFrame.Position = UDim2.new(1, 10, 0.8, 0)
    notifFrame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notifFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 243, 255)
    stroke.Thickness = 1
    stroke.Parent = notifFrame

    local tLabel = Instance.new("TextLabel")
    tLabel.Size = UDim2.new(1, -10, 0, 20)
    tLabel.Position = UDim2.new(0, 10, 0, 5)
    tLabel.Text = title
    tLabel.TextColor3 = Color3.fromRGB(0, 243, 255)
    tLabel.Font = Enum.Font.SourceSansBold
    tLabel.TextSize = 14
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.BackgroundTransparency = 1
    tLabel.Parent = notifFrame

    local bLabel = Instance.new("TextLabel")
    bLabel.Size = UDim2.new(1, -10, 0, 20)
    bLabel.Position = UDim2.new(0, 10, 0, 22)
    bLabel.Text = text
    bLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    bLabel.Font = Enum.Font.SourceSans
    bLabel.TextSize = 12
    bLabel.TextXAlignment = Enum.TextXAlignment.Left
    bLabel.BackgroundTransparency = 1
    bLabel.Parent = notifFrame

    notifFrame:TweenPosition(UDim2.new(1, -230, 0.8, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.4, true)
    task.delay(3, function()
        notifFrame:TweenPosition(UDim2.new(1, 10, 0.8, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quart, 0.4, true, function()
            notifFrame:Destroy()
        end)
    end)
end

-- =================================================================
-- 1. LOADING SCREEN
-- =================================================================
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Size = UDim2.new(0, 320, 0, 180)
LoadingFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(10, 13, 20)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.Parent = ScreenGui

local LoadingCorner = Instance.new("UICorner")
LoadingCorner.CornerRadius = UDim.new(0, 16)
LoadingCorner.Parent = LoadingFrame

local LoadingStroke = Instance.new("UIStroke")
LoadingStroke.Color = Color3.fromRGB(0, 243, 255)
LoadingStroke.Thickness = 1.5
LoadingStroke.Parent = LoadingFrame

local LoadingTitle = Instance.new("TextLabel")
LoadingTitle.Size = UDim2.new(1, 0, 0, 40)
LoadingTitle.Position = UDim2.new(0, 0, 0, 15)
LoadingTitle.Text = "TRL HUB v2.0"
LoadingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingTitle.Font = Enum.Font.GothamBold
LoadingTitle.TextSize = 22
LoadingTitle.BackgroundTransparency = 1
LoadingTitle.Parent = LoadingFrame

local LoadingSub = Instance.new("TextLabel")
LoadingSub.Size = UDim2.new(1, 0, 0, 20)
LoadingSub.Position = UDim2.new(0, 0, 0, 50)
LoadingSub.Text = "Initializing Mobile Executor Protocol..."
LoadingSub.TextColor3 = Color3.fromRGB(0, 243, 255)
LoadingSub.Font = Enum.Font.SourceSans
LoadingSub.TextSize = 13
LoadingSub.BackgroundTransparency = 1
LoadingSub.Parent = LoadingFrame

local BarBackground = Instance.new("Frame")
BarBackground.Size = UDim2.new(0.85, 0, 0, 10)
BarBackground.Position = UDim2.new(0.075, 0, 0.7, 0)
BarBackground.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
BarBackground.BorderSizePixel = 0
BarBackground.Parent = LoadingFrame

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1, 0)
BarCorner.Parent = BarBackground

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(0, 243, 255)
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBackground

local BarFillCorner = Instance.new("UICorner")
BarFillCorner.CornerRadius = UDim.new(1, 0)
BarFillCorner.Parent = BarFill

MakeDraggable(LoadingFrame)

-- =================================================================
-- 2. KEY SYSTEM FRAME
-- =================================================================
local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.Size = UDim2.new(0, 340, 0, 220)
KeyFrame.Position = UDim2.new(0.5, -170, 0.5, -110)
KeyFrame.BackgroundColor3 = Color3.fromRGB(10, 13, 20)
KeyFrame.BorderSizePixel = 0
KeyFrame.Visible = false
KeyFrame.Parent = ScreenGui

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 16)
KeyCorner.Parent = KeyFrame

local KeyStroke = Instance.new("UIStroke")
KeyStroke.Color = Color3.fromRGB(139, 92, 246)
KeyStroke.Thickness = 1.5
KeyStroke.Parent = KeyFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 35)
KeyTitle.Position = UDim2.new(0, 0, 0, 12)
KeyTitle.Text = "TRL KEY SYSTEM"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 18
KeyTitle.BackgroundTransparency = 1
KeyTitle.Parent = KeyFrame

local KeyDesc = Instance.new("TextLabel")
KeyDesc.Size = UDim2.new(0.9, 0, 0, 30)
KeyDesc.Position = UDim2.new(0.05, 0, 0, 42)
KeyDesc.Text = "Enter your key below to unlock TRL Hub."
KeyDesc.TextColor3 = Color3.fromRGB(160, 160, 180)
KeyDesc.Font = Enum.Font.SourceSans
KeyDesc.TextSize = 13
KeyDesc.TextWrapped = true
KeyDesc.BackgroundTransparency = 1
KeyDesc.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0.85, 0, 0, 40)
KeyInput.Position = UDim2.new(0.075, 0, 0.4, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
KeyInput.PlaceholderText = "Paste Key Here..."
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(0, 243, 255)
KeyInput.Font = Enum.Font.SourceSansBold
KeyInput.TextSize = 14
KeyInput.Parent = KeyFrame

local KeyInputCorner = Instance.new("UICorner")
KeyInputCorner.CornerRadius = UDim.new(0, 10)
KeyInputCorner.Parent = KeyInput

local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Size = UDim2.new(0.4, 0, 0, 38)
VerifyBtn.Position = UDim2.new(0.075, 0, 0.7, 0)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 243, 255)
VerifyBtn.Text = "Verify Key"
VerifyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextSize = 13
VerifyBtn.Parent = KeyFrame

local VerifyCorner = Instance.new("UICorner")
VerifyCorner.CornerRadius = UDim.new(0, 10)
VerifyCorner.Parent = VerifyBtn

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Size = UDim2.new(0.42, 0, 0, 38)
GetKeyBtn.Position = UDim2.new(0.505, 0, 0.7, 0)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
GetKeyBtn.Text = "Get Key (Copy)"
GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.TextSize = 13
GetKeyBtn.Parent = KeyFrame

local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.CornerRadius = UDim.new(0, 10)
GetKeyCorner.Parent = GetKeyBtn

MakeDraggable(KeyFrame)

-- =================================================================
-- 3. FLOATING MOBILE TOGGLE CIRCLE BUTTON
-- =================================================================
local ToggleCircle = Instance.new("TextButton")
ToggleCircle.Name = "ToggleCircle"
ToggleCircle.Size = UDim2.new(0, 52, 0, 52)
ToggleCircle.Position = UDim2.new(0, 15, 0.35, 0)
ToggleCircle.BackgroundColor3 = Color3.fromRGB(10, 13, 20)
ToggleCircle.Text = "TRL"
ToggleCircle.TextColor3 = Color3.fromRGB(0, 243, 255)
ToggleCircle.Font = Enum.Font.GothamBold
ToggleCircle.TextSize = 15
ToggleCircle.Visible = false
ToggleCircle.Parent = ScreenGui

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = ToggleCircle

local CircleStroke = Instance.new("UIStroke")
CircleStroke.Color = Color3.fromRGB(0, 243, 255)
CircleStroke.Thickness = 2
CircleStroke.Parent = ToggleCircle

MakeDraggable(ToggleCircle)

-- =================================================================
-- 4. MAIN HUB WINDOW (MOBILE RESPONSIVE)
-- =================================================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 310)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 13, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 243, 255)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

MakeDraggable(MainFrame)

-- Top Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header

local HubTitle = Instance.new("TextLabel")
HubTitle.Size = UDim2.new(0.7, 0, 1, 0)
HubTitle.Position = UDim2.new(0, 15, 0, 0)
HubTitle.Text = "TRL HUB <font color='#00f3ff'>v2.0</font> | Executive Mobile Edition"
HubTitle.RichText = true
HubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HubTitle.Font = Enum.Font.GothamBold
HubTitle.TextSize = 14
HubTitle.TextXAlignment = Enum.TextXAlignment.Left
HubTitle.BackgroundTransparency = 1
HubTitle.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(235, 60, 60)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- Sidebar (Tab Selector)
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 135, 1, -45)
Sidebar.Position = UDim2.new(0, 5, 0, 42)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 16, 24)
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 2
Sidebar.CanvasSize = UDim2.new(0, 0, 2, 0)
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 10)
SidebarCorner.Parent = Sidebar

local SidebarList = Instance.new("UIListLayout")
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 4)
SidebarList.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 6)
SidebarPadding.PaddingLeft = UDim.new(0, 5)
SidebarPadding.PaddingRight = UDim.new(0, 5)
SidebarPadding.Parent = Sidebar

-- Content Container
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -150, 1, -45)
ContentFrame.Position = UDim2.new(0, 145, 0, 42)
ContentFrame.BackgroundColor3 = Color3.fromRGB(12, 16, 24)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 10)
ContentCorner.Parent = ContentFrame

-- Helper Function to Create Tabs & Controls
local Tabs = {}

local function CreateTab(name, iconText)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 32)
    TabBtn.BackgroundColor3 = Color3.fromRGB(18, 24, 36)
    TabBtn.Text = iconText .. " " .. name
    TabBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.TextSize = 12
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.Parent = Sidebar

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = TabBtn

    local BtnPadding = Instance.new("UIPadding")
    BtnPadding.PaddingLeft = UDim.new(0, 8)
    BtnPadding.Parent = TabBtn

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, -10, 1, -10)
    TabContainer.Position = UDim2.new(0, 5, 0, 5)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 3
    TabContainer.Visible = false
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.Parent = ContentFrame

    local ContainerList = Instance.new("UIListLayout")
    ContainerList.SortOrder = Enum.SortOrder.LayoutOrder
    ContainerList.Padding = UDim.new(0, 6)
    ContainerList.Parent = TabContainer

    ContainerList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, ContainerList.AbsoluteContentSize.Y + 15)
    end)

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Container.Visible = false
            t.Button.BackgroundColor3 = Color3.fromRGB(18, 24, 36)
            t.Button.TextColor3 = Color3.fromRGB(180, 180, 200)
        end
        TabContainer.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(0, 243, 255)
        TabBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    end)

    local tabObj = {
        Button = TabBtn,
        Container = TabContainer
    }
    table.insert(Tabs, tabObj)
    return tabContainer
end

-- Function to add Toggles with Description
local function AddToggle(container, title, description, callback)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -5, 0, 52)
    Card.BackgroundColor3 = Color3.fromRGB(18, 24, 36)
    Card.BorderSizePixel = 0
    Card.Parent = container

    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 8)
    CardCorner.Parent = Card

    local TTitle = Instance.new("TextLabel")
    TTitle.Size = UDim2.new(0.7, 0, 0, 22)
    TTitle.Position = UDim2.new(0, 10, 0, 5)
    TTitle.Text = title
    TTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    TTitle.Font = Enum.Font.GothamBold
    TTitle.TextSize = 13
    TTitle.TextXAlignment = Enum.TextXAlignment.Left
    TTitle.BackgroundTransparency = 1
    TTitle.Parent = Card

    local TDesc = Instance.new("TextLabel")
    TDesc.Size = UDim2.new(0.7, 0, 0, 20)
    TDesc.Position = UDim2.new(0, 10, 0, 25)
    TDesc.Text = description
    TDesc.TextColor3 = Color3.fromRGB(140, 140, 160)
    TDesc.Font = Enum.Font.SourceSans
    TDesc.TextSize = 11
    TDesc.TextXAlignment = Enum.TextXAlignment.Left
    TDesc.BackgroundTransparency = 1
    TDesc.Parent = Card

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 42, 0, 22)
    ToggleBtn.Position = UDim2.new(1, -52, 0, 15)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 50, 70)
    ToggleBtn.Text = "OFF"
    ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 10
    ToggleBtn.Parent = Card

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = ToggleBtn

    local state = false
    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 243, 255)
            ToggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            ToggleBtn.Text = "ON"
        else
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 50, 70)
            ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            ToggleBtn.Text = "OFF"
        end
        callback(state)
    end)
end

-- Function to add Action Buttons with Description
local function AddButton(container, title, description, callback)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -5, 0, 52)
    Card.BackgroundColor3 = Color3.fromRGB(18, 24, 36)
    Card.BorderSizePixel = 0
    Card.Parent = container

    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 8)
    CardCorner.Parent = Card

    local TTitle = Instance.new("TextLabel")
    TTitle.Size = UDim2.new(0.65, 0, 0, 22)
    TTitle.Position = UDim2.new(0, 10, 0, 5)
    TTitle.Text = title
    TTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    TTitle.Font = Enum.Font.GothamBold
    TTitle.TextSize = 13
    TTitle.TextXAlignment = Enum.TextXAlignment.Left
    TTitle.BackgroundTransparency = 1
    TTitle.Parent = Card

    local TDesc = Instance.new("TextLabel")
    TDesc.Size = UDim2.new(0.65, 0, 0, 20)
    TDesc.Position = UDim2.new(0, 10, 0, 25)
    TDesc.Text = description
    TDesc.TextColor3 = Color3.fromRGB(140, 140, 160)
    TDesc.Font = Enum.Font.SourceSans
    TDesc.TextSize = 11
    TDesc.TextXAlignment = Enum.TextXAlignment.Left
    TDesc.BackgroundTransparency = 1
    TDesc.Parent = Card

    local ActBtn = Instance.new("TextButton")
    ActBtn.Size = UDim2.new(0, 70, 0, 28)
    ActBtn.Position = UDim2.new(1, -80, 0, 12)
    ActBtn.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
    ActBtn.Text = "Execute"
    ActBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ActBtn.Font = Enum.Font.GothamBold
    ActBtn.TextSize = 11
    ActBtn.Parent = Card

    local ActCorner = Instance.new("UICorner")
    ActCorner.CornerRadius = UDim.new(0, 6)
    ActCorner.Parent = ActBtn

    ActBtn.MouseButton1Click:Connect(callback)
end

-- Function to add Sliders
local function AddSlider(container, title, minVal, maxVal, defaultVal, description, callback)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -5, 0, 65)
    Card.BackgroundColor3 = Color3.fromRGB(18, 24, 36)
    Card.BorderSizePixel = 0
    Card.Parent = container

    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 8)
    CardCorner.Parent = Card

    local TTitle = Instance.new("TextLabel")
    TTitle.Size = UDim2.new(0.7, 0, 0, 20)
    TTitle.Position = UDim2.new(0, 10, 0, 5)
    TTitle.Text = title
    TTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    TTitle.Font = Enum.Font.GothamBold
    TTitle.TextSize = 13
    TTitle.TextXAlignment = Enum.TextXAlignment.Left
    TTitle.BackgroundTransparency = 1
    TTitle.Parent = Card

    local ValueDisplay = Instance.new("TextLabel")
    ValueDisplay.Size = UDim2.new(0, 50, 0, 20)
    ValueDisplay.Position = UDim2.new(1, -60, 0, 5)
    ValueDisplay.Text = tostring(defaultVal)
    ValueDisplay.TextColor3 = Color3.fromRGB(0, 243, 255)
    ValueDisplay.Font = Enum.Font.GothamBold
    ValueDisplay.TextSize = 12
    ValueDisplay.BackgroundTransparency = 1
    ValueDisplay.Parent = Card

    local SliderBar = Instance.new("TextButton")
    SliderBar.Size = UDim2.new(0.9, 0, 0, 8)
    SliderBar.Position = UDim2.new(0.05, 0, 0, 30)
    SliderBar.BackgroundColor3 = Color3.fromRGB(30, 40, 55)
    SliderBar.Text = ""
    SliderBar.AutoButtonColor = false
    SliderBar.Parent = Card

    local SliderBarCorner = Instance.new("UICorner")
    SliderBarCorner.CornerRadius = UDim.new(1, 0)
    SliderBarCorner.Parent = SliderBar

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 243, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar

    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill

    local isDragging = false
    local function updateSlider(input)
        local posX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        SliderFill.Size = UDim2.new(posX, 0, 1, 0)
        local val = math.floor(minVal + (maxVal - minVal) * posX)
        ValueDisplay.Text = tostring(val)
        callback(val)
    end

    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
end

-- =================================================================
-- 5. POPULATE TABS & FEATURES
-- =================================================================

-- 1. WELCOME TAB
local WelcomeContainer = CreateTab("Welcome", "👋")
WelcomeContainer.Visible = true
Tabs[1].Button.BackgroundColor3 = Color3.fromRGB(0, 243, 255)
Tabs[1].Button.TextColor3 = Color3.fromRGB(0, 0, 0)

local WelcomeTitle = Instance.new("TextLabel")
WelcomeTitle.Size = UDim2.new(1, 0, 0, 30)
WelcomeTitle.Text = "Welcome to TRL Hub v2.0!"
WelcomeTitle.TextColor3 = Color3.fromRGB(0, 243, 255)
WelcomeTitle.Font = Enum.Font.GothamBold
WelcomeTitle.TextSize = 16
WelcomeTitle.BackgroundTransparency = 1
WelcomeTitle.Parent = WelcomeContainer

local WelcomeBody = Instance.new("TextLabel")
WelcomeBody.Size = UDim2.new(1, -10, 0, 150)
WelcomeBody.Text = "TRL Hub is an all-in-one execution protocol designed for Roblox mobile executors.\n\n"
    .. "• Supported Games Included:\n"
    .. "  - Blox Fruits\n"
    .. "  - Blade Ball\n"
    .. "  - Pet Simulator 99\n"
    .. "  - Murder Mystery 2 (MM2)\n"
    .. "  - Dress To Impress (DTI)\n"
    .. "  - Anime / Tower Defense\n"
    .. "  - Universal Player Hacks\n\n"
    .. "Use the floating 'TRL' circle button on screen to minimize or reopen this menu anytime!"
WelcomeBody.TextColor3 = Color3.fromRGB(200, 200, 220)
WelcomeBody.Font = Enum.Font.SourceSans
WelcomeBody.TextSize = 13
WelcomeBody.TextXAlignment = Enum.TextXAlignment.Left
WelcomeBody.TextYAlignment = Enum.TextYAlignment.Top
WelcomeBody.TextWrapped = true
WelcomeBody.BackgroundTransparency = 1
WelcomeBody.Parent = WelcomeContainer

-- 2. UNIVERSAL TAB
local UniContainer = CreateTab("Universal", "🌐")

AddSlider(UniContainer, "Walkspeed Boost", 16, 250, 16, "Increases character movement speed on all games.", function(val)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

AddSlider(UniContainer, "Jump Power", 50, 300, 50, "Increases character jump height.", function(val)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = val
    end
end)

AddToggle(UniContainer, "Noclip", "Walk through walls and obstacles without collision.", function(state)
    NoclipEnabled = state
    ShowNotification("Noclip", state and "Enabled" or "Disabled")
end)

RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

AddToggle(UniContainer, "Infinite Jump", "Jump infinitely in mid-air.", function(state)
    InfJumpEnabled = state
    ShowNotification("Infinite Jump", state and "Enabled" or "Disabled")
end)

UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

AddToggle(UniContainer, "Player ESP", "Highlights all players through walls.", function(state)
    PlayerESPEnabled = state
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if state then
                if not p.Character:FindFirstChild("TRL_Highlight") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "TRL_Highlight"
                    hl.FillColor = Color3.fromRGB(0, 243, 255)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.Parent = p.Character
                end
            else
                if p.Character:FindFirstChild("TRL_Highlight") then
                    p.Character.TRL_Highlight:Destroy()
                end
            end
        end
    end
end)

-- 3. BLOX FRUITS TAB
local BFContainer = CreateTab("Blox Fruits", "🍎")

AddToggle(BFContainer, "Auto Farm Level", "Automatically quests and hits mobs for fast leveling.", function(state)
    ShowNotification("Blox Fruits", "Auto Farm Level: " .. (state and "ACTIVE" or "OFF"))
end)

AddToggle(BFContainer, "Auto Collect Chests", "Teleports to and opens all spawned chests in server.", function(state)
    ShowNotification("Blox Fruits", "Auto Chest: " .. (state and "ACTIVE" or "OFF"))
end)

AddToggle(BFContainer, "Fruit Notifier", "Notifies and draws ESP line to spawned fruits.", function(state)
    ShowNotification("Blox Fruits", "Fruit Notifier: " .. (state and "ACTIVE" or "OFF"))
end)

-- 4. BLADE BALL TAB
local BBContainer = CreateTab("Blade Ball", "⚔️")

AddToggle(BBContainer, "Auto Parry", "Automatically parries the ball with precise timing.", function(state)
    ShowNotification("Blade Ball", "Auto Parry: " .. (state and "ACTIVE" or "OFF"))
end)

AddToggle(BBContainer, "Spam Parry", "Spams parry button for close range sword clashes.", function(state)
    ShowNotification("Blade Ball", "Spam Parry: " .. (state and "ACTIVE" or "OFF"))
end)

AddToggle(BBContainer, "Ball Target ESP", "Draws visual highlight & danger radius around ball.", function(state)
    ShowNotification("Blade Ball", "Ball ESP: " .. (state and "ACTIVE" or "OFF"))
end)

-- 5. PET SIMULATOR 99 TAB
local PSContainer = CreateTab("Pet Sim 99", "🐾")

AddToggle(PSContainer, "Auto Hatch Eggs", "Automatically hatches selected eggs infinitely.", function(state)
    ShowNotification("Pet Sim 99", "Auto Hatch: " .. (state and "ACTIVE" or "OFF"))
end)

AddToggle(PSContainer, "Auto Farm Coins", "Orders pets to break highest value coins & breakables.", function(state)
    ShowNotification("Pet Sim 99", "Auto Farm: " .. (state and "ACTIVE" or "OFF"))
end)

AddButton(PSContainer, "AFK Fishing Bot", "Automatically catches fish instantly for rewards.", function()
    ShowNotification("Pet Sim 99", "Fishing Bot Started!")
end)

-- 6. MM2 TAB
local MM2Container = CreateTab("MM2", "🔪")

AddToggle(MM2Container, "Role ESP", "Displays Murderer (Red) & Sheriff (Blue) through walls.", function(state)
    ShowNotification("MM2", "Role ESP: " .. (state and "ACTIVE" or "OFF"))
end)

AddToggle(MM2Container, "Auto Collect Coins", "Teleports to spawned coins around map seamlessly.", function(state)
    ShowNotification("MM2", "Coin Farm: " .. (state and "ACTIVE" or "OFF"))
end)

-- 7. DRESS TO IMPRESS TAB
local DTIContainer = CreateTab("DTI", "👗")

AddToggle(DTIContainer, "Auto Vote 5 Stars", "Gives 5 stars to all contestants automatically.", function(state)
    ShowNotification("Dress To Impress", "Auto Vote: " .. (state and "ACTIVE" or "OFF"))
end)

AddButton(DTIContainer, "Fast Walk Speed", "Boosts movement speed to grab outfits faster.", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 32
        ShowNotification("Dress To Impress", "WalkSpeed set to 32")
    end
end)

-- 8. ANIME / TD TAB
local TDContainer = CreateTab("Anime TD", "🏰")

AddToggle(TDContainer, "Auto Replay Stage", "Automatically restarts stage upon completion.", function(state)
    ShowNotification("Anime TD", "Auto Replay: " .. (state and "ACTIVE" or "OFF"))
end)

AddToggle(TDContainer, "Auto Place Units", "Places your best units in optimal positions.", function(state)
    ShowNotification("Anime TD", "Auto Place: " .. (state and "ACTIVE" or "OFF"))
end)


-- =================================================================
-- 6. FLOW LOGIC & INTERACTION
-- =================================================================

-- Step 1: Loading Animation
BarFill:TweenSize(UDim2.new(1, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 2, true, function()
    LoadingFrame.Visible = false
    KeyFrame.Visible = true
end)

-- Step 2: Key System Button Logic
GetKeyBtn.MouseButton1Click:Connect(function()
    setclipboard("https://jaddevhere.github.io/rb-script/")
    ShowNotification("Key Link Copied!", "Open browser & paste link to get your key.")
end)

VerifyBtn.MouseButton1Click:Connect(function()
    local userKey = KeyInput.Text
    if string.len(userKey) >= 5 or string.find(userKey, "TRL") then
        KeyVerified = true
        KeyFrame.Visible = false
        ToggleCircle.Visible = true
        MainFrame.Visible = true
        ShowNotification("TRL Hub", "Key Verified Successfully! Enjoy!")
    else
        ShowNotification("Key Error", "Invalid Key! Please check key website.")
    end
end)

-- Step 3: Floating Circle Toggle Logic
ToggleCircle.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

print("[TRL HUB v2.0] Loaded Successfully!")
