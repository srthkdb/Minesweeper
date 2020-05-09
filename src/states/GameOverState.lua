GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
    self.score = params['score']
    self.highscores = params['highscores']
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        local highScore = false

        -- keep track of what high score ours overwrites, if any
        local highScoreIndex = 11

        for i = 10, 1, -1 do
            local score = self.highscores[i].score or 0
            if self.score > score then
                highScoreIndex = i
                highScore = true
            end
        end

        if highScore then
            gSounds['high-score']:play()
            gStateMachine:change('add-highscore', {
                highscores = self.highscores,
                score = self.score,
                scoreIndex = highScoreIndex
            })
        else
            gStateMachine:change('start', {
                highscores = self.highscores
            })
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function GameOverState:render()
    local backgroundWidth = gTextures['game-over']:getWidth()
    local backgroundHeight = gTextures['game-over']:getHeight()

    love.graphics.draw(gTextures['game-over'], 0, 0,
        0,
        VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Final Score: ' .. tostring(self.score), 0, VIRTUAL_HEIGHT - 140, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter!', 0, VIRTUAL_HEIGHT - 30,
        VIRTUAL_WIDTH, 'center')
end