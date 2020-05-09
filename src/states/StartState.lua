StartState = Class { __includes = BaseState }

local highlighted = 1

function StartState:enter(params)
    self.highscores = params['highscores']
end

function StartState:update(dt)
    if love.keyboard.keysPressed['up'] or love.keyboard.keysPressed['down'] then
        highlighted = highlighted == 1 and 2 or 1
        gSounds['paddle-hit']:play()
    end

    if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] then
        gSounds['confirm']:play()

        if highlighted == 1 then
            gStateMachine:change('select-difficulty', {
                highscores = self.highscores
            })
        else
            gStateMachine:change('view-highscore', { highscores = self.highscores })
        end
    end
end

function StartState:render()
    --title
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Mine Sweeper', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(paletteColors[4].r, paletteColors[4].g, paletteColors[4].b, 1)
    if highlighted == 1 then
        love.graphics.setColor(paletteColors[5].r, paletteColors[5].g, paletteColors[5].b, 1)
    end

    love.graphics.printf('START GAME', 0, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(paletteColors[4].r, paletteColors[4].g, paletteColors[4].b, 1)

    if highlighted == 2 then
        love.graphics.setColor(paletteColors[5].r, paletteColors[5].g, paletteColors[5].b, 1)
    end

    love.graphics.printf('HIGH SCORES', 0, VIRTUAL_HEIGHT / 2 + 90, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(paletteColors[4].r, paletteColors[4].g, paletteColors[4].b, 1)
end
