-- wheat_farm.lua
-- Turtle starts: one block above NE corner of farm, facing West.
-- Farm dimensions:
local FARM_SOUTH = 13  -- rows
local FARM_WEST  = 17  -- columns

local function estimateFuelNeeded()
    local farmBlocks = FARM_SOUTH * FARM_WEST
    local rowTransitions = FARM_SOUTH - 1
    local extraTravel = 40
    return farmBlocks + rowTransitions + extraTravel
end

local function ensureFuel()
    local needed = estimateFuelNeeded()
    local current = turtle.getFuelLevel()
    if current == "unlimited" then
        return true
    end

    if current >= needed then
        return true
    end

    for s = 1, 16 do
        if current >= needed then
            break
        end

        local det = turtle.getItemDetail(s)
        if not det then
            -- skip (Lua 5.1 safe)
        else
            local isFuel =
                det.name == "minecraft:coal" or
                det.name == "minecraft:charcoal" or
                det.name == "minecraft:oak_log" or
                det.name == "minecraft:spruce_log" or
                det.name == "minecraft:birch_log" or
                det.name == "minecraft:jungle_log" or
                det.name == "minecraft:acacia_log" or
                det.name == "minecraft:dark_oak_log" or
                det.name == "minecraft:mangrove_log" or
                det.name == "minecraft:cherry_log" or
                det.name == "minecraft:crimson_stem" or
                det.name == "minecraft:warped_stem" or
                det.name == "minecraft:lava_bucket" or
                det.name == "computercraft:refined_fuel" or
                det.name == "minecraft:dried_kelp_block"

            if isFuel then
                turtle.select(s)
                while current < needed and det.count > 0 do
                    turtle.refuel(1)
                    current = turtle.getFuelLevel()
                    det = turtle.getItemDetail(s)
                end
            end
        end
    end

    if current < needed then
        print("Not enough fuel. Needed:", needed, "Have:", current)
        return false
    end

    return true
end

local function forwardOrBreak()
    if not turtle.forward() then
        turtle.dig()
        turtle.forward()
    end
end

local function dropRight()
    turtle.turnRight()
    turtle.drop()
    turtle.turnLeft()
end

local function returnToStart()
    -- Turtle is at South-West corner, one block above crops, facing West.
    -- Goal: North-East corner, one block above crops, facing West.

    -- Turn right to face North
    turtle.turnRight()

    -- Move North FARM_SOUTH - 1 blocks
    for i = 1, FARM_SOUTH - 1 do
        forwardOrBreak()
    end

    -- Now at North-West corner, facing North. Turn right to face East.
    turtle.turnRight()

    -- Move East FARM_WEST - 1 blocks
    for i = 1, FARM_WEST - 1 do
        forwardOrBreak()
    end

    -- Now at North-East corner, facing East. Turn around to face West.
    turtle.turnLeft()
    turtle.turnLeft()
end

local function depositItems(wheatSlot, seedSlot)
    -- Turtle is at start: one block above NE corner, facing West.
    -- Seed chest: directly North of start (to the turtle's right).
    -- Wheat chest: 5 blocks West along the North side, same height.

    -- 1. Go to wheat chest column (5 blocks West)
    for i = 1, 5 do
        forwardOrBreak()
    end

    -- Deposit ALL wheat stacks to the right (North)
    for s = 1, 16 do
        local det = turtle.getItemDetail(s)
        if det and det.name == "minecraft:wheat" then
            turtle.select(s)
            while turtle.getItemDetail(s) do
                dropRight()
            end
        end
    end

    -- 2. Return to start position (5 blocks East)
    for i = 1, 5 do
        turtle.back()
    end

    -- Now back at start, still facing West; seed chest is to the right (North)
    -- Deposit ALL seed stacks to the right (North)
    for s = 1, 16 do
        local det = turtle.getItemDetail(s)
        if det and det.name == "minecraft:wheat_seeds" then
            turtle.select(s)
            while turtle.getItemDetail(s) do
                dropRight()
            end
        end
    end

    -- Turtle ends at start position, facing West
end

local function farmRow(length)
    for i = 1, length do
        local planted = false

        if turtle.detectDown() then
            local success, data = turtle.inspectDown()
            if success and data.name == "minecraft:wheat" then
                local age = 0
                if data.state and data.state.age then
                    age = data.state.age
                end

                if age >= 7 then
                    turtle.digDown()
                else
                    planted = true
                end
            end
        end

        if not planted and not (turtle.detectDown() and turtle.inspectDown()) then
            for s = 1, 16 do
                local det = turtle.getItemDetail(s)
                if det and det.name == "minecraft:wheat_seeds" then
                    turtle.select(s)
                    turtle.placeDown()
                    break
                end
            end
        end

        if i < length then
            forwardOrBreak()
        end
    end
end

local function main()
    turtle.select(1)

    if not ensureFuel() then
        print("Aborting: insufficient fuel.")
        return
    end

    for row = 1, FARM_SOUTH do
        farmRow(FARM_WEST)
        if row < FARM_SOUTH then
            if row % 2 == 1 then
                -- After odd rows (1,3,5...), turn left (South), move, turn left (West)
                turtle.turnLeft()
                forwardOrBreak()
                turtle.turnLeft()
            else
                -- After even rows (2,4,6...), turn right (North), move, turn right (West)
                turtle.turnRight()
                forwardOrBreak()
                turtle.turnRight()
            end
        end
    end

    -- Turtle is now at South-West corner, facing West
    returnToStart()
    -- Turtle is now at North-East start, facing West

    -- Find wheat and seeds slots (used only to check if anything to deposit)
    local wheatSlot, seedSlot = nil, nil
    for s = 1, 16 do
        local det = turtle.getItemDetail(s)
        if det then
            if det.name == "minecraft:wheat" and not wheatSlot then
                wheatSlot = s
            elseif det.name == "minecraft:wheat_seeds" and not seedSlot then
                seedSlot = s
            end
        end
    end

    if wheatSlot or seedSlot then
        depositItems(wheatSlot or 1, seedSlot or 1)
    end
end

main()