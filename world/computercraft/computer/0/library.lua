function haveEnough(item_name, required_amount, slot)
	local old_cursor_slot = turtle.getSelectedSlot()
	turtle.select(slot)
	local item_info = turtle.getItemDetail()
	if item_info.name ~= item_name then error('Item in slot doesn\'t match given item name!') end
	local enough = turtle.getItemCount() >= required_amount
	turtle.select(old_cursor_slot)
	return enough
end


function walk(distance) -- moves forward until obstructed or completes distance, then returns remainder of steps. A distance of 0 walks until obstructed.
	local count = 0
	unobstructed = not turtle.detect()
	while unobstructed do
		turtle.forward()
		count = count + 1
		unobstructed = not turtle.detect()
		if count == distance then
			return math.max(0, distance - count)
		end
	end
end


function hook(direction) -- moves to the corresponding adjacent space and faces the opposite direction you started
	if direction == 'right' then
		turtle.turnRight()
		turtle.dig()
		turtle.forward()
		turtle.turnRight()
	elseif direction == 'left' then
		turtle.turnLeft()
		turtle.dig()
		turtle.forward()
		turtle.turnLeft()
	else
		error('hook() recieved unknown direction argument')
	end
end


function flip()
	turtle.turnRight()
	turtle.turnRight()
end


function removeNonBlocks(direction) -- digs blocks that are not shovel-able or pickaxe-able, meant to clear grass, flowers, leaves, etc
    local directions = {
        forward = {inspect = turtle.inspect, dig = turtle.dig},
        down = {inspect = turtle.inspectDown, dig = turtle.digDown},
        up = {inspect = turtle.inspectUp, dig = turtle.digUp}
    }
    local choice = directions[direction]
    local has_block, data = choice.inspect()
    if has_block then
        if not data.tags['minecraft:mineable/shovel'] and not data.tags['minecraft:mineable/pickaxe'] then
            choice.dig()
        end
    end
end


function returnToFloor(break_non_blocks) -- Moves down until hitting a block, optional remove non earth blocks
	local floor = false
    while not floor do
    	turtle.down()
    	if break_non_blocks then removeNonBlocks('down') end
    	floor = turtle.detectDown()
    end
end


function digUntilClear(direction) -- Continue digging until space in chosen direction is empty. Meant to ensure space is empty in case of sand/gravel.
	if direction == nil then direction = 'forward' end
	local directions = {
        forward = {detect = turtle.detect, dig = turtle.dig},
        down = {detect = turtle.detectDown, dig = turtle.digDown},
        up = {detect = turtle.detectUp, dig = turtle.digUp}
    }
    local choice = directions[direction]
	local obstruction = choice.detect()
	while obstruction do
		choice.dig()
		obstruction = choice.detect()
	end
end


function placeTunnelTorch(torch_slot, fill_floor_slot, direction) -- Places torches at head level recessed into the wall. Compliant with blaine's "point towards exit" standard.
	if direction == nil then direction = 'left' end
	local turn = {
		left = turtle.turnLeft,
		right = turtle.turnRight
	}
	turtle.up()
	turn[direction]()
	digUntilClear()
	turtle.forward()
	turn[direction]()
	digUntilClear()
	turtle.forward()
	local surface = turtle.detect()
	if not surface and fill_floor_slot then
		turtle.select(fill_floor_slot)
		turtle.place()
	end
	turtle.back()
	turtle.select(torch_slot)
	turtle.place()
	turn[direction]()
	turtle.forward()
	turn[direction]()
	turtle.down()
end


function digTunnel(distance, torch_slot, fill_floor_slot) -- Digs a tunnel(2 high x 1 wide) a fixed distance accounting for sand/gravel falls, and places torches along the path.
	if fill_floor_slot == nil then fill_floor_slot = 0 end
	local counter = 0
	while counter < distance do
		turtle.dig()
		if turtle.forward() then counter = (counter + 1) end
		local floor = turtle.detectDown()
		if not floor and fill_floor_slot > 0 then 
			turtle.select(fill_floor_slot)
			turtle.placeDown()
		end
		local above = true
		while above do
			turtle.digUp()
			above = turtle.detectUp()
		end
		if counter%10 == 0 then
			placeTunnelTorch(torch_slot, fill_floor_slot)
		end
	end
end


function buildBasicBridge(floor_slot, left_slot, right_slot)
	turtle.forward()
	local floor = false
	while not floor do
		turtle.turnRight()
		turtle.select(right_slot)
		turtle.place()
		flip()
		turtle.select(left_slot)
		turtle.place()
		turtle.turnRight()
		turtle.select(floor_slot)
		turtle.placeDown()
		turtle.dig()
		turtle.forward()
		floor = turtle.detectDown()
	end
end


return {haveEnough = haveEnough, walk = walk, hook = hook, flip = flip, removeNonBlocks = removeNonBlocks, returnToFloor = returnToFloor, digUntilClear = digUntilClear, digTunnel = digTunnel, buildBasicBridge = buildBasicBridge}