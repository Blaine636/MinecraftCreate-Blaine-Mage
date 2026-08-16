local lib = require('library')
local args = {...}



for i=1,#args do
    if args[i] == 'walk' then
        lib.walk()
    elseif args[i] == 'right' then
        turtle.turnRight()
    elseif args[i] == 'left' then
        turtle.turnLeft()
    elseif args[i] == 'fuel' then
        print(turtle.getFuelLevel())
    end
end