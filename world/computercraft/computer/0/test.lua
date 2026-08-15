local lib = require('library')

--lib.buildBasicBridge(1,2,3)

function buildStairsDown()
    for i=1,20,1 do
        turtle.forward()
        turtle.down()
        turtle.turnLeft()
        turtle.place()
        lib.flip()
        turtle.place()
        turtle.turnLeft()
        turtle.placeDown()
    end
end

buildStairsDown()
--turtle.select(2)
--buildStairsDown()


--local tunnel_dist = 140
--local filler = 1
--local torch = 2

--lib.digTunnel(tunnel_dist, torch, filler)
--lib.flip()
--lib.walk(tunnel_dist)
