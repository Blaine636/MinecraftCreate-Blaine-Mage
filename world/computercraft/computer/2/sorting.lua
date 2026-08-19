local lib = require('library')
local categories = require('item_categories')
local args = {...}
local last_powered_step = nil


function home()
    print('returning to home...')

    --Move down until standing on ground
    lib.returnToFloor()

    --Move to chiseled stone block anchor point
    while true do
        local ok, data = turtle.inspectDown()

        -- Check position on redstone wire
        if data.name == 'minecraft:redstone_wire' then
            if data.state.power == 0 then
                break
            elseif last_powered_step ~= nil then
                local difference = data.state.power - last_powered_step
                if difference > 0 then
                    lib.flip()
                elseif difference == 0 then
                    turtle.turnRight()
                end
            end
            last_powered_step = data.state.power
            local clear = turtle.forward()
        end
    end

    --check adjacent floor blocks (counter clockwise) until standing on chiseled stone bricks
    while true do
        turtle.turnLeft()
        local clear = turtle.forward()
        if clear then
            local ok, data = turtle.inspectDown()
            if data.name == 'minecraft:chiseled_stone_bricks' then
                break
            else
                turtle.back()
            end
        end
    end
    print('homing complete')
end


function main_loop()
    while true do
        print('Sorting...')
        pullItems()
        sortItems()
        home()
    end
end


function moveTo(value)
    local current_position
    local ok, data = turtle.inspectDown()
    if ok then
        if data.name == 'minecraft:redstone_wire' then
            current_position = data.state.power
        else
            current_position = 0
        end
    end
    local difference = value - current_position
    local direction
    if difference ~= 0 then
        if difference > 0 then
            direction = 'left'
        elseif difference < 0 then
            direction = 'right'
        end
        lib.directions[direction].turn()
        for i=1,math.abs(difference),1 do
            turtle.forward()
        end
        lib.directions[opposites[direction]].turn()
    end
end


function placeItem()
    local success = turtle.drop()
    while not success do
        turtle.up()
        local ok, data = turtle.inspect()
        if ok then
            if data.name == 'minecraft:chest' then
                success = turtle.drop()
            else
                break
            end
        else
            break
        end
    end
    lib.returnToFloor()
end


function pullItems()
    local i = 1
    turtle.select(i)
    repeat
        local pulled_something = turtle.suck()
        if not pulled_something then
            print('Waiting for items...')
            sleep(10)
        end
    until pulled_something
    i = (i+1)
    repeat
        turtle.select(i)
        local pulled_none = not turtle.suck()
        i = (i+1)
    until pulled_none or i > 16
end


function sortItems()
    -- Move to face first category.
    turtle.turnRight()
    turtle.forward()
    lib.flip()

    -- Temporary! Sort per slot
    for i=1,16,1 do
        turtle.select(i)
        local item_info = turtle.getItemDetail(i, true)
        if item_info ~= nil then
            for key, value in ipairs(categories) do
                local found = tableContains(value, item_info.name)
                if found then
                    moveTo(key)
                    placeItem()
                    break
                end
            end
        end
    end

    moveTo(12)
    for i=1,16,1 do
        turtle.select(i)
        local item_info = turtle.getItemDetail(i, true)
        if item_info ~= nil then
            placeItem()
        end
    end
end





function refuelAndStatus()
    local fuel_sources = {
        'minecraft:lava_bucket',
        'minecraft:coal_block',
        'minecraft:dried_kelp_block',
        'minecraft:coal',
        'minecraft:charcoal'
    }

    -- Refuel if slot 1 contains an approved fuel source, and print fuel remaining.
    local refuel = false
    local item_info = turtle.getItemDetail(1, true)
    if item_info then
        if lib.tableContains(fuel_sources, item_info.name) then
            print('Refueling...')
            turtle.select(1)
            turtle.refuel()
        end
    end
    print('Fuel remaining: '..turtle.getFuelLevel())
end


for i=1,#args do
    if args[i] == 'start' then
        print('starting...')
        refuelAndStatus()
        home()
        main_loop()
    -- elseif args[i] == 'home' then
    --     home()
    -- elseif args[i] == 'forward' then
    --     turtle.forward()
    -- elseif args[i] == 'right' then
    --     turtle.turnRight()
    -- elseif args[i] == 'left' then
    --     turtle.turnLeft()
    -- elseif args[i] == 'up' then
    --     turtle.up()
    -- elseif args[i] == 'down' then
    --     turtle.down()
    -- elseif args[i] == 'fuel' then
    --     print(turtle.getFuelLevel())
    -- elseif args[i] == 'refuel' then
    --     turtle.refuel()
    end
end
