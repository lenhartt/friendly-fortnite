
local Collider = {}

Collider.ObjType = { static = 0, dynamic = 1 }
Collider.objects = {}

Collider.addObj = function(obj,type)
	local col_obj = {}
	col_obj.data = obj
	col_obj.type = type
	table.insert(Collider.objects,col_obj)
end

function broad_phase(A,B)
	if A.type == Collider.ObjType.dynamic and B.type == Collider.ObjType.static then
		return not (A.data.x + A.data.radius*2 < B.data.points[1].x or A.data.x - A.data.radius*2 > B.data.points[#B.data.points].x)
	else
		print("STUB: NOT IMPLEMENTED YET!\n")
		return false
	end
end


-- Frisch von ChatGPT <- FUNKTIONIERT NICHT RICHTIG
function circleLineIntersect(cx, cy, r, x1, y1, x2, y2)
	-- Calculate the vector from the circle center to one of the line endpoints
    local dx = x2 - x1
    local dy = y2 - y1

    -- Calculate the vector from the circle center to the line start point
    local ex = cx - x1
    local ey = cy - y1

    -- Calculate the dot product of the two vectors
    local dotProduct = ex * dx + ey * dy

    -- Calculate the squared length of the line segment
    local lineLengthSquared = dx * dx + dy * dy

    -- Calculate the parameter along the line for the closest point
    local t = dotProduct / lineLengthSquared

    -- Check if the closest point is within the line segment
    if t < 0 then
        t = 0
    elseif t > 1 then
        t = 1
    end

    -- Calculate the coordinates of the closest point on the line
    local closestX = x1 + t * dx
    local closestY = y1 + t * dy

    -- Calculate the distance from the circle center to the closest point
    local distance = math.sqrt((cx - closestX)^2 + (cy - closestY)^2) - r

    if distance <= r then
        -- TODO: Calculate the collision normal
        -- Return the collision normal
        return true, {x = (cx - closestX) / distance, y = (cy - closestY) / distance}
    end

    return false, nil  -- No intersection
end

function narrow_phase(A,B)
	local manifest = {}
	if A.type == Collider.ObjType.dynamic and B.type == Collider.ObjType.static then
		for i=1,#B.data.points-1 do
			local inter, normal = circleLineIntersect(A.data.x,A.data.y,A.data.radius,B.data.points[i].x,B.data.points[i].y,B.data.points[i+1].x,B.data.points[i+1].y)
			if inter then
				local pair = {dyn = A, stat = { orig = B, seg = i }, normal = normal}
				table.insert(manifest,pair)
			end
		end
	else
		print("STUB: NOT IMPLEMENTED YET!\n")
		return nil
	end

	return manifest
end

Collider.process = function()
	local manifest = {}
	for i,A in ipairs(Collider.objects) do
		if A.type == Collider.ObjType.dynamic then
			for j,B in ipairs(Collider.objects) do
				if j ~= i then
					if broad_phase(A,B) then
						local tmp = narrow_phase(A,B)
						for i,col in ipairs(tmp) do
							table.insert(manifest,col)
						end
					end
				end
			end
		end
	end
	return manifest
end

return Collider