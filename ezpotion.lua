local ezpotion = {}
local scale = 2
local delt = true
function ezpotion.setdelt()
  delt = not delt
end
function ezpotion.newanim(png,w,s,l,b)

  local a = {}
  a.w = w * scale
  a.f = 1
  a.s = s
  a.loop = l
  a.b = b or 0

  a.b = a.b or 0
  a.img = love.graphics.newImage(png)
  a.h = a.img:getHeight()
  a.frames = a.img:getWidth()/(a.w+a.b)
  a.quads = {}
  offset = 0
  for i=0,a.frames - 1 do
    
    quad = love.graphics.newQuad(i * a.w + offset, 0 , a.w, a.h, a.img:getWidth(), a.img:getHeight())
    table.insert(a.quads, quad)
    offset = offset + a.b
  end
  a.time = 0
  return a
end
function ezpotion.animupdate(a)
  if delt == true then
    dmult = love.timer.getDelta()*60
  else
    dmult = 1
  end
  if a.s > 0 then
    a.time = a.time + dmult
    if a.time >= a.s then
      framesmissed = math.floor(a.time / a.s)
      a.f = a.f + framesmissed
      a.time = a.time - framesmissed * a.s
      
    end
  end
  while a.f >= a.frames + 1 do
    if a.loop then
      a.f = a.f - a.frames
    else
      a.f = a.frames
    end
  end 

end
function ezpotion.animdraw(a,x,y,r,sx,sy,ox,oy,kx,ky)
  x = x or 0
  y = y or 0
  r = r or 0
  sx = sx or 1
  sy = sy or sx
  ox = ox or 0
  oy = oy or 0
  kx = kx or 0
  ky = ky or 0
  quad = a.quads[a.f]
  love.graphics.draw(a.img,quad,math.floor(x+ 0.5)*scale,math.floor(y + 0.5)*scale,r,sx,sx,ox,oy,kx,ky)
end

function ezpotion.resetanim(a)
  a.f=1
  a.time=0
end
return ezpotion