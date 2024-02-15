
local Vec2 = {}

Vec2.create = function(x,y)
	local vec = {}
	vec.x = x
	vec.y = y
	
	function vec:add(other)
		return Vec2.create(self.x + other.x, self.y + other.y)
	end

	function vec:sub(other)
		return Vec2.create(self.x - other.x, self.y - other.y)
	end

	function vec:mul(other)
		return Vec2.create(self.x * other, self * other)
	end

	function vec:div(other)
		return Vec2.create(self.x / other, self / other)
	end

	return vec
end

Vec2.copy = function(v)
	local ret = Vec2.create(v.x,v.y)
	return ret
end

return Vec2