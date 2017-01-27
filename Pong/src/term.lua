--[[

      Implementation of CC's term API
      by DvgCraft

      DATE  01-11-2016

]]--

local cursorBlink = true
local font = {}
local scale = 2
local color = {255,255,255}
local x = 1
local y = 1

function loadFont(path, pkg)
  if not love.filesystem.exists(path) then return false end
  local file = love.filesystem.newFile( path )
  file:open("r")
  local data = file:read()
  file:close()
  font = loadstring( "return "..data )()
end

function setScale(s)
  scale = s
end

function setCursorPos( X,Y )
  x, y = X, Y
end
function getCursorPos()
  return x, y
end

function getPixelPosX(x)
  return (x-1) * (font.width+1) * scale
end
function getPixelPosY(y)
  return (y-1) * (font.height+1) * scale
end
function getPixelPos(x,y)
  return getPixelPosX(x), getPixelPosY(y)
end

function getSize()
  local w, h = love.graphics.getDimensions()
  return math.floor( w/(font.width+1)/scale ), math.floor( h/(font.height+1)/scale )
end
function getPixelSize()
  local w, h = love.graphics.getDimensions()
  return math.floor( w/scale ), math.floor( h/scale )
end

function setColor(r,g,b)
  color = {r,g,b}
end

function update(s)
  if s%2 == 0 and cursorBlink then
    local x,y = term.getCursorPos()
    term.setCursorPos(x+1,y)
    term.write("_")
    term.setCursorPos(x,y)
  end
end

function write(text)
  text = tostring(text)
  for i = 1, text:len() do

    local data = font[ string.byte( text:sub(i,i) ) ]
    if not data then data = font[63] end
    for h = 1, #data do
      for w = 1, #data[h] do

        if string.sub( data[h], w,w ) == "1" then
          love.graphics.rectangle( "fill", getPixelPosX(x) + w*scale, getPixelPosY(y) + h*scale, scale, scale )
        end

      end -- End for w
    end -- End for h
    x = x + 1

  end -- End for i, text:len()
end
