local lib = require('library')

local tunnel_dist = 280
local filler = 1
local torch = 2

lib.digTunnel(tunnel_dist, torch, filler)
lib.flip()
lib.walk(tunnel_dist)
