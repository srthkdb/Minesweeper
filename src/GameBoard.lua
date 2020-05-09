GameBoard = Class{}

function GameBoard:init(rows, cols, mines)
    self.rows = rows
    self.cols = cols

    self.mines = mines
    self.board = {}
    self:reset()
end

function GameBoard:reset()
    self.board = {}
    self.board = zerosBoard(self.rows, self.cols)

    for mine = 1, self.mines do
        local i = math.random(self.rows)
        local j = math.random(self.cols)

        while board[i][j] == 1 do
            i = math.random(self.rows)
            j = math.random(self.cols)
        end

        board[i][j] = 1
    end
end
