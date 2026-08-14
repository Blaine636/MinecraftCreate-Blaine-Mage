local args = {...}
-- Clears an area, first walking
-- forward the length, then wrapping
-- to the right and repeating for width
length = tonumber(args[1])
width = tonumber(args[2])

function clearTunnel(length)
    --if length == nil then length = 0 end
    for i=1, length, 1 do
        turtle.dig()
        clear = turtle.detect()
        if not clear then turtle.dig() end
        turtle.forward()
        turtle.digUp()
        floor = turtle.detectDown()
        if not floor then
            turtle.placeDown()
        end
    end
end

function hookRight()
    turtle.turnRight()
    turtle.dig()
    clear = turtle.detect()
    if not clear then turtle.dig() end
    turtle.forward()
    turtle.digUp()
    turtle.turnRight()
end

function hookLeft()
    turtle.turnLeft()
    turtle.dig()
    clear = turtle.detect()
    if not clear then turtle.dig() end
    turtle.forward()
    turtle.digUp()
    turtle.turnLeft()
end

--if width == nil then width = 0 end
for i=1, width ,1 do
    clearTunnel(length)
    if i%2 == 0 then   
        hookLeft()
    else
        hookRight()
    end
end
