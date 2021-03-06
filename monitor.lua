config = require("config")

wifi.setmode(wifi.STATION)
wifi.sta.config(config.WIFI.SSID, config.WIFI.PASSWORD)
wifi.sta.connect()
tmr.alarm(1, 1000, tmr.ALARM_AUTO, function()
     if wifi.sta.getip() == nil then
         print("Connecting...")
     else
         tmr.stop(1)
         print("Connected, IP is " .. wifi.sta.getip())
         log()
     end
end)

function payload()
    moistureSignal = adc.read(0)
    ip = wifi.sta.getip()
    body = '{"authentifier": ' .. config.AUTHENTIFIER .. ', "id": ' .. config.ID .. ', "ip":"' .. ip .. '", "ms":' .. moistureSignal .. '}'
    return "POST " .. config.LOG_ENDPOINT .. " HTTP/1.1\r\n" ..
        "Host: " .. config.LOG_HOST .. "\r\n" ..
        "Content-Type: application/json\r\n" ..
        "Accept: */*\r\n" ..
        "Content-Length: " .. string.len(body) .. "\r\n\r\n" ..
        body .. "\r\n"
end

function log()
    print("Logging to " .. config.LOG_HOST .. config.LOG_ENDPOINT)
    conn = net.createConnection(net.TCP, 0)
    conn:on("receive", function(conn, payload)
                print(payload)
    end)
    conn:on("connection", function()
                conn:send(payload())
    end)
    conn:on("sent", function(conn)
                conn:close()
    end)
    conn:on("disconnection", function(conn, payload)
                node.dsleep(config.INTERVAL_MIN*60*1000000)
    end)
    conn:connect(80, config.LOG_HOST)
end
