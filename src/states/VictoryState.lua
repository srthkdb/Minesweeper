VictoryState = Class { __includes = BaseState }

function VictoryState:enter(params)
    self.difficulty = params['difficulty']
    self.score = params['score']
    self.highscores = params['highscores']
end

function VictoryState:update(dt)

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {
            level = math.max(3, self.difficulty + 1),
            score = self.score,
            highscores = self.highscores
        })
    end
end

function VictoryState:render()
    displayScore(self.score)

    -- level complete text
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("Difficulty " .. tostring(self.difficulty) .. " complete!",
        0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')

    -- instructions text
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter to continue!', 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
end
