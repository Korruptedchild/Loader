-- Key system
local Keys={
    {Key="Tractor", GameId=95712269457211, loader="http://paid2.daki.cc:4016/BuildATractor.lua"},
    {Key="Harvester", GameId=95712269457211, loader="http://paid2.daki.cc:4016/BuildAHarvester.lua"}
}

if not your_key then error("No key provided!") end

local entry
for _,v in ipairs(Keys) do
    if v.Key == your_key then entry = v break end
end
if not entry then error("Invalid key!") end
if tostring(entry.GameId) ~= tostring(game.PlaceId) then error("Game not supported!") end

-- Screen GUI setup
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "LoaderGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

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

-- Animation
local spinner={"|","/","-","\\"}
local colors={
    Color3.fromRGB(255,0,0),
    Color3.fromRGB(255,128,0),
    Color3.fromRGB(255,255,0),
    Color3.fromRGB(0,255,0),
    Color3.fromRGB(0,255,255),
    Color3.fromRGB(0,0,255),
    Color3.fromRGB(128,0,255),
    Color3.fromRGB(255,0,255)
}

local totalSteps = 30
for i = 1, totalSteps do
    local progress = i/totalSteps
    local filled = math.floor(progress*20)
    local bar = string.rep("█", filled)..string.rep("░", 20-filled)
    local spin = spinner[i % #spinner + 1]
    local dots = string.rep(".", (i%3)+1)
    local color = colors[i % #colors + 1]
    label.Text = "Loading ["..bar.."] "..spin..dots
    label.TextColor3 = color
    wait(0.12)
end

-- Remove GUI after animation
gui:Destroy()

-- Fetch and run loader script
local success, err = pcall(function()
    local code = game:HttpGet(entry.loader)
    local func, err2 = loadstring(code)
    if func then func() else error(err2) end
end)
if not success then warn("Error loading script:", err) end
