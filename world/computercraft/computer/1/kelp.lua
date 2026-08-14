local args = {...}
local width = 8
local depth = 6
local counter = 0
function breakKelp()
    local ok, block = turtle.inspect()
    if ok then
        if block.name == 'minecraft:kelp_plant' then
            turtle.dig()
        elseif block.name == 'minecraft:kelp' then
            turtle.dig()
        end
    end   
end


function clearRow()
    for i=1,depth,1 do
        breakKelp()
        turtle.suckUp()
        turtle.forward()
    end
end


function hookRight()
    turtle.turnRight()
    breakKelp()
    turtle.forward()
    turtle.turnRight()
end


function hookLeft()
    turtle.turnLeft()
    breakKelp()
    turtle.forward()
    turtle.turnLeft()
end


function awaitGrowth()
    sleep(240)
end


function clearArea()
    for i=1,width,1 do
        clearRow()
        if i%2 == 0 and i < width then
            hookLeft()
        elseif i%2 == 1 and i < width then
            hookRight()
        end
    end
end


function returnStart()
    turtle.turnRight()
    clearRow()
    clearRow()    
    turtle.turnLeft()
end


function refuel()
    fuel = turtle.getFuelLevel()
    if fuel < 1000 then
        turtle.select(16)
        turtle.suck()
        item = turtle.getItemDetail()
        if item then
            if item.name == 'minecraft:dried_kelp_block' then
                turtle.refuel()
            end
        end
    end
end


function deposit()
    for i=1,16,1 do
        turtle.select(i)
        item = turtle.getItemDetail()
        if item then 
            if item.name == 'minecraft:kelp' then
                turtle.drop()
            end
        end
    end
    turtle.select(1)
end


function run()
    while turtle.getFuelLevel() > 50 do
        clearArea()
        deposit()
        returnStart()
        refuel()
        turtle.turnRight()
        turtle.turnRight()
        awaitGrowth()
    end
end


for i=1,#args do
    if args[i] == 'home' then
        returnStart()
    elseif args[i] == 'run' then
        run()
    elseif args[i] == 'deposit' then
        deposit()
    elseif args[i] == 'refuel' then
        refuel()
    elseif args[i] == 'walk' then
        clearRow()
    elseif args[i] == 'right' then
        turtle.turnRight()
    elseif args[i] == 'left' then
        turtle.turnLeft()
    elseif args[i] == 'fuel' then
        print(turtle.getFuelLevel())
    end
end
