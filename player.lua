local player = {}

function player.physics()
    local grav = 5
    local vel = 3

end


function player.draw()
    player.x, player.y = 10, -10
    player.radius = 5
    
    love.graphics.circle("fill", player.x, player.y, player.radius)
end

return player