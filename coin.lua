coins = {}

function spawnCoid(x, y)
  local coin = {}
  coin.x = x
  coin.y = y
  coin.collected = false

  table.insert(coins, coin)
end

function coinUpdate (dt)
  for i,c in ipairs(coins) do
    if distanceBetween(c.x, c.y, player.body:getX(), player.body:getY()) < 50 then
      c.collected = true
    end  
end
