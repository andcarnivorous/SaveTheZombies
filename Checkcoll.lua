function checkcoll(enemies, spits, player, bullets)

   
   for i,e in pairs(Bonuses.bonuses) do
      if e.x + (e.width / 4) <= player.x + player.width and e.x + (e.width / 4) >= player.x then
	 if e.y + (e.height/2) >= player.y and e.y + (e.height/2) <= player.y + player.height then
	    bombs = bombs + 1
	    table.remove(Bonuses.bonuses, i)
	 elseif e.y >= player.y and e.y <= player.y + player.height then
	    bombs = bombs + 1
	    table.remove(Bonuses.bonuses, i)
	 elseif e.y + (e.height/1.2) >= player.y and e.y + e.height <= player.y + player.height then
	    bombs = bombs + 1
	    table.remove(Bonuses.bonuses, i)
	 end
      end
   end
   
   for i,e in pairs(enemies) do
      if e.x + (e.width / 4) <= player.x + player.width and e.x + (e.width / 4) >= player.x then
	 if e.y + (e.height/2) >= player.y and e.y + (e.height/2) <= player.y + player.height then
	    life = 0
	 elseif e.y >= player.y and e.y <= player.y + player.height then
	    life = 0
	 elseif e.y + (e.height/1.2) >= player.y and e.y + e.height <= player.y + player.height then
	    life = 0
	 end
      end
      for i2,s in pairs(spits) do
	 if s.x <= e.x + e.width and s.x > e.x+3 and s.y > e.y and s.y < e.y + e.height then
	    new_enemies = math.random(0,4)
	    if new_enemies > 0 then
	       for y = 1, new_enemies do
		  enemies_controller:spawn()
	       end
	    end
	    if s.flag == "spit" then
	       table.remove(enemies, i)
	       table.remove(spits, i2)
	    elseif s.flag == "bomb" then

	       table.remove(spits, i2)
	       local to_remove = {}

	       for w,q in pairs(enemies) do
		  if q.x <= s.x + 300 and q.y <= s.y + 300 and q.x >= s.x - 300 and q.y >= s.y - 300 then
		     table.insert(to_remove, w)
		  end
	       end

	       for i=#to_remove,1,-1 do
		  table.remove(enemies,to_remove[i])
	       end
	       
--	       enemies = reverso(enemies, to_remove)
	    end
	    if e.kind == "Hunter" then
	       score = score +2
	       life = life + 1
	    else
	       score = score +1
	       life = life + 1
	    end
	 end
      end
   end
      for j,h in pairs(bullets) do
	 if h.x <= player.x + player.width and h.x > player.x and h.y > player.y and h.y < player.y + player.height then
	    if h.flag == "Hunter" then
	       life = life - 2
	    elseif h.flag == "Mage" then
	       life = life - 1
	       coordinates = {player.x-10, player.y}
	       table.insert(hitpoints, coordinates)
	    end

	    table.remove(bullets,j)

	 end
      end
end
