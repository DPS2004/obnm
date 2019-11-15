function love.load()
  -- main font is bulky pixels from www.smokingdrum.com
  bulky = love.graphics.newFont("BULKYPIX.TTF", 20)
  love.graphics.setFont(bulky)
  ez = require "ezpotion"
  if pcall(potiontest) then
    lovepotion = true
  else
    lovepotion = false
  end
  
  if not lovepotion then
    touchscreen = false
    love.window.setMode(400,240)
    fire = "space"
    tscreen = true
    delt = true
    love.window.setTitle("One Button Ninja Mayhem")
  else
    fire = "a"
    touchscreen = true
    delt = false
    ez.setdelt()
  end

  love.graphics.setBackgroundColor(255,255,255)
  dmult=1
  hits = 1
  rotation = 4
  gstate = "title"
  score = 0
  dl = false
  stars = {}
  ninjas = {}
  angle = 180
  spawnrate = 120
  spawntimer = 60
  showline = true
  img = {
    ninja = ez.newanim("ninja.png",8,0,false,0),
    rninja = ez.newanim("rninja.png",8,15,true,0),
    dot = ez.newanim("dot.png",1,0,true,0),
    star = ez.newanim("star.png",8,0,true,0),
    bs = {
      ez.newanim("bs1.png",160,10,true,0),
      ez.newanim("bs2.png",160,10,true,0),
      ez.newanim("bs3.png",160,10,true,0),
      ez.newanim("bs4.png",160,10,true,0),
      ez.newanim("bs5.png",160,10,true,0),
      ez.newanim("bs6.png",160,10,true,0),
      ez.newanim("bs7.png",160,10,true,0),
      ez.newanim("bs8.png",160,10,true,0),
      ez.newanim("bs9.png",160,10,true,0),
      ez.newanim("bs10.png",160,10,true,0),
      ez.newanim("bs11.png",160,10,true,0)
      },
    eyes = ez.newanim("eyes.png",10,0,true,0),
    dead = ez.newanim("dninja.png",10,0,true,0),
    logo = ez.newanim("animlogo.png",200,3,false,0),
    menu = ez.newanim("menu.png",160,0,true,0)
  }
end
function potiontest()
  love.graphics.setScreen('top')
end
function checkcollision()
  for si,sv in ipairs(stars) do
    for ni,nv in ipairs(ninjas) do 
      if sv.x >= nv.x - 4 and sv.x <= nv.x + 12 and sv.y >= nv.y -4  and sv.y <= nv.y+ 13 and not nv.dead then
        nv.dead = true
        sv.kills = sv.kills + 1
        score = score + 100*sv.kills
        if nv.hit then
          score = score + 100
        end
      end
    end
  end
  for ni,nv in ipairs(ninjas) do
    if nv.x >= 88 and nv.x <= 104 and nv.y >= 45 and nv.y <= 65 then
      nv.hit = true
      hits = hits + 1
    end
  end
end
function newninja(x,y)
  n = {}
  n.time = 0
  n.x = x
  n.hit = false
  n.y = y
  n.dead = false
  n.f = 1
  n.vx = (96 - n.x) / math.sqrt(((96- n.x)^2)+((55-n.y)^2)) * 0.5
  n.vy = (55 - n.y) / math.sqrt(((96- n.x)^2)+((55-n.y)^2)) * 0.5
  table.insert(ninjas,n)
end
function newstar(an,sp)
  s = {}
  s.kills = 0
  s.x = 100
  s.y = 60
  s.vx = (sp * math.cos((90 - an) * math.pi / 180))
  s.vy = (0 - sp * math.sin((90 - an) * math.pi / 180))
  table.insert(stars,s)
end
function updateninja(n,i)
  if not n.dead then
    if not n.hit then
      n.x = n.x + n.vx * dmult
      n.y = n.y + n.vy * dmult
    else
      n.x = n.x + (n.vx * dmult * -2)
      n.y = n.y + (n.vy * dmult * -2)
    end
  else

    n.time = n.time + dmult
    if n.time >= 5 then
      framesmissed = math.floor(n.time / 5)
      n.f = n.f + framesmissed
      n.time = n.time - framesmissed * 5
    end
    if n.f >= 12 then
      table.remove(ninjas,i)
    end
  end
  if n.x < -8 or n.x > 200 or n.y < -10 or n.y > 120 then
    table.remove(ninjas,i)
  end
end
function updatestar(s,i)
  s.x = s.x + s.vx * dmult
  s.y = s.y + s.vy * dmult
  if s.x < -8 or s.x > 200 or s.y < -8 or s.y > 120 then
    table.remove(stars,i)
  end
end
function drawstar(s)
  ez.animdraw(img.star,s.x - 4, s.y - 4)
end
function drawninja(n)
  if not n.dead then
    ez.animdraw(img.rninja,n.x, n.y)
  else
    img.dead.f = n.f
    ez.animdraw(img.dead,n.x,n.y)
  end
