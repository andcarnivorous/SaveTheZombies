local anim8 = require 'anim8'
require 'Player'
require 'Enemies'
require 'Bullets'
require 'Checkcoll'

font = love.graphics.newImageFont("/graphics/Imagefont.png",
				  " abcdefghijklmnopqrstuvwxyz" ..
				     "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
				     "123456789.,!?-+/():;%&`'*#=[]\"")

love.graphics.setFont(font)

score = 1

life = 1

hitpoints = {}

gameoverFlag = false

---
function love.load()

   math.randomseed(os.time())
   
   gameplay = true   
   
   bullets = {}
   
   player:spawn(100,400)
      
   love.graphics.setBackgroundColor(255,255,255)
   background = love.graphics.newImage("/graphics/FlatNight2BG.png")

   -- First enemies spawn
   for i=1,3 do
      enemies_controller:spawn()
   end
end
---


---

function love.update(dt)

   if #enemies_controller.enemies < 1 then
      for i=1,3 do
	 enemies_controller:spawn()--math.random(700, 1000),math.random(100, 600))
      end
   end
   
   function love.keypressed(key, unicode)
      
      if key == "d" then
	 if bombs  > 0 and player.cooldown <= 0 then
	    bombs = bombs - 1
	    player.fire("bomb", 50,50)
	 end
      elseif key == "p" then
	 gameplay = not gameplay
      end
   end
   
   if gameplay == false then
      if love.keyboard.isDown("r") then
	 love.event.quit("restart")
      elseif love.keyboard.isDown("q") then
	 love.event.quit()
      end
   end
   
   if life <= 0 then
      if love.keyboard.isDown("r") then
	 love.event.quit("restart")
      elseif love.keyboard.isDown("q") then
	 love.event.quit()
      end
   end

   
   if gameplay == true and life > 0 then
      
      player.state = 'idle'

      -- SWITCH TO THIS TO CHANGE ENEMY SHOOTING MODE
--      enemies_controller:shoot(dt, player)
      enemies_controller:randomization(dt)

      for i,v in pairs(enemies_controller.enemies) do
	 v.animation:update(dt)

	 if v.cooldown > -20 then
	    v.cooldown = v.cooldown - 1
	 end

	 if v.x >= 8 and v.x <= 10 then
	    life = life - 10
	    table.remove(enemies_controller.enemies, i)
	 end
      end
	 
      if player.cooldown > -10 then
	 player.cooldown = player.cooldown - 1
      end
      
      
      for i,v in pairs(player.spits) do
	 if v.x > player.x + 700 then
	    table.remove(player.spits, i)
	 end
	 v.x = v.x +260*dt
      end
      
      for i,v in pairs(bullets) do
	 if v.x < v.x - 700 then
	    table.remove(bullets.shots, i)
	 end
	 v.x = v.x - v.xdir * dt
	 v.y = v.y - v.ydir * dt
      end
      
      enemies_controller:movement(dt)
      
      player:action(dt)
      
      checkcoll(enemies_controller.enemies, player.spits, player, bullets)
      
      player.animation = player.animations[player.state]
      player.Sprite = player.Sprites[player.state]
      player.animation:update(dt)
      vomit.anim:update(dt)
      blueballs.anim:update(dt)
      blood.anim:update(dt)
      Bonuses:random_spawn(dt)
   end
   
   if life < 1 then   
      gameover()
   end
end


function love.draw()

   
   for i = 0, love.graphics.getWidth() / background:getWidth() do
      for j = 0, love.graphics.getHeight() / background:getHeight() do
	 love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
      end
   end

   for i,v in ipairs(player.spits) do

      
      if v.flag == "spit" then
	 love.graphics.setColor(205,205,0)
	 love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
	 love.graphics.setColor(255,255,255)
      elseif v.flag == "bomb" then
      	 love.graphics.setColor(205,205,0)
	 vomit.anim:draw(vomit.Sprite, v.x, v.y)
	 love.graphics.setColor(255,255,255)
      end
   end

   for _,v in pairs(bullets) do
      if v.flag == "Hunter" then
	 love.graphics.setColor(255,255,255)
	 love.graphics.draw(shotgun.Sprite, v.x, v.y)
	 love.graphics.setColor(255,255,255)


      elseif v.flag == "Mage" then
	 love.graphics.setColor(255,255,255)
	 blueballs.anim:draw(blueballs.Sprite, v.x, v.y)
	 love.graphics.setColor(255,255,255)

      else
	 love.graphics.setColor(v.color[1],v.color[2],v.color[3])
	 love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
	 love.graphics.setColor(255,255,255)
      end
   end

   for _,e in pairs(enemies_controller.enemies) do
      e.animation:draw(e.sprite, e.x, e.y)
   end

   for _,b in pairs(Bonuses.bonuses) do
      b.anim:draw(b.Sprite, b.x,b.y)
   end
   
   love.graphics.setColor(255,255,255)
   
   player.animation:draw(player.Sprite, player.x, player.y)

   for i,v in pairs(hitpoints) do
      --      for x,y in pairs(v) do
      love.graphics.setColor(255,255,255)
      blood.anim:draw(blood.Sprite, player.x+30,player.y+math.random(10,50),2,2)
      table.remove(hitpoints, _)
   end
   
   love.graphics.setColor(255,250,0)
   love.graphics.print("Score = " .. score, 50, 30, 0, 2, 2)
   love.graphics.setColor(255,0,0)
   love.graphics.print("Life = " .. life, 250, 30, 0, 2, 2)
   love.graphics.setColor(255,255,255)
   love.graphics.setColor(0,255,0)
   love.graphics.print("Bombs = " .. bombs, 428, 30, 0, 2, 2)
   love.graphics.setColor(255,255,255)
   
   if gameplay == false then
      love.graphics.print("Game Paused", 300, 300, 0, 6, 6)
      love.graphics.print("[r]estart  [q]uit", 375, 400, 0, 3, 3)
   end

   if life < 1 then
      
      drawdeath()
      
   end
end

function drawdeath()
   
      love.graphics.setColor(255,0,0)
      love.graphics.print("You died... Again!", 200, 300, 0, 5, 5)
      love.graphics.print("[r]estart  [q]uit", 325, 400, 0, 3.5, 3.5)
      
      love.graphics.setColor(255,255,255)
      love.graphics.print("Score = " .. score, 125, 500, 0, 3.5, 3.5)
      love.graphics.setColor(255,250,0)
      love.graphics.print("Record = " .. record_score, 700, 500, 0, 3.5, 3.5)
      love.graphics.setColor(255,0,0)

end

function gameover()

   if gameoverFlag == false then
      
      file = io.open ("score", "a")
      
      file:write(score, "\n")
      
      file:close()
      
      file = io.open("score", "r")
      
      lines = {}
      
      for line in file:lines() do
	 table.insert(lines, line)
      end
      
      table.sort(lines)
      
      record_score = math.max(unpack(lines))
      file:close()	 
      gameoverFlag = true
   end
end
