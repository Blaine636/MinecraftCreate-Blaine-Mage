-- Configuration
local WAIT_TIME = 3.5  -- seconds between each step (change this once to adjust all delays)

-- Redstone sides (ComputerCraft constants)
local SIDE_LEFT = "left"
local SIDE_FRONT = "front"

-- Cycle definition: list of output levels in order
local cycleSteps = {5, 4, 2, 1, 0}

while true do
    -- Check redstone input from underneath the computer
    if rs.getInput(SIDE_FRONT) then
        -- Run the cycle
		print("Redstone input detected, running cycle")
        for _, level in ipairs(cycleSteps) do
			print("Set RS out level", level)
            rs.setAnalogOutput(SIDE_LEFT, level)
            sleep(WAIT_TIME)
        end
    else
        -- Optional: ensure output is off when input is off
        rs.setOutput(SIDE_LEFT, false)
    end

    -- Small sleep to avoid tight loop when input is off
    sleep(3.0)
end