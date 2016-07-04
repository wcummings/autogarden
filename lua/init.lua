print("You have 60 seconds to deploy new code")
tmr.delay(60*1000000)

if file.open("monitor.lua", "r") then
    dofile("monitor.lua")
end
