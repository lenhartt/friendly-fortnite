
local Vec2 = require("vec2")
local Segment = {}
local RESOLUTION = 0.1

local function func(x)
    -- Frequencies
    local f0, f1, f2, f3 = 1.75, 2.96, 6.23, 8.07

    -- Amplitudes
    local a0, a1, a2, a3 = -0.143, -0.180, -0.012, 0.088

    -- Offsets
    local o0, o1, o2, o3 = 1.73, 4.98, 3.17, 4.63

    -- Constant for horizontal stretch
    local k = 0.02

    -- Calculate the wave function
    local result = a0 * math.sin(f0 * (k * x + o0)) +
                   a1 * math.sin(f1 * (k * x + o1)) +
                   a2 * math.sin(f2 * (k * x + o2)) +
                   a3 * math.sin(f3 * (k * x + o3))

    return result * 50
end


Segment.create = function(v2start,width)
	local seg = {}
    
    seg.width = width
    seg.start = Vec2.copy(v2start)
    seg.limit = Vec2.create(seg.start.x + seg.width,0)

    print("Start: " .. seg.start.x .. ", " .. seg.start.y)
    print("Limit: " .. seg.limit.x .. ", " .. seg.limit.y)

    function seg:draw()
        local iter = 0
        local last = Vec2.copy(self.start)
        while(iter < self.width) do
            curr = Vec2.create(self.start.x + iter,self.start.y + func(last.x + iter))

            love.graphics.line(last.x,last.y,curr.x,curr.y)

            iter = iter + RESOLUTION
            last = curr
        end
    end

    return seg
end

return Segment