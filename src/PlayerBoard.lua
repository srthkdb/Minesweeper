PlayerBoard = Class{}

function PlayerBoard:init(rows, cols)
    self.rows = rows
    self.cols = cols

     --0 -> hidden, -1->open, n > 0 -> show n, -2 -> flagged
    self.currX = 1
    self.currY = 1
    self.openTiles = 0
    offSetX = (VIRTUAL_WIDTH - (TILE_WIDTH + TILE_GAP) * self.rows) / 2
    offSetY = (VIRTUAL_HEIGHT - (TILE_HEIGHT + TILE_GAP) * self.rows) / 2

    self:resetBoard()
end

function PlayerBoard:update(dt)
    if love.keyboard.keysPressed['right'] then
        gSounds['paddle-hit']:play()
        self.currX = math.min(self.currX + 1, self.cols)
    elseif love.keyboard.keysPressed['left'] then
        gSounds['paddle-hit']:play()
        self.currX = math.max(self.currX - 1 , 1)
    elseif love.keyboard.keysPressed['up'] then
        gSounds['paddle-hit']:play()
        self.currY = math.max(self.currY - 1, 1)
    elseif love.keyboard.keysPressed['down'] then
        gSounds['paddle-hit']:play()
        self.currY = math.min(self.currY + 1 , self.cols)
    end

    if love.keyboard.keysPressed['space'] then
        gSounds['wall-hit']:play()
        if self.board[self.currY][self.currX].code == 0 then
            self.board[self.currY][self.currX].code = -2
        elseif self.board[self.currY][self.currX].code == -2 then
            self.board[self.currY][self.currX].code = 0
        end
    end

    for i = 1, self.rows do
        for j = 1, self.cols do
            self.board[i][j]:update(dt)
        end
    end

end

function PlayerBoard:resetBoard()
    self.board = {}
    local color = true 
    for i = 1, self.rows do
        local row = {}
        for j = 1, self.cols do
            row[#row + 1] = Tile({
                ['code'] = 0,
                ['x'] = offSetX + (TILE_GAP + TILE_WIDTH) * (j - 1),
                ['y'] = offSetY + (TILE_GAP + TILE_HEIGHT) * (i - 1),
                ['color'] = color and 1 or 2,
                ['i'] = i,
                ['j'] = j 
            })
            color = not color
        end
        self.board[#self.board + 1] = row
    end
end

function PlayerBoard:render()
    for i = 1, self.rows do
        for j = 1, self.cols do
            self.board[i][j]:render()
        end
    end

    for i = 1, self.rows do
        for j = 1, self.cols do
            self.board[i][j]:renderParticles()
        end
    end

    love.graphics.setColor(255, 255, 255, 255);
    love.graphics.rectangle('line', offSetX + (TILE_GAP + TILE_WIDTH) * (self.currX - 1), 
        offSetY + (TILE_GAP + TILE_HEIGHT) * (self.currY - 1), TILE_WIDTH, TILE_HEIGHT)

end

