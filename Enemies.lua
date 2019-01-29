local anim8 = require 'anim8'
enemies_controller = {}
enemies_controller.__index = enemies_controller
enemies_controller.enemies = {}
enemies_controller.animations = {}

function enemies_controller:spawn(kind, sprite, animation)
   enemy = {}
   enemy.x = math.random(1100, 1150)
   enemy.y = math.random(300, 610)
   enemy.width = 115
   enemy.height = 115
   randomize = randomize_enemy()
   enemy.cooldown = 60
   enemy.kind = randomize.npg
   enemy.animation = randomize.enemyanimation
   enemy.sprite = randomize.enemySprite
   table.insert(enemies_controller.enemies, enemy)
end

function enemy_fire(x,y, enem)
   if enem.kind == "Mage" then
      if enem.cooldown <= 0 then
	 enem.cooldown = 60
	 shot = {}
	 shot.flag = enem.kind
	 shot.x = x + 55
	 shot.y = y + 50
	 shot.xdir = 180
	 shot.ydir = 0
	 shot.width = 10
	 shot.height = 10
	 shot.color = {0,255,255}
	 table.insert(bullets, shot)
      end

   elseif enem.kind == "Knight" then
      if enem.cooldown <= 0 then
	 enem.cooldown = 60
	 shot = {}
	 shot.flag = enem.kind
	 shot.x = x 
	 shot.y = y 
	 shot.xdir = 0
	 shot.ydir = 0
	 shot.width = 0
	 shot.height = 0
	 shot.color = {0,0,0}
--	 table.insert(bullets, shot)
      end

      
   elseif enem.kind == "Hunter" then
      local ys = {0, 90, -90}
      if enem.cooldown <= 0 and enem.x - player.x <= 350 then
	 for _,j in pairs(ys) do
	    enem.cooldown = 100
	    shot = {}
	    shot.flag = enem.kind
	    shot.x = x + 55
	    shot.y = y + 50
	    shot.xdir = 130
	    shot.ydir = j
	    shot.width = 13
	    shot.height = 13
	    shot.color = {200,0,0}
	    bullets[#bullets + 1] = shot
	 end
      end
   end
end

function enemies_controller:randomization(dt)
   if #enemies_controller.enemies > 0 then
      rando = love.math.random(#enemies_controller.enemies)
      if love.math.random(0,15) == 1 then
	 enemy_fire(enemies_controller.enemies[rando].x,enemies_controller.enemies[rando].y,enemies_controller.enemies[rando])
      end
   end
end

function enemies_controller:shoot(dt, _player)
   for _,v in pairs(enemies_controller.enemies) do
      if math.random(0,15) == 1 then
	 if v.y + (v.height / 2) >= _player.y and v.y + (v.height / 2) <= _player.y + _player.height then
	    enemy_fire(v.x,v.y,v)
	 end
      end
   end
end

function enemies_controller:movement(dt)
   for _,v in ipairs(enemies_controller.enemies) do
      if v.kind == "Knight" then
	 v.x = v.x - 110 * dt
      else
	 v.x = v.x - 45 * dt
      end
      if love.math.random(0,4) == 2 then
	 if player.y > v.y then
	    v.y = v.y + 20 * dt
	 else
	    v.y = v.y - 20 * dt
	 end
      end
   end
end

function enemies_controller.animations:create(npg, enemySprite, wdth, hght, frames)
   anim = {}
   anim.npg = npg
   anim.enemySprite = love.graphics.newImage(enemySprite)
   anim.g = anim8.newGrid(wdth, hght, anim.enemySprite:getWidth(),
			  anim.enemySprite:getHeight())
   
   anim.enemyanimation = anim8.newAnimation(anim.g(frames,1), 0.1)
   return anim
end

function randomize_enemy(dt)

   animation = {}
   
   if score > 20  and score < 60 then
      if love.math.random(0,2) == 1 then
	 animation = enemies_controller.animations:create("Hunter", "/graphics/hunterwalking.png", 90,115,"1-6")
      else
	 animation = enemies_controller.animations:create("Mage", "/graphics/walkingenemy.png", 120,135,"1-6")
      end
      
   elseif score >= 60 then
      random_number = love.math.random(0,2)
      
      if random_number == 2 then
	 animation = enemies_controller.animations:create("Hunter", "/graphics/hunterwalking.png", 90,115,"1-6")
	 
      elseif random_number == 1 then
	 animation = enemies_controller.animations:create("Knight", "/graphics/knight.png", 115,115,"1-6")

      else
	 animation = enemies_controller.animations:create("Mage", "/graphics/walkingenemy.png", 120,135,"1-6")
      end
      
   else
      animation = enemies_controller.animations:create("Mage", "/graphics/walkingenemy.png", 120,135,"1-6")
   end
   return animation
end

