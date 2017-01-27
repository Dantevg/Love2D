--[[

      Pong game
      by DvgCraft

      DATE  06-11-2016
      VER   1.0

]]--

function os.loadAPI( path, name )
    local fnAPI, err = love.filesystem.load( path )
    if fnAPI then
        local ok, err = pcall( fnAPI )
        if not ok then
            return false
        end
    else
        return false
    end

    local API = {}
    for k,v in pairs( _G ) do
        if k ~= "_ENV" then
            API[k] =  v
        end
    end

    _G[name] = API
    return true
end

function love.load()
  love.keyboard.setKeyRepeat(true)
  os.loadAPI("term.lua", "term")
  term.loadFont("square.font")
  term.setScale(1)

  w, h = love.graphics.getDimensions()
  cw, ch = term.getSize()

  score = 0

  pos = 0
  size = 100

  x, y = 0, 0
  speed = 5
  direction = 0
end

function love.update()
  if love.keyboard.isDown("up") then pos = pos-5 end
  if love.keyboard.isDown("down") then pos = pos+5 end
  if love.keyboard.isDown("lctrl") and love.keyboard.isDown("d") then debug.debug() end
  pos = math.min( pos + size/2 + h/2, h )
  pos = math.max( pos - size/2 - h/2, -h/2 + size/2 )

  x = x + speed
  y = y + direction

  if x < -w/2 + 5 then
    speed = -speed
  end
  if x > w/2 - 15 then
    if y >= pos - size/2 and y <= pos + size/2 then
      score = score + 1
      size = math.max( size-2, 32 )
      speed = -speed
      direction = direction - (pos - y)/size*8
    else
      score = 0
      x, y = 0, 0
      speed = 5
      direction = 0
    end
  end

  if y > h/2 - 5 or y < -h/2 + 5 then
    direction = -direction
  end
end

function love.draw()
  term.setScale(1)
  term.setCursorPos( cw-#tostring(love.timer.getFPS().."fps")+1, 1 )
  term.write( love.timer.getFPS().."FPS" )

  term.setScale(3)
  term.setCursorPos(1,1)
  term.write(score)

  love.graphics.rectangle( "fill", w-10, h/2 + pos - size/2, 10, size )
  love.graphics.rectangle( "fill", x + w/2 - 5, y + h/2 - 5, 10, 10 )
end
