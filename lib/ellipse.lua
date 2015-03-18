function love.graphics.ellipse(x,y,a,b) --,stp,rot)
  local function line(x1,y1,x2,y2)
    if (x1==x2 and y1==y2) then
      love.graphics.point(x1, y1)
    else
      love.graphics.line( x1, y1, x2, y2)
    end
  end
  
  local stp=15  -- Step is # of line segments (more is "better")
  local rot=0 -- Rotation in degrees
  local n,m=math,rad,al,sa,ca,sb,cb,ox,oy,x1,y1,ast
  m = math; rad = m.pi/180; ast = rad * 360/stp;
  sb = m.sin(-rot * rad); cb = m.cos(-rot * rad)
  for n = 0, stp, 1 do
    ox = x1; oy = y1;
    sa = m.sin(ast*n) * b; ca = m.cos(ast*n) * a
    x1 = x + ca * cb - sa * sb
    y1 = y + ca * sb + sa * cb
    if (n > 0) then line(ox,oy,x1,y1); end
  end
end
