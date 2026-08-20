local width = 11
local depth = 11
local area = (depth * width)
-- width and depth values only used to compute duty cycle sleep time

function home()
    print('Homing...')
    while true do
        if isHome() then 
            return
        else
            turtle.turnRight()
            plow()
        end
    end
end


function isHome()
    local ok, data = turtle.inspect()
    if ok then
        return (data.name == 'create:item_vault')
    end
end


function hasFuel(amount)
    fuel = turtle.getFuelLevel()
    if amount == nil then amount = 1 end
    return fuel >= amount
end


function hook(direction)
    local directions = {right = turtle.turnRight, left = turtle.turnLeft}
    directions[direction]()
    plow(true)
    directions[direction]()
end


function refuel()
    if not hasFuel(1000) then
        turtle.select(16)
        turtle.dropUp()
        turtle.suck()
        item = turtle.getItemDetail()
        if item then
            if item.name == 'minecraft:dried_kelp_block' then
                turtle.refuel()
            end
        end
    end
    fuel = turtle.getFuelLevel()
    print('Fuel remaining: '..fuel)
end


function plow(once)
    turtle.select(1)
    local kelps = {'minecraft:kelp', 'minecraft:kelp_plant'}
    local farming = true
    while farming do
        if once then farming = false end
        local ok, data = turtle.inspect()
        if ok then
            if (data.name == kelps[1]) or (data.name == kelps[2]) then
                turtle.dig()
                turtle.suck()
                turtle.suckUp()
                turtle.suckDown()
                turtle.forward()
            elseif data.name == 'minecraft:water' then
                local moved, reason = turtle.forward()
                if not moved then error(reason) end
            else
                break
            end
        else
            error('Fish out of water')
        end
    end
end


function deposit()
    print('Delivering kelp...')
    for i=1,16,1 do
        turtle.select(i)
        turtle.drop()
    end
    turtle.select(1)
end


function main_loop()
    print('Harvesting crops...')
    turtle.turnRight()
    plow(true)
    turtle.turnLeft()
    refuel()
    turtle.turnRight()
    plow()
    turtle.turnRight()

    local direction = 1
    local directions = {'right', 'left'}
    while true do
        plow()
        if isHome() then
            deposit()
            -- sleep 5mins - 10second buffer - (1 second * area)
            local sleep_time = math.max(0, 290 - area)
            print('Waiting for growth...')
            sleep(sleep_time)
            return
        else
            hook(directions[direction])
            direction = (direction % 2) + 1
        end
    end
end


term.clear()
term.setCursorPos(1, 1)
print('Harvesting '..tostring(width)..' x '..tostring(depth)..' area')
home()
while true do
    main_loop()
end