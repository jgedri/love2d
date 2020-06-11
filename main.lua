
function love.load()
  love.window.setMode(900, 700, flags)

  myWorld = love.physics.newWorld(0, 500, false)
  myWorld:setCallbacks(beginContact, endContact, preSolve, postSolve)
  sprites = {}
  sprites.coin_sheet = love.graphics.newImage('sprites/coin_sheet.png')
  sprites.player_jump = love.graphics.newImage('sprites/player_jump.png')
  sprites.player_stand = love.graphics.newImage('sprites/player_stand.png')

  require('player')
  require('coin')
  anim8 = require('anim8/anim8')
  cameraFile = require("hump/camera")
  sti = require('sti')

  map = sti("maps/level1.lua")

  cam = cameraFile()
  gameState = 1
  timer = 0

  for i, obj in pairs(map.layers["Platforms"].objects) do
    spawnPlatform(obj.x, obj.y, obj.width, obj.height)
  end

  platforms = {}

  gameState = 1
  myFont = love.graphics.newFont(30)

  for i, obj in pairs(layers["Coins"].objects) do
    spawnCoin(obj.x, obj.y)
  end
end

function love.update(dt)
  myWorld:update(dt)
  playerUpdate(dt)
  map:update(dt)
  coinUpdate(dt)

  cam:lookAt(player.body:getX(), player.body:getY())

  for i,c in ipairs(coins) do
    c.animation:update(dt)
  end

  if gameState == 2 then
    timer = timer + dt
  end

  if #coins == 0 and gameState == 2 then
    gameState = 1
  end

  if #coins == 0 then
    for i, obj in pairs(layers["Coins"].objects) do
      spawnCoin(obj.x, obj.y)
  end
end

function love.draw()
  cam:attach()

  map:drawLayer(map.layers["Tile Layer 1"])

  love.graphics.draw(player.sprite, player.body:getX(), player.body:getY(), nil, player.direction, 1, sprites.player_stand:getWidth()/2, sprites.player_stand:getHeight()/2)

  for i,p in ipairs(platforms) do
    love.graphics.rectangle("fill", p.body:getX(), p.body:getY(), p.width, p.height)

    cam:detatch()

    if gameState == 1 then
      love.graphics.setFont(myFont)
      love.graphics.printf("Press any key to begin!", 0, 50, love.graphics.getWidth(), "center")
    end

    love.graphics.print("Time: " .. math.math.floor(timer), 10, 660)


    for i,c in ipairs(coins) do
      c.animation:draw(sprites.coin_sheet, c.x, c.y, nil, nil, nil, 20.5, 21)
    end
  end
end

function love.keypressed(key, scancode, isrepeat)
  if key == "space" and player.grounded == true then
    player.body:applyLinearImpulse(0, -2500)
  end

  if gameState == 1 then
    gameState = 2
    timer = 0
  end
end

function spawnPlatform(x, y, width, height)
  local platform = {}
  platform.body = love.physics.newBody(myWorld, x, y, "static")
  platform.shape = love.physics.newRectangleShape(width/2, height/2, width, height)
  platform.fixture = love.physics.newFixture(platform.body, platform.shape)
  platform.width = width
  platform.height = height

  table.insert(platforms, platform)
end

function beginContact(a, b, coll)
  player.grounded = true
end

function endContact(a, b, coll)
  player.grounded = false
end

function distanceBetween(x1, y1, x2, y2)
  return math.math.sqrt((y2 - y1)^2 + (x2 -y2)^2)
end
