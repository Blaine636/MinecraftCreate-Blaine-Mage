local lib = require('library')
local categories = require('item_categories')
local args = {...}
local step_counter = 0

function moveForwardAndCount()
    local step = turtle.forward()
    if step then step_counter = (step_counter + 1) end
    return step
end


function home()
    print('returning to home...')

    --Move down until standing on ground
    repeat
        local floor = not turtle.down()
    until floor

    --Move to chiseled stone block anchor point
    while true do
        local ok, data = turtle.inspectDown()
        -- Check if standing on the chiseled stone block, then reset counter and exit loop
        if data.name == 'minecraft:chiseled_stone_bricks' then
            step_counter = 0
            break
        end
        local clear = moveForwardAndCount()
        if not clear then turtle.turnLeft() end
    end

    --check adjacent floor blocks (counter clockwise) until standing on smooth stone
    while true do
        turtle.turnLeft()
        local clear = turtle.forward()
        if clear then
            local ok, data = turtle.inspectDown()
            if data.name == 'minecraft:smooth_stone' then
                break
            else
                turtle.back()
            end
        end
    end

    --face unsorted chest
    turtle.turnRight()
    print('homing complete')
end


function main_loop()
    print('Sorting...')
    pull_items()
    sort_items()
end


function move(value)
    --
end


function pull_items()
    turtle.select(1)
    repeat
        local pulled_none = turtle.suck()
    until pulled_none
end


function sort_items()
    -- Move to face first category.
    turtle.turnRight()
    turtle.forward()
    turtle.turnRight()
    turtle.forward()
    turtle.turnRight()

    -- Temporary! Sort per slot
    for i=1,16,1 do
        turtle.select(i)
        local item_info = turtle.getItemDetail(i, true)
        for key, value in ipairs(categories) do
            print('key: '..key..' value: '..value)
            sleep(0.2)
            --local found = tableContains(key, )
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
