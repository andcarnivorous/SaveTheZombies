local anim8 = require 'anim8'


Particles = {}

Particles.__index = Particles

function Particles:create(png, wdth, hgth, frames)
   particle = {}
   setmetatable(particle, Particles)
   particle.Sprite = love.graphics.newImage(png)
   particle.grid = anim8.newGrid(wdth, hgth, particle.Sprite:getWidth(), particle.Sprite:getHeight())
   particle.anim = anim8.newAnimation(particle.grid(frames,1), 0.1)
   return particle
end

vomit = Particles:create("/graphics/vomitanim.png", 48, 48,'1-5')

blueballs = Particles:create("/graphics/blueballs.png", 16, 16, "1-4")

shotgun = Particles:create("/graphics/shotgun.png", 16, 16,"1-1")

blood = Particles:create("/graphics/blood.png",16,16, "1-5")


Bonuses = {}

function Bonuses:create(name, png, wdth, hgth, frames)
   bonus = {}
   setmetatable(bonus, Bonuses)

   bonus.name = name
   bonus.width = wdth
   bonus.height = hgth
   bonus.Sprite = love.graphics.newImage(png)
   bonus.grid = anim8.newGrid(wdth, hgth, bonus.Sprite:getWidth(), bonus.Sprite:getHeight())
   bonus.anim = anim8.newAnimation(bonus.grid(frames,1), 0.1)
   return bonus
end

Bonuses.bonuses = {}
extrabomb = Bonuses:create("extrabomb", "/graphics/vomitanim.png", 48, 48,'1-1')


function Bonuses:random_spawn(dt)
   if score > 50 and #Bonuses.bonuses < 1 then
      if math.random(0,1100) == 525 then
	 extrabomb.x = math.random(200,500)
	 extrabomb.y = math.random(200,500)
	 table.insert(Bonuses.bonuses, extrabomb)
      end
   end
end

