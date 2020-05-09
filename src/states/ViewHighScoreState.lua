ViewHighScoreState = Class { __includes = BaseState }

function ViewHighScoreState:enter(params)
    self.highScores = params['highscores']
end

function ViewHighScoreState:update(dt)
    if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] or love.keyboard.keysPressed['escape'] then
        gSounds['wall-hit']:play()
        gStateMachine:change('start', { highscores = self.highScores })
    end
end

function ViewHighScoreState:render()
    love.graphics.setColor(255,255,255,255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('High Scores', 0, 20, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    -- 

    -- iterate over all high score indices in our high scores table
    for i = 1, 10 do
        local name = self.highScores[i].name or '---'
        local score = self.highScores[i].score or '---'

        -- score number (1-10)
        love.graphics.printf(tostring(i) .. '.', VIRTUAL_WIDTH / 4,
            60 + i * 13, 50, 'left')

        -- score name
        love.graphics.printf(name, VIRTUAL_WIDTH / 4 + 38,
            60 + i * 13, 50, 'right')

        -- score itself
        love.graphics.printf(tostring(score), VIRTUAL_WIDTH / 2,
            60 + i * 13, 100, 'right')
    end

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("Press enter to return to the main menu!",
        0, VIRTUAL_HEIGHT - 18, VIRTUAL_WIDTH, 'center')
end
