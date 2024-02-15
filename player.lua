local player = {}

function player.physics()
    local grav = 5
    
end


function player.draw()
    --player.x, player.y = love.graphics.getWidth()/2, love.graphics.getHeight()/2
    love.graphics.circle("fill", 0, -10, 5)
end

return player