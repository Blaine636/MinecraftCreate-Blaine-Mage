
while true do
    turtle.dig()
    turtle.forward()
    turtle.digUp()
    down = turtle.detectDown()
    if not down then
        turtle.placeDown()
    end
end