end
function love.keypressed(key)
  if key == "s" and not lovepotion then
    tscreen = not tscreen
  end
  if key == "select" then
    touchscreen = not touchscreen
  end
end
function love.keyreleased(key)
  if gstate == "ambush" and hits ~= 11 then
    if not touchscreen then
      if key == fire then
        if rotation == 4 then
          rotation = -4
        else
          rotation = 4
        end
        newstar(angle,4)
      end
    end
  end
end
function love.mousereleased(x,y,key)
  if gstate == "ambush" and hits ~= 11 then
    if touchscreen then
      if rotation == 4 then
        rotation = -4
      else
        rotation = 4
      end
      newstar(angle,4)
    end
  end
end

function love.update()
  if delt == true then
    dmult = love.timer.getDelta()*60
  else
    dmult = 1
  end
  if gstate == "title" then
    if love.mouse.isDown(1) then
      if love.mouse.getX() < 80 then

        gstate = "ambush"
      end
    end
    ez.animupdate(img.logo)
    
  end
  if gstate == "ambush" then
    img.ninja.f = hits
    if hits ~= 11 then
      if not touchscreen then
        if love.keyboard.isDown(fire) then
          angle = angle + rotation * dmult
          showline = true
        else
          showline = false
        end
      else
        if love.mouse.isDown(1) then
          angle = angle + rotation * dmult
          showline = true
        else
          showline = false
        end
      end
    end
    for i,v in ipairs(stars) do
      updatestar(v,i)
    end
    -- spawn ninjas
    spawntimer = spawntimer - dmult
    if hits ~= 11 then
      if spawntimer <= 0 then 
        spawntimer = spawntimer + spawnrate
        spawnloc = math.random(0,3)
        if spawnloc == 0 then
          newninja(-8,math.random(-10,120))
        elseif spawnloc == 1 then
          newninja(math.random(-8,200),-10)
        elseif spawnloc == 2 then
          newninja(200,math.random(-10,120))
        else
          newninja(math.random(-8,200),120)
        end
      end
    end
    for i,v in ipairs(ninjas) do
      updateninja(v,i)
    end
    checkcollision()
    if hits == 11 then
      showline = false
      for i,v in ipairs(ninjas) do
        v.hit = true
        
      end
      
    end
    ez.animupdate(img.rninja)
    ez.animupdate(img.ninja)
    for i,v in ipairs(img.bs) do
      ez.animupdate(v)
    end
  end
end
function love.draw()
  if gstate == "title" then
    love.graphics.setColor(255,255,255)
    ez.animdraw(img.logo)
    love.graphics.setColor(0,0,0)

    if lovepotion or not tscreen then
      if lovepotion then
        
        love.graphics.setScreen('bottom')
      end
      love.graphics.setColor(255,255,255)
      ez.animdraw(img.menu)
    end
  end
  if gstate == "ambush" then
    if lovepotion then
      love.graphics.setScreen('top')
    end
    love.graphics.setColor(255,255,255)
    if showline then
      ez.animdraw(img.dot,(4 * math.cos((90 - angle) * math.pi / 180))+99.5,(0 - 4 * math.sin((90 - angle) * math.pi / 180))+59.5)
      ez.animdraw(img.dot,(6 * math.cos((90 - angle) * math.pi / 180))+99.5,(0 - 6 * math.sin((90 - angle) * math.pi / 180))+59.5)
      ez.animdraw(img.dot,(8 * math.cos((90 - angle) * math.pi / 180))+99.5,(0 - 8 * math.sin((90 - angle) * math.pi / 180))+59.5)
      ez.animdraw(img.dot,(10 * math.cos((90 - angle) * math.pi / 180))+99.5,(0 - 10 * math.sin((90 - angle) * math.pi / 180))+59.5)
      ez.animdraw(img.dot,(12 * math.cos((90 - angle) * math.pi / 180))+99.5,(0 - 12 * math.sin((90 - angle) * math.pi / 180))+59.5)
      ez.animdraw(img.dot,(14 * math.cos((90 - angle) * math.pi / 180))+99.5,(0 - 14 * math.sin((90 - angle) * math.pi / 180))+59.5)
    end
    for i,v in ipairs(ninjas) do
      drawninja(v)
    end
    for i,v in ipairs(stars) do
      drawstar(v)
    end
    ez.animdraw(img.ninja,96,55)
    if lovepotion or not tscreen then
      if lovepotion then
        love.graphics.setScreen('bottom')
      end
      ez.animdraw(img.bs[hits],0,0)
      if hits ~= 11 then
        ez.animdraw(img.eyes,75+(3 * math.cos((90 - angle) * math.pi / 180)),46+(0 - 3 * math.sin((90 - angle) * math.pi / 180)))
      end
      love.graphics.setColor(0,0,0)
      love.graphics.print(score)
    end
  end
end