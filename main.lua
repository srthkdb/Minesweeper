require 'src/dependencies'

--Credits: fonts, sounds are used from CS50-GD breakout assets

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Minesweeper')
    math.randomseed(os.time())
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 12),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 18),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
    }
    love.graphics.setFont(gFonts['small'])

    gSounds = {
        ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
        ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
        ['no-select'] = love.audio.newSource('sounds/no-select.wav', 'static'),
        ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav', 'static'),
        ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
        ['recover'] = love.audio.newSource('sounds/recover.wav', 'static'),
        ['high-score'] = love.audio.newSource('sounds/high_score.wav', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),
        ['music'] = love.audio.newSource('sounds/Coffin_dance.mp3', 'static')
    }

    gTextures = {
        ['background'] = love.graphics.newImage('graphics/bg.png'),
        ['game-over'] = love.graphics.newImage('graphics/gameOver.jpg'),
        ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
        ['particle'] = love.graphics.newImage('graphics/particle.png')
    }

    gFrames = {
        ['arrows'] = GenerateQuads(gTextures['arrows'], 24, 24),
    }

    gStateMachine = StateMachine({
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end,
        ['victory'] = function() return VictoryState() end,
        ['add-highscore'] = function() return AddHighScoreState() end,
        ['view-highscore'] = function() return ViewHighScoreState() end,
        ['select-difficulty'] = function() return SelectDifficultyState() end,
        ['start'] = function() return StartState() end,
    })

    gSounds['music']:play()
    gSounds['music']:setLooping(true)

    gStateMachine:change('start', { highscores = loadHighScores() })

    love.keyboard.keysPressed = {}
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    end
    return false
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    local backgroundWidth = gTextures['background']:getWidth()
    local backgroundHeight = gTextures['background']:getHeight()

    love.graphics.draw(gTextures['background'], 0, 0,
        0,
        VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))

    
    gStateMachine:render()
    push:finish()
end

function loadHighScores()
    love.filesystem.setIdentity('minesweeper')

    -- if the file doesn't exist, initialize it with some default scores
    if not love.filesystem.exists('minesweeper.lst') then
        local scores = ''
        for i = 10, 1, -1 do
            scores = scores .. 'CTO\n'
            scores = scores .. tostring(0) .. '\n'
        end

        love.filesystem.write('minesweeper.lst', scores)
    end

    -- flag for whether we're reading a name or not
    local name = true
    local currentName = nil
    local counter = 1

    -- initialize scores table with at least 10 blank entries
    local scores = {}

    for i = 1, 10 do
        -- blank table; each will hold a name and a score
        scores[i] = {
            name = 'cto',
            score = 0
        }
    end

    -- iterate over each line in the file, filling in names and scores
    for line in love.filesystem.lines('minesweeper.lst') do
        if name then
            scores[counter].name = string.sub(line, 1, 3)
        else
            scores[counter].score = tonumber(line)
            counter = counter + 1
        end

        -- flip the name flag
        name = not name
    end

    return scores
end

function displayScore(score)
    love.graphics.setColor(paletteColors[5].r, paletteColors[5].g, paletteColors[5].b, 1)
    love.graphics.setFont(gFonts['small'])
    love.graphics.print('Score:', VIRTUAL_WIDTH - 90, 5)
    love.graphics.printf(tostring(score), VIRTUAL_WIDTH - 60, 5, 40, 'right')
end
