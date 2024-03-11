function tprint (tbl, indent)
  if not indent then indent = 0 end
  local toprint = string.rep(" ", indent) .. "{\r\n"
  indent = indent + 2 
  for k, v in pairs(tbl) do
    toprint = toprint .. string.rep(" ", indent)
    if (type(k) == "number") then
      toprint = toprint .. "[" .. k .. "] = "
    elseif (type(k) == "string") then
      toprint = toprint  .. k ..  "= "   
    end
    if (type(v) == "number") then
      toprint = toprint .. v .. ",\r\n"
    elseif (type(v) == "string") then
      toprint = toprint .. "\"" .. v .. "\",\r\n"
    elseif (type(v) == "table") then
      toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
    else
      toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
    end
  end
  toprint = toprint .. string.rep(" ", indent-2) .. "}"
  return toprint
end


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

function getSide(l1x,l1y, l2x,l2y, cx,cy)
  return ((l2x - l1x)*(cy - l1y) - (l2y - l1y)*(cx - l1x) ) > 0;
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
    	local pendepth = r - distance 
    	local normal = {x = 0, y = 0}
        -- TODO: Calculate the collision normal
        -- Return the collision normal
        if not getSide(x1,y1,x2,y2,cx,cy) then
        	pendepth = pendepth
        else
        	pendepth = -pendepth
        end

        normal.x = (cx - closestX)
        normal.y = (cy - closestY)

        local len = math.sqrt(normal.x*normal.x + normal.y*normal.y)

        normal.x = normal.x / len
        normal.y = normal.y / len
        
        return true, normal, pendepth
    end

    return false, nil, 0  -- No intersection
end

function narrow_phase(A,B)
	local manifest = {}
	if A.type == Collider.ObjType.dynamic and B.type == Collider.ObjType.static then
		for i=1,#B.data.points-1 do
			local inter, normal, depth = circleLineIntersect(A.data.x,A.data.y,A.data.radius,B.data.points[i].x,B.data.points[i].y,B.data.points[i+1].x,B.data.points[i+1].y)
			if inter then
				local pair = {A = A, B = { orig = B, seg = i }, normal = normal, pendepth =  depth}
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

Collider.resolve = function(manifest)
	local force = {x = 0, y = 0}
	local correction = {x = 0, y = 0}
	for i,col in ipairs(manifest) do
		--print(i .. ": normal = x: " .. col.normal.x .. "; y: " .. col.normal.y .. "; depth: " .. col.pendepth)

		if col.A.type == Collider.ObjType.dynamic and col.B.orig ~= nil and col.B.orig.type == Collider.ObjType.static then
			local damp = 0.6
			local slop = 1


	    force.x = force.x + col.normal.x * damp * col.pendepth
	    force.y = force.y + col.normal.y * damp * col.pendepth
		else
			print("STUB! NOT IMPLEMENTED")
		end
	end

	return force, correction
end

return Collider