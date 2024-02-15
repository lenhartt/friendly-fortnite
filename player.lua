local player = {}

<<<<<<< HEAD
player.x = 20
player.y = -10
player.radius = 5

player.speed = { x = 10, y = 10 }
player.vel = { x = 10, y = 0}

function player.draw()
    --player.x, player.y = love.graphics.getWidth()/2, love.graphics.getHeight()/2
    love.graphics.circle("fill", player.x, player.y, player.radius * 2)
end

function player.update(dt)
    player.x = player.x + player.vel.x * dt
    player.y = player.y + player.vel.y * dt

    player.vel.x = player.vel.x * math.pow(0.002,dt)
    player.vel.y = player.vel.y * math.pow(0.002,dt)
end

function player.apply_force(x,y)
    player.vel.x = player.vel.x +x
    player.vel.y = player.vel.y +y
end

function player.controls()
    local force = {x = 0, y = 0}
    force.y = force.y - (love.keyboard.isDown("w") and player.speed.y or 0)
    force.y = force.y + (love.keyboard.isDown("s") and player.speed.y or 0)
    force.x = force.x - (love.keyboard.isDown("a") and player.speed.x or 0)
    force.x = force.x + (love.keyboard.isDown("d") and player.speed.x or 0)

    player.apply_force(force.x,force.y)
=======
function player.physics()
    local grav = 5
    local vel = 3

end


function player.draw()
    player.x, player.y = 10, -10
    player.radius = 5
    
    love.graphics.circle("fill", player.x, player.y, player.radius)
>>>>>>> f30561890b7d6959616055ddc1b714128567db01
end

return player