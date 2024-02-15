
local Vec2 = require("vec2")
local Segment = require("line_segment")
local camera = require("camera")

local seg_list = {}

function love.load()
	love.graphics.setBackgroundColor(0,0,0,1)
	local seg = {};
	seg.limit = Vec2.create(0,0)

	for i=1,100 do
		seg = Segment.create(seg.limit,100)
		table.insert(seg_list,seg)
	end
	

	camera.move(-400,-300)
end

function love.mousemoved( x, y, dx, dy, istouch )
	if love.mouse.isDown(1) then
		camera.move(-dx * camera.scaleX,-dy * camera.scaleY)
	end
end

function love.wheelmoved(x, y)
	local sx,sy = love.graphics.getDimensions()
    camera.scale(-y / 100,-y / 100)
end

function love.update(dt)

end

function love.draw()
	camera.set()


	love.graphics.setColor(0.5,0.5,0.5,1)
	love.graphics.line(-1000,0,1000,0)
	love.graphics.line(0,-1000,0,1000)

	love.graphics.setColor(1,1,1,1)

	for i,seg in ipairs(seg_list) do
		if (seg.limit.x > camera.x and seg.start.x < camera.x + love.graphics.getWidth()) then
			seg:draw()
		end
	end

	camera.unset()
end
