directions = {
	forward = { inspect = turtle.inspect,		dig = turtle.dig, 		detect = turtle.detect},
	back = { 	inspect = inspectBack,			dig = digBack, 			detect = detectBack,			turn = flip},
    down = {	inspect = turtle.inspectDown, 	dig = turtle.digDown, 	detect = turtle.detectDown},
    up = {		inspect = turtle.inspectUp, 	dig = turtle.digUp, 	detect = turtle.detectUp},
    right = {	inspect = inspectRight, 		dig = digRight, 		detect = detectRight, 			turn = turtle.turnRight},
    left = {	inspect = inspectLeft, 			dig = digLeft, 			detect = detectLeft, 			turn = turtle.turnLeft}
}


opposites = {
	left = 'right',
	right = 'left',
	up = 'down',
	down = 'up',
	forward = 'back',
	back = 'forward'
}


function tableContains(array, target)
	for index, value in ipairs(array) do
    	if value == target then
    		return index
    	end
	end
	return nil
end


function haveEnough(slot, required_amount, item_name)
	local old_cursor_slot = turtle.getSelectedSlot()
	turtle.select(slot)
	local item_info = turtle.getItemDetail()
	if item_name ~= nil then
		if item_info.name ~= item_name then error('Item in slot doesn\'t match given item name!') end
	end
	local enough = turtle.getItemCount() >= required_amount
	turtle.select(old_cursor_slot)
	return enough
end


function digLeft()
	turtle.turnLeft()
	local result = turtle.dig()
	turtle.turnRight()
	return result
end


function digRight()
	turtle.turnRight()
	local result = turtle.dig()
	turtle.turnLeft()
	return result
end


function digBack()
	flip()
	local result = turtle.dig()
	flip()
	return result
end


function inspectLeft()
	turtle.turnLeft()
	local result = turtle.inspect()
	turtle.turnRight()
	return result
end


function inspectRight()
	turtle.turnRight()
	local result = turtle.inspect()
	turtle.turnLeft()
	return result
end


function inspectBack()
	flip()
	local result = turtle.inspect()
	flip()
	return result
end


function detectLeft()
	turtle.turnLeft()
	local result = turtle.detect()
	turtle.turnRight()
	return result
end


function detectRight()
	turtle.turnRight()
	local result = turtle.detect()
	turtle.turnLeft()
	return result
end


function detectBack()
	flip()
	local result = turtle.detect()
	flip()
	return result
end


function walk(distance) -- moves forward until obstructed or completes distance, then returns remainder of steps. A distance of 0 walks until obstructed.
	local count = 0
	repeat
		if turtle.forward() then count = (count + 1) end
		local obstructed = turtle.detect()
		if count == distance then
			return math.max(0, distance - count)
		end
	until obstructed
end


function hook(direction) -- moves to the corresponding adjacent space and faces the opposite direction you started
	local choice = directions[direction]
	choice.turn()
	digUntilClear()
	assert(turtle.forward(), 'Didn\'t walk forward as expected.')
	digUntilClear('up')
	choice.turn()
end


function flip() -- Flips turtle 180°
	turtle.turnRight()
	turtle.turnRight()
end


function removeNonBlocks(direction) -- digs blocks that are not shovel-able or pickaxe-able, meant to clear grass, flowers, leaves, etc
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
    local choice = directions[direction]
    repeat
    	choice.dig()
    	local obstructed = choice.detect()
    	sleep(0.2)
    until not obstructed
end


function placeTunnelTorch(torch_slot, filler_slot, direction) -- Places torches at head level recessed into the wall. Compliant with blaine's "point towards exit" standard.
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
	if not surface and filler_slot then
		turtle.select(filler_slot)
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


function digTunnel(distance, torch_slot, filler_slot) -- Digs a tunnel(2 high x 1 wide) a fixed distance accounting for sand/gravel falls, and places torches along the path.
	if filler_slot == nil then filler_slot = 0 end
	local counter = 0
	while counter < distance do
		turtle.dig()
		if turtle.forward() then counter = (counter + 1) end
		local floor = turtle.detectDown()

		-- place floor if a filler slot was given
		if not floor and filler_slot > 0 then
			if not haveEnough(filler_slot, 1) then break end
			turtle.select(filler_slot)
			turtle.placeDown()
		end
		digUntilClear('up')
		if counter%10 == 0 then
			placeTunnelTorch(torch_slot, filler_slot)
		end
	end
end


function buildBasicBridge(floor_slot, left_slot, right_slot) -- Walks forward and places a brick to the left, down, and right until it detects a block below it, or runs out of any blocks.
	turtle.forward()
	local floor = false
	while not floor do
		turtle.turnRight()
		if not haveEnough(right_slot, 1) then break end
		turtle.select(right_slot)
		turtle.place()
		flip()
		if not haveEnough(left_slot, 1) then break end
		turtle.select(left_slot)
		turtle.place()
		turtle.turnRight()
		if not haveEnough(floor_slot, 1) then break end
		turtle.select(floor_slot)
		turtle.placeDown()
		turtle.dig()
		turtle.forward()
		floor = turtle.detectDown()
	end
end


function clearArea(depth, width, direction, torch_slot) -- Clears a 2 block high space of specified depth and width. places torches behind bot every 10sq blocks
	local counter_x = 0
	while counter_x < width do
		local counter_y = 0
		while counter_y < depth do
			digUntilClear('forward')
			if turtle.forward() then counter_y = (counter_y + 1) end
			if counter_x % 10 == 0 and counter_y % 10 == 0 then
				print('should have placed torch')
				flip()
				turtle.select(torch_slot)
				turtle.place()
				flip()
			end
			digUntilClear('up')
		end
		counter_x = (counter_x + 1)
		if counter_x % 2 == 0 then
			hook(opposites[direction])
		else
			hook(direction)
		end
	end
end


return {directions = directions, opposites = opposites, tableContains = tableContains, haveEnough = haveEnough, walk = walk, hook = hook, flip = flip, removeNonBlocks = removeNonBlocks, returnToFloor = returnToFloor, digUntilClear = digUntilClear, digTunnel = digTunnel, buildBasicBridge = buildBasicBridge, clearArea = clearArea}
