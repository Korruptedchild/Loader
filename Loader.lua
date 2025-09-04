local Keys={
{Key="Tractor",GameId=95712269457211,loader="http://paid2.daki.cc:4016/BuildATractor.lua"}
}

if not your_key then error("No key provided!") end
local entry
for _,v in ipairs(Keys) do if v.Key==your_key then entry=v break end end
if not entry then error("Invalid key!") end
if entry.GameId ~= game.PlaceId then error("Game not supported!") end

local spinner={"|","/","-","\\"}
local colors={BrickColor.new("Bright red"),BrickColor.new("Bright yellow"),BrickColor.new("Bright green"),BrickColor.new("Bright blue")}

for i=1,20 do
    local bar=string.rep("█",i)..string.rep("░",20-i)
    local dots=string.rep(".",i%4)
    local spin=spinner[i%#spinner+1]
    local color=colors[i%#colors+1]
    print(color.Name.." Loading ["..bar.."] "..dots.." "..spin)
    wait(0.15)
end

local success,err=pcall(function()
    local code=game:HttpGet(entry.loader)
    local func,err2=loadstring(code)
    if func then func() else error(err2) end
end)
if not success then warn("Error loading script:",err) end
