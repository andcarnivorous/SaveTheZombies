local anim8 = require 'anim8'

player= {}
bombs = 3
player.__index = player

function player:spawn(x,y)
   
   player.state = 'idle'
   
   player.Sprites = {
      idle = love.graphics.newImage('/graphics/normal.png'),
      walkingl = love.graphics.newImage('/graphics/walkingplayerl.png'),
      walkingr = love.graphics.newImage('/graphics/walkingplayer.png')
   }
   
   player.Sprite = player.Sprites['idle']

   player.Grids = {
      ['idle'] = anim8.newGrid(70, 90, player.Sprites['idle']:getWidth(), player.Sprites['idle']:getHeight()),
      ['walkingl'] = anim8.newGrid(70, 90, player.Sprites['walkingl']:getWidth(), player.Sprites['walkingl']:getHeight()),
      ['walkingr'] = anim8.newGrid(70, 90, player.Sprites['walkingr']:getWidth(), player.Sprites['walkingr']:getHeight())
   }

   player.animations = {
      
      ['idle'] = anim8.newAnimation(player.Grids['idle']('1-3',1), 0.1),
      ['walkingl'] = anim8.newAnimation(player.Grids['walkingl']('1-6',1), 0.1),
      ['walkingr'] = anim8.newAnimation(player.Grids['walkingr']('1-6',1), 0.1),

   }

   player.animation = player.animations['idle']

   player.x = x
   player.y = y
   player.spits = {}
   player.width = 70
   player.height = 90
   player.cooldown = 33
   player.speed = 100


   -- fa sparare il personaggio
   player.fire = function(_flag, _width, _height)
      if player.cooldown <= 0 then
	 player.cooldown = 33
	 spit = {}
	 spit.flag = _flag
	 spit.x = player.x + 55
	 spit.y = player.y + 50
	 spit.width = _width
	 spit.height = _height
	 table.insert(player.spits, spit)
      end
   end
   return player
end

function player:action(dt)
   if love.keyboard.isDown("up") then
      if player.y > 320 then
	 player.y = player.y - player.speed * dt
	 player.state = "walkingr"
      end
   end
   if love.keyboard.isDown("down") then
      if player.y < 610 then
	 player.y = player.y + player.speed * dt
	 player.state = "walkingr"
      end
   end
   
   if love.keyboard.isDown("right") then
      if player.x < 1000 then
	 player.x = player.x + player.speed * dt
	 player.state = "walkingr"
      end
   end
   
   if love.keyboard.isDown("left") then
      if player.x > 50 then
	 player.x = player.x - player.speed * dt
	 player.state = "walkingl"
      end
   end
   
   if love.keyboard.isDown("s") then
      player.fire("spit", 10,10)
   end
end
