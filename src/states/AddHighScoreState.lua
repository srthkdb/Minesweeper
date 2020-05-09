AddHighScoreState = Class { __includes = BaseState }

local chars = {
    [1] = 65,
    [2] = 65,
    [3] = 65,
}

local highlighted = 1

function AddHighScoreState:enter(params)
    self.highscores = params.highscores
    self.score = params.score
    self.scoreIndex = params.scoreIndex
end

function AddHighScoreState:update(dt)
    if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] then
        local name = string.char(chars[1]) .. string.char(chars[2]) .. string.char(chars[3])

        for i = 10, self.scoreIndex, -1 do
            self.highscores[i + 1] = {
                score = self.highscores[i].score,
                name = self.highscores[i].name
            }
        end

        self.highscores[self.scoreIndex].name = name
        self.highscores[self.scoreIndex].score = self.score


        local str = ''
        for i = 1, 10 do
            str = str .. self.highscores[i].name .. '\n'
            str = str .. tostring(self.highscores[i].score) .. '\n'
        end

        love.filesystem.write('minesweeper.lst', str)

        gStateMachine:change('view-highscore', {
            highscores = self.highscores
        })
    end

    if love.keyboard.keysPressed['left'] then
        if highlighted > 1 then
            gSounds['select']:play()
            highlighted = highlighted - 1
        end
    elseif love.keyboard.keysPressed['right'] then
        if highlighted < 3 then
            gSounds['select']:play()
            highlighted = highlighted + 1
        end
    end

    if love.keyboard.keysPressed['up'] then
        chars[highlighted] = chars[highlighted] + 1
        if chars[highlighted] > 90 then
            chars[highlighted] = 65
        end
    elseif love.keyboard.keysPressed['down'] then
        chars[highlighted] = chars[highlighted] - 1
        if chars[highlighted] < 65 then
            chars[highlighted] = 90
        end
    end
end

function AddHighScoreState:render()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Your score: ' .. tostring(self.score), 0, 30,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['large'])

    --
    -- render all three characters of the name
    love.graphics.setColor(paletteColors[4].r, paletteColors[4].g, paletteColors[4].b, 1)
    if highlightedChar == 1 then
        love.graphics.setColor(0, 255, 255, 255)
    end
    love.graphics.print(string.char(chars[1]), VIRTUAL_WIDTH / 2 - 28, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(paletteColors[4].r, paletteColors[4].g, paletteColors[4].b, 1)

    if highlightedChar == 2 then
        love.graphics.setColor(0, 255, 255, 255)
    end
    love.graphics.print(string.char(chars[2]), VIRTUAL_WIDTH / 2 - 6, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(paletteColors[4].r, paletteColors[4].g, paletteColors[4].b, 1)

    if highlightedChar == 3 then
        love.graphics.setColor(0, 255, 255, 255)
    end
    love.graphics.print(string.char(chars[3]), VIRTUAL_WIDTH / 2 + 20, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(paletteColors[4].r, paletteColors[4].g, paletteColors[4].b, 1)

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press Enter to confirm!', 0, VIRTUAL_HEIGHT - 18,
        VIRTUAL_WIDTH, 'center')
end
