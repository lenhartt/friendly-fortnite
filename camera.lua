local Camera = {}

Camera.x = 0
Camera.y = 0
Camera.scaleX = 1
Camera.scaleY = 1
Camera.rotation = 0

function Camera.set()
  love.graphics.push()
  love.graphics.rotate(-Camera.rotation)
  love.graphics.scale(1 / Camera.scaleX, 1 / Camera.scaleY)
  love.graphics.translate(-Camera.x, -Camera.y)
end

function Camera.unset()
  love.graphics.pop()
end

function Camera.scale(sx,sy)
	Camera.scaleX = Camera.scaleX + sx
	Camera.scaleY = Camera.scaleY + sy

	if Camera.scaleX < 0.1 then
		Camera.scaleX = 0.1
	end

	if Camera.scaleY < 0.1 then
		Camera.scaleY = 0.1
	end
end

function Camera.move(dx, dy)
  Camera.x = Camera.x + (dx or 0)
  Camera.y = Camera.y + (dy or 0)
end

function Camera.rotate(dr)
  Camera.rotation = Camera.rotation + dr
end

return Camera
