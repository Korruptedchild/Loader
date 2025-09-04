-- Key system
local Keys = {
    {Key="Tractor", GameId=95712269457211, loader="http://paid2.daki.cc:4016/BuildATractor.lua"},
    {Key="Harvester", GameId=95712269457211, loader="http://paid2.daki.cc:4016/BuildAHarvester.lua"}
}

if not your_key then error("No key provided!") end
local entry
for _,v in ipairs(Keys) do if v.Key == your_key then entry = v break end end
if not entry then error("Invalid key!") end
if tostring(entry.GameId) ~= tostring(game.PlaceId) then error("Game not supported!") end

-- Exploit-safe GUI
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "LoaderGui"
gui.Parent = (gethui and gethui()) or player:WaitForChild("PlayerGui")
if syn and syn.protect_gui then syn.protect_gui(gui) end

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 550, 0, 50)
label.Position = UDim2.new(0.5, -275, 0.45, 0)
label.BackgroundTransparency = 0.5
label.BackgroundColor3 = Color3.fromRGB(0,0,0)
label.TextColor3 = Color3.fromRGB(255,255,255)
label.Font = Enum.Font.Code
label.TextSize = 24
label.Text = ""
label.Parent = gui

-- Animation variables
local spinner = {"|","/","-","\\"}
local colors = {}
for i = 0, 359, 15 do
    colors[#colors+1] = Color3.fromHSV(i/360, 1, 1)
end

local totalSteps = 200
local fetchedCode
local finished = false

-- Fetch loader in background
spawn(function()
    local success, err = pcall(function()
        if syn and syn.request then
            local response = syn.request({Url = entry.loader, Method = "GET"})
            fetchedCode = response.Body
        else
            fetchedCode = game:HttpGet(entry.loader)
        end
    end)
    finished = true
    if not success then
        label.TextColor3 = Color3.fromRGB(255,0,0)
        label.Text = "Error loading script!"
        fetchedCode = nil
    end
end)

-- Animation loop
local step = 0
while not finished do
    step = step + 1
    local progress = (math.sin(step/20)*0.5 + 0.5) -- smooth bounce 0-1
    local filled = math.floor(progress*30)
    local bar = string.rep("█", filled)..string.rep("░", 30-filled)
    local spin = spinner[step % #spinner + 1]
    local dots = string.rep(".", ((step//5)%4)+1)
    local color = colors[step % #colors + 1]
    label.Text = "Loading ["..bar.."] "..spin..dots
    label.TextColor3 = color
    task.wait(0.03)
end

-- Ensure bar fills completely
for i = 1,30 do
    local bar = string.rep("█", i)..string.rep("░", 30-i)
    label.Text = "Loading ["..bar.."] ✓"
    label.TextColor3 = Color3.fromRGB(0,255,0)
    task.wait(0.02)
end

-- Execute fetched loader
if fetchedCode then
    local success2, err2 = pcall(function()
        local func = loadstring(fetchedCode)
        if func then func() end
    end)
    if not success2 then
        label.TextColor3 = Color3.fromRGB(255,0,0)
        label.Text = "Error executing script!"
        task.wait(2)
    end
end

-- Cleanup
gui:Destroy()
