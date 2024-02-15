
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
    seg.limit = Vec2.create(seg.start.x + seg.width,func(seg.start.x + seg.width))
    seg.points = {}
    
    print("Start: " .. seg.start.x .. ", " .. seg.start.y)
    print("Limit: " .. seg.limit.x .. ", " .. seg.limit.y)

    local iter = 0

    table.insert(seg.points,Vec2.copy(seg.start))

    while(iter < seg.width) do
        table.insert(seg.points,Vec2.create(seg.start.x + iter,func(seg.start.x + iter)));
        iter = iter + RESOLUTION
    end

    table.insert(seg.points,Vec2.copy(seg.limit))

    function seg:draw()
        for i=1,#self.points-1 do
            love.graphics.line(self.points[i].x,self.points[i].y,self.points[i+1].x,self.points[i+1].y)
        end
    end

    return seg
end

return Segment