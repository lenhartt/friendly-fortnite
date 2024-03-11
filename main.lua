
local Vec2 = require("vec2")
local Segment = require("line_segment")
local camera = require("camera")
local player = require("player")
local Collider = require("collider")
local seg_list = {}

function love.load()
	love.graphics.setBackgroundColor(0,0,0,1)
	local seg = {};
	seg.limit = Vec2.create(0,0)

	for i=1,2 do
		seg = Segment.create(seg.limit,400)
		table.insert(seg_list,seg)
		Collider.addObj(seg,Collider.ObjType.static)
	end

	Collider.addObj(player,Collider.ObjType.dynamic)
	
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

    x = x *100

	camera.move(-x * camera.scaleX,0)
end

function love.update(dt)
	player.controls()
	player.apply_force(0,10) --gravity
	player.update(dt)

	local smooth = 0.08

    camera.x = math.floor((camera.x - (camera.x - (player.x - love.graphics.getWidth() / 2 * camera.scaleX)) * smooth))
    camera.y = math.floor((camera.y - (camera.y - (player.y - love.graphics.getHeight() / 2 * camera.scaleY)) * smooth))

	local manifest = Collider.process()
	if #manifest ~= 0 then
		local force, correction = Collider.resolve(manifest)
		player.x = player.x + correction.x
		player.y = player.y + correction.y

		player.vel.x = player.vel.x + force.x
		player.vel.y = player.vel.y + force.y

	else
		-- no collisions were detected
	end 

end

function love.draw()
	camera.set()

	player.draw()
	love.graphics.setColor(0.5,0.5,0.5,1)
	love.graphics.line(-1000,0,1000,0)
	love.graphics.line(0,-1000,0,1000)

	love.graphics.setColor(1,1,1,1)

	local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()

    for i, seg in ipairs(seg_list) do
        if (seg.limit.x > camera.x - (seg.limit.x - seg.start.x) * camera.scaleX and
            seg.start.x < camera.x + screenWidth * camera.scaleX) then
            seg:draw()
        end
    end
	camera.unset()
end
