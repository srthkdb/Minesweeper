PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.difficulty = params['difficulty']
    self.score = params['score']
    self.pause = false
    self.highscores = params['highscores']

    if self.difficulty == 1 then
        TILE_WIDTH, TILE_HEIGHT = 40, 40
        self.rows = 9
        self.cols = 9
        self.mines = 10
        self.score_factor = 12    --as the prob of finding mine in this difficulty is 0.12
    elseif self.difficulty == 2 then
        TILE_WIDTH, TILE_HEIGHT = 24, 24
        self.rows = 16
        self.cols = 16
        self.mines = 40
        self.score_factor = 15     --as the prob of finding mine in this difficulty is 0.15
    else
        TILE_WIDTH, TILE_HEIGHT = 16, 16
        self.rows = 24
        self.cols = 24
        self.mines = 99
        self.score_factor = 17     --as the prob of finding mine in this difficulty is 0.17
    end

    self.gameBoard = GameBoard(self.rows, self.cols, self.mines)
    self.playerBoard = PlayerBoard(self.rows, self.cols)

    self.first = true
end

function PlayState:inRange(i, j)
    local a = (i > 0) and (i <= self.rows) and (j > 0) and (j <= self.cols)
    return a
end

function PlayState:countAdjacent(i, j)
    local cnt = 0

    if self:inRange(i, j+1) and self.gameBoard.board[i][j+1] == 1 then 
        cnt = cnt + 1
    end
    if self:inRange(i, j-1) and self.gameBoard.board[i][j-1] == 1 then 
        cnt = cnt + 1
    end
    if self:inRange(i+1, j+1) and self.gameBoard.board[i+1][j+1] == 1 then 
        cnt = cnt + 1
    end
    if self:inRange(i-1, j+1) and self.gameBoard.board[i-1][j+1] == 1 then 
        cnt = cnt + 1
    end
    if self:inRange(i+1, j-1) and self.gameBoard.board[i+1][j-1] == 1 then 
        cnt = cnt + 1
    end
    if self:inRange(i-1, j-1) and self.gameBoard.board[i-1][j-1] == 1 then 
        cnt = cnt + 1
    end
    if self:inRange(i+1, j) and self.gameBoard.board[i+1][j] == 1 then 
        cnt = cnt + 1
    end
    if self:inRange(i-1, j) and self.gameBoard.board[i-1][j] == 1 then 
        cnt = cnt + 1
    end

    return cnt
end

function PlayState:clickBoard(i, j)
    if self:inRange(i, j) and not self.vis[i + (j * self.cols)] then
        self.vis[i + j * self.cols] = true
        self.playerBoard.board[i][j]:hit()
        local adj = self:countAdjacent(i, j)
        if adj == 0 then
            self.playerBoard.board[i][j].code = -1
            if self:inRange(i+1, j) then
                self:clickBoard(i+1, j)
            end
            if self:inRange(i+1, j+1) then
                self:clickBoard(i+1, j+1)
            end
            if self:inRange(i+1, j-1) then
                self:clickBoard(i+1, j-1)
            end
            if self:inRange(i, j+1) then
                self:clickBoard(i, j+1)
            end
            if self:inRange(i, j-1) then
                self:clickBoard(i, j-1)
            end
            if self:inRange(i-1, j) then
                self:clickBoard(i-1, j)
            end
            if self:inRange(i-1, j+1) then
                self:clickBoard(i-1, j+1)
            end
            if self:inRange(i-1, j-1) then
                self:clickBoard(i-1, j-1)
            end
        else
            self.playerBoard.board[i][j].code = adj
        end
    end
end

function PlayState:update(dt)
    if self.pause then
        if love.keyboard.keysPressed['p'] then
            self.pause = false
            gSounds['pause']:play()
        else
            return
        end
    else
        if love.keyboard.keysPressed['p'] then
            self.pause = true
            gSounds['pause']:play()
            return
        end
    end

    if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] then
        local i = self.playerBoard.currY
        local j = self.playerBoard.currX

        self.playerBoard.board[i][j]:hit()
        if self.gameBoard.board[i][j] == 1 then
            if self.first then
                while self.gameBoard.board[i][j] == 1 do
                    self.gameBoard:reset()
                end
                self.vis = {}
                self:clickBoard(i, j)
                self.score = self:getScore()
                self:checkVictory()
            else
                gStateMachine:change('game-over', {
                    highscores = self.highscores,
                    score = self.score,
                    difficulty = self.difficulty
                })
            end
        else
            self.vis = {}
            self:clickBoard(i, j)
            self.score = self:getScore()
            self:checkVictory()
        end

        self.first = false
    end

    self.playerBoard:update(dt)
end

function PlayState:render()
    self.playerBoard:render()

    if self.pause then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end

    displayScore(self.score)
end

function PlayState:countHidden()
    local cnt = 0
    for i = 1, self.rows do
        for j = 1, self.cols do
            if self.gameBoard.board[i][j] == 0 and self.playerBoard.board[i][j].code == 0 then
                cnt = cnt + 1
            end
        end
    end
    return cnt
end

function PlayState:checkVictory()
    local cnt = self:countHidden()
    if cnt == 0 then
        gStateMachine:change('victory', {
            highscores = self.highscores,
            score = self.score,
            difficulty = self.difficulty
        })
    end
end

function PlayState:getScore()
    local cnt = self:countHidden()
    cnt = (self.rows * self.cols) - self.mines - cnt
    return self.score_factor * cnt 
end