SelectDifficultyState = Class { __includes = BaseState }

function SelectDifficultyState:enter(params)
    self.highscores = params['highscores']
end

function SelectDifficultyState:init()
    self.difficulty = 1
end

function SelectDifficultyState:update(dt)
    if love.keyboard.wasPressed('left') then
        if self.difficulty == 1 then
            gSounds['no-select']:play()
        else
            gSounds['select']:play()
            self.difficulty = self.difficulty - 1
        end
    elseif love.keyboard.wasPressed('right') then
        if self.difficulty == 3 then
            gSounds['no-select']:play()
        else
            gSounds['select']:play()
            self.difficulty = self.difficulty + 1
        end
    end

    -- select paddle and move on to the serve state, passing in the selection
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        gSounds['confirm']:play()

        gStateMachine:change('play', {
            difficulty = self.difficulty,
            score = 0,
            highscores = self.highscores,
        })
    end
end

function SelectDifficultyState:render()
    -- instructions
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Select difficulty with left and right!", 0, 40,
        VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("During gameplay, press enter to open a tile, space to flag, p to pause and arrow keys to move around.", 0, VIRTUAL_HEIGHT / 3 - 20,
        VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(0.8, 0.2, 0.2, 1)
    love.graphics.printf("Press a for AI move!!", 0, VIRTUAL_HEIGHT / 3 + 20,
        VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1,1,1, 1)
    love.graphics.printf("(Press Enter to continue!)", 0, VIRTUAL_HEIGHT / 2 - 30,
        VIRTUAL_WIDTH, 'center')

    -- left arrow; should render normally if we're higher than 1, else
    -- in a shadowy form to let us know we're as far left as we can go
    if self.currentPaddle == 1 then
        -- tint; give it a dark gray with half opacity
        love.graphics.setColor(40, 40, 40, 30)
    end

    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], VIRTUAL_WIDTH / 4 - 24,
        VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)

    -- reset drawing color to full white for proper rendering
    love.graphics.setColor(255, 255, 255, 255)

    -- right arrow; should render normally if we're less than 4, else
    -- in a shadowy form to let us know we're as far right as we can go
    if self.currentPaddle == 4 then
        -- tint; give it a dark gray with half opacity
        love.graphics.setColor(40, 40, 40, 30)
    end

    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], VIRTUAL_WIDTH - VIRTUAL_WIDTH / 4,
        VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)

    -- reset drawing color to full white for proper rendering
    love.graphics.setColor(paletteColors[4].r, paletteColors[4].g, paletteColors[4].b, 1)

    -- draw the paddle itself, based on which we have selected
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf(tostring(self.difficulty),
        VIRTUAL_WIDTH / 4 - 24, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH/2 + 32, 'center')
end
