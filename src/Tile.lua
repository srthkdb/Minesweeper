Tile = Class{}

function Tile:init(params)
    self.code = params.code
    self.x = params.x
    self.y = params.y

    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)

    self.psystem:setParticleLifetime(0.5, 1)
    self.psystem:setLinearAcceleration(-15, 0, 15, 80)
    self.psystem:setAreaSpread('normal', 10, 10)

    self.color = params.color
    self.i = params.i
    self.j = params.j
end

function Tile:hit(ai)
    gSounds['brick-hit-1']:stop()
    gSounds['brick-hit-1']:play()

    self.psystem:setColors(paletteColors[self.color].r, paletteColors[self.color].g, paletteColors[self.color].b, 1, 
    paletteColors[self.color].r, paletteColors[self.color].g, paletteColors[self.color].b, 0)
    self.psystem:emit(64)
end

function Tile:update(dt)
    self.psystem:update(dt)
end

function Tile:render()
    if self.code == 0 then
        love.graphics.setColor(paletteColors[self.color].r, paletteColors[self.color].g, paletteColors[self.color].b, 255)
        love.graphics.rectangle('fill', self.x, self.y, TILE_WIDTH, TILE_HEIGHT)
        love.graphics.setColor(255, 255, 255, 255)
    elseif self.code == -2 then
        love.graphics.setColor(paletteColors[3].r, paletteColors[3].g, paletteColors[3].b, 255)
        love.graphics.rectangle('fill', self.x, self.y, TILE_WIDTH, TILE_HEIGHT)
        love.graphics.setColor(255, 255, 255, 255)
    elseif self.code == -1 then
        love.graphics.setColor(paletteColors[4].r, paletteColors[4].g, paletteColors[4].b, 0.5)
        love.graphics.rectangle('fill', self.x, self.y, TILE_WIDTH, TILE_HEIGHT)
        love.graphics.setColor(255, 255, 255, 255)
    else
        love.graphics.setColor(paletteColors[4].r, paletteColors[4].g, paletteColors[4].b, 0.6)
        love.graphics.rectangle('fill', self.x, self.y, TILE_WIDTH, TILE_HEIGHT)
        love.graphics.setColor(1,1,1, 0.5)
        love.graphics.setFont(gFonts['medium'])
        love.graphics.print(tostring(self.code), self.x + TILE_WIDTH/2 - 8, self.y + TILE_HEIGHT / 2 - 8)
        love.graphics.setColor(255, 255, 255, 255)

    end
end

function Tile:renderParticles()
    love.graphics.draw(self.psystem, self.x + TILE_WIDTH / 2, self.y + TILE_HEIGHT / 2)
end
