-- Key system
local Keys = {
    {Key="Tractor", GameId=95712269457211, loader="http://paid2.daki.cc:4016/BuildATractor.lua"},
    {Key="Harvester", GameId=95712269457211, loader="http://paid2.daki.cc:4016/BuildAHarvester.lua"}
}

if not your_key then error("No key provided!") end
local entry
for _,v in ipairs(Keys) do if v.Key==your_key then entry=v break end end
if not entry then error("Invalid key!") end
if tostring(entry.GameId) ~= tostring(game.PlaceId) then error("Game not supported!") end

-- Screen GUI setup (exploit-safe)
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "LoaderGui"
gui.Parent = (gethui and gethui()) or player:WaitForChild("PlayerGui")
if syn and syn.protect_gui then syn.protect_gui(gui) end

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 500, 0, 50)
label.Position = UDim2.new(0.5, -250, 0.4, 0)
label.BackgroundTransparency = 0.5
label.BackgroundColor3 = Color3.fromRGB(0,0,0)
label.TextColor3 = Color3.fromRGB(255,255,255)
label.Font = Enum.Font.Code
label.TextSize = 24
label.Text = ""
label.Parent = gui

-- Animation variables
local spinner = {"|","/","-","\\"}
local colors = {
    Color3.fromRGB(255,0,0), Color3.fromRGB(255,128,0),
    Color3.fromRGB(255,255,0), Color3.fromRGB(0,255,0),
    Color3.fromRGB(0,255,255), Color3.fromRGB(0,0,255),
    Color3.fromRGB(128,0,255), Color3.fromRGB(255,0,255)
}

local totalSteps = 100
for i = 1, totalSteps do
    local progress = i / totalSteps
    local filled = math.floor(progress * 20)
    local bar = string.rep("█", filled) .. string.rep("░", 20 - filled)
    local spin = spinner[i % #spinner + 1]
    local dots = string.rep(".", (i % 3) + 1)
    local color = colors[i % #colors + 1]
    label.Text = "Loading ["..bar.."] "..spin..dots
    label.TextColor3 = color
    task.wait(0.05)
end

-- Fetch and execute loader using exploit HTTP functions
local success, err = pcall(function()
    local code
    if syn and syn.request then
        local response = syn.request({Url = entry.loader, Method = "GET"})
        code = response.Body
    else
        code = game:HttpGet(entry.loader)
    end
    local func = loadstring(code)
    if func then func()() end
end)

if not success then
    local errorLabel = Instance.new("TextLabel")
    errorLabel.Size = UDim2.new(0, 500, 0, 50)
    errorLabel.Position = UDim2.new(0.5, -250, 0.5, 0)
    errorLabel.BackgroundTransparency = 0.5
    errorLabel.BackgroundColor3 = Color3.fromRGB(0,0,0)
    errorLabel.TextColor3 = Color3.fromRGB(255,0,0)
    errorLabel.Font = Enum.Font.Code
    errorLabel.TextSize = 24
    errorLabel.Text = "Error loading script!"
    errorLabel.Parent = gui
end

-- Cleanup GUI after a short delay
task.wait(1)
gui:Destroy()
