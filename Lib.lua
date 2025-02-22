-- // My Custom UI Library // --
local MyUILib = {}
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- // UI Main Setup // --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Enabled = true

-- // Blur Effect // --
local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = Lighting

-- // Function to Toggle UI // --
local function ToggleUI(visible)
    ScreenGui.Enabled = visible
    Blur.Size = visible and 10 or 0
end

-- // Draggable Function // --
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- // Main Window Creation // --
function MyUILib:CreateWindow(title)
    local Window = {}
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.Parent = MainFrame

    -- Make Window Draggable --
    MakeDraggable(MainFrame)

    Window.Frame = MainFrame
    return Window
end

-- // Button Creation // --
function MyUILib:CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 150, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Parent = parent.Frame

    -- Hover Effect --
    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end)
    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end)

    -- Click Effect --
    Button.MouseButton1Click:Connect(callback)
    
    return Button
end

-- // Toggle Creation // --
function MyUILib:CreateToggle(parent, text, default, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0, 150, 0, 40)
    Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Toggle.Text = text .. ": " .. (default and "ON" or "OFF")
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.Parent = parent.Frame

    local state = default
    Toggle.MouseButton1Click:Connect(function()
        state = not state
        Toggle.Text = text .. ": " .. (state and "ON" or "OFF")
        callback(state)
    end)

    return Toggle
end

-- // Slider Creation // --
function MyUILib:CreateSlider(parent, text, min, max, default, callback)
    local Slider = Instance.new("TextButton")
    Slider.Size = UDim2.new(0, 150, 0, 40)
    Slider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Slider.Text = text .. ": " .. tostring(default)
    Slider.TextColor3 = Color3.fromRGB(255, 255, 255)
    Slider.Parent = parent.Frame

    local value = default
    Slider.MouseButton1Click:Connect(function()
        value = math.clamp(value + 5, min, max)
        Slider.Text = text .. ": " .. tostring(value)
        callback(value)
    end)

    return Slider
end

-- // Keybind System (RightShift) // --
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        ScreenGui.Enabled = not ScreenGui.Enabled
        Blur.Size = ScreenGui.Enabled and 10 or 0
    end
end)

return MyUILib
