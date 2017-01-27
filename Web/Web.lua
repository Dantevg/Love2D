--[[
      
      Dynamic artwork
      by Dante van Gemert
      
      DATE  01-01-2017
      VER   1.0
      
]]--

function love.load()
  w, h = love.graphics.getDimensions()
  love.graphics.setPointSize(2)

  spd = 5
  maxDist = 200

  points = {}
end

function love.resize( W,H )
  w, h = W, H
end

function love.mousepressed( X, Y )
  XSpeed = love.math.random( -spd, spd )
  while XSpeed == 0 do XSpeed = love.math.random( -spd, spd ) end
  YSpeed = love.math.random( -spd, spd )
  while YSpeed == 0 do YSpeed = love.math.random( -spd, spd ) end
  table.insert( points, { x=X, y=Y, xSpeed=XSpeed, ySpeed=YSpeed } )
end

function calcDist( point1, point2 )
  return math.sqrt(  (point1.x - point2.x)^2  +  (point1.y - point2.y)^2  )
end

function drawLines()
  local lines = {}
  local numLines = 0

  for i1 = 1, #points do
    for i2 = 1, #points do
      if i2 ~= i1 and lines[i2..":"..i1] == nil then
        local dist = calcDist(points[i1], points[i2])
        if dist <= maxDist then
          lines[i1..":"..i2] = { points[i1], points[i2], dist }
          numLines = numLines+1
        end
      end -- End if i2 ~= i1
    end -- End for i2

  end -- End for i1

  love.graphics.setColor( 0,0,0, 255 )
  love.graphics.print( "Lines: "..numLines, 0, 0 )
  love.graphics.print( "Points: "..#points, 0, 15 )

  for _, line in pairs(lines) do
    love.graphics.setColor( 255, 255, 255, 255/line[3]*16 )
    love.graphics.line(  line[1].x, line[1].y, line[2].x, line[2].y  )
  end -- End for i1
end

function love.draw()
  love.graphics.setColor( 255, 255, 255, 255 )
  for i = 1, #points do
    love.graphics.points( points[i].x, points[i].y )
    points[i].x = points[i].x + points[i].xSpeed/8
    points[i].y = points[i].y + points[i].ySpeed/8
    if points[i].x > w then
      points[i].xSpeed = -math.abs(points[i].xSpeed)
    elseif points[i].x < 0 then
      points[i].xSpeed = math.abs(points[i].xSpeed)
    end
    if points[i].y > h then
      points[i].ySpeed = -math.abs(points[i].ySpeed)
    elseif points[i].y < 0 then
      points[i].ySpeed = math.abs(points[i].ySpeed)
    end
  end

  love.graphics.setColor( 255, 255, 255, 128 )
  love.graphics.rectangle( "fill", 0,0, 80,45 )
  drawLines()
  love.graphics.setColor( 0,0,0, 255 )
  love.graphics.print( "FPS: "..love.timer.getFPS(), 0, 30 )
end
