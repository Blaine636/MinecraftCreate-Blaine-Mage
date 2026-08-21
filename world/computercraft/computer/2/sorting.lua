local lib = require('library')
local categories = require('item_categories')
local args = {...}
local last_powered_step = nil
local uncategorized_chest = #categories + 1


function home()
    print('returning to home...')
    local found_home = false

    --Move down until standing on ground
    lib.returnToFloor()

    --Move to 'chiseled stone bricks' home position
    while not found_home do
        local ok, data = turtle.inspectDown()

        -- Check position on redstone wire
        if data.name == 'minecraft:redstone_wire' then

            -- Go to next step if at the end of the redstone line
            if data.state.power == 0 then
                break

            -- Orient move direction towards zero
            elseif last_powered_step ~= nil then
                local difference = data.state.power - last_powered_step
                if difference > 0 then
                    lib.flip()
                elseif difference == 0 then
                    turtle.turnRight()
                end
            end

        -- If standing on home plate
        elseif data.name == 'minecraft:chiseled_stone_bricks' then

            -- Rotate counter-clockwise and find/face barrel
            repeat
                local _, block  = turtle.inspect()
                if block.name == 'minecraft:barrel' then
                    found_home = true
                else
                    turtle.turnLeft()
                end
            until found_home
        

        else
            error('Off the rails')
        end
        last_powered_step = data.state.power
        local clear = turtle.forward()
    end

    --check adjacent floor blocks (counter clockwise) until standing on chiseled stone bricks
    while not found_home do
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


function inventoryPresent()
    for slot=1,16 do
        turtle.select(slot)
        local has_item, data = turtle.getItemDetail()
        if has_item then return true end
    end
    return false
end


function mainLoop()
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
        elseif data.name == 'minecraft:chiseled_stone_bricks' then
            turtle.back()
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
    -- Check for items in sorting bot's inventory
    local items_to_sort = inventoryPresent()
    local i = 1
    turtle.select(i)

    -- Wait for items to be dropped off
    while not items_to_sort do
        print('Waiting for items...')
        sleep(10)
        items_to_sort = turtle.suck()
    end

    -- Pull available items
    i = (i+1)
    repeat
        turtle.select(i)
        local pulled_none = not turtle.suck()
        i = (i+1)
    until pulled_none or i > 16
end


function sortItems()
    -- Create table for columns and the item slots that need to be dropped off there
    local locations = {}

    -- Move to isle while facing chests
    turtle.back()

    -- Cycle through each slot in turtle's inventory
    for slot=1,16,1 do
        turtle.select(slot)
        local item_info = turtle.getItemDetail(slot, true)
        if item_info ~= nil then

            -- Get storage location, then add slot to storage column's table
            local index = categories.getStorageLocation(item_info.name)
            if index then
                if locations[index] then
                    table.insert(locations[index], slot)
                else
                    locations[index] = {slot}
                end
            end
        end
    end

    -- Go to each column and drop off all slots that belong there
    for column=1, #locations do
        moveTo(column)
        for _, slot in ipairs(locations[column]) do
            turtle.select(slot)
            placeItem()
        end
    end

    -- Dump remaing items into the uncategorized chest column
    if inventoryPresent() then
        moveTo(uncategorized_chest)
        for i=1,16,1 do
            turtle.select(i)
            local item_info = turtle.getItemDetail(i, true)
            if item_info ~= nil then
                placeItem()
            end
        end
    end
end


function refuelAndStatus()
    local fuel_sources = 
    {'minecraft:lava_bucket',
    'minecraft:coal_block',
    'minecraft:dried_kelp_block',
    'minecraft:coal',
    'minecraft:charcoal'}

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
        mainLoop()
    end
end
