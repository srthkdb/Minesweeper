AI = Class{}

local di = {
    [1] = -1,
    [2] = -1,
    [3] = -1,
    [4] = 0,
    [5] = 0,
    [6] = 1,
    [7] = 1,
    [8] = 1
}

local dj = {
    [1] = -1,
    [2] = 0,
    [3] = 1,
    [4] = -1,
    [5] = 1,
    [6] = -1,
    [7] = 0,
    [8] = 1
}

function AI:init(rows, cols)
    self.rows = rows
    self.cols = cols

    -- # Keep track of which cells have been clicked on
    self.moves_made = {}

    -- # Keep track of cells known to be safe or mines
    self.mines = {}
    self.safes = {}

    self.knowledge = {}
end

function AI:mark_mine(tile)
    if find(self.mines, tile) == nil then
        table.insert(self.mines, tile)
        print("marking mine ("..tostring(tile.i)..", "..tostring(tile.j)..")")
        for _, sentence in pairs(self.knowledge) do
            sentence:mark_mine(tile)
        end
    end
end

function AI:mark_safe(tile)
    if find(self.safes, tile) == nil then
        table.insert(self.safes, tile)
        print("self.safes size = "..tostring(#self.safes))
        print("marking safe ("..tostring(tile.i)..", "..tostring(tile.j)..")")
        for _, sentence in pairs(self.knowledge) do
            sentence:mark_safe(tile)
        end
    end
end

function AI:inRange(i, j)
    local a = (i > 0) and (i <= self.rows) and (j > 0) and (j <= self.cols)
    return a
end

function AI:add_knowledge(tile, count, board)
    -- Called when the Minesweeper board tells us, for a given
    -- safe cell, how many neighboring cells have mines in them.

    -- This function should:
    --     1) mark the cell as a move that has been made
    --     2) mark the cell as safe
    --     3) add a new sentence to the AI's knowledge base
    --        based on the value of `cell` and `count`
    --     4) mark any additional cells as safe or as mines
    --        if it can be concluded based on the AI's knowledge base
    --     5) add any new sentences to the AI's knowledge base
    --        if they can be inferred from existing knowledge

    -- for i = 1, self.rows do 
    --     for j = 1, self.cols do
    --         if board.board[i][j].code == 1 then
    --             --add all open sites to self.moves_made
    --             self.moves_made[board.board[i][j]] = true
    --             if not self.safes[board.board[i][j]] then 
                    
    --                 self:mark_safe(board.board[i][j])
    --             end
    --         end
    --     end
    -- end
    table.insert(self.moves_made, tile)
    self:mark_safe(tile)

    local tiles = {}
    -- if count > 0 then
        for k = 1, 8 do
            --find an adjacent tile
            local i = tile.i + di[k]
            local j = tile.j + dj[k]
            if self:inRange(i, j) and (board.board[i][j].code == 0 or board.board[i][j].code == -2) then
                --if the adjacent tile to given tile is not yet open then
                --if tile is already known to be safe, don't add it to the knowledge
                local k = find(self.safes, {i = i, j = j})
                if k == nil then
                    --if tile is already known to be mine, don't add it to the knowledge and subtract count by 1
                    k = find(self.mines, { i = i, j = j})
                    if k ~= nil then
                        count = count - 1
                    else
                        table.insert(tiles, { i = i, j = j})
                    end
                end
            end
        end
        print("adding to knowledge sentence ")
        local sentence = Sentence(tiles, count)
        sentence:print()
        table.insert(self.knowledge, sentence)
        print("knowledge size = "..tostring(#self.knowledge))
    -- end

    local do_again = true

    --new mines and safes which can be concluded after addition of thie new knowledge
    while do_again do
        do_again = false
        for _, sentence in pairs(self.knowledge) do 
            local new_mines = sentence:known_mines()
            local new_safes = sentence:known_safes()

            if new_mines ~= nil and #new_mines > 0 then
                for _, mine in pairs(new_mines) do
                    if find(self.mines, mine) == nil then
                        self:mark_mine(mine)
                        do_again = true
                    end
                end
            end

            if new_safes ~= nil and #new_safes > 0 then
                for _, safe in pairs(new_safes) do
                    if find(self.safes, safe) == nil then
                        self:mark_safe(safe)
                        do_again = true
                    end
                end
            end
        end
    end
    --new sentences which can be inferred after addition of this sentence
end

function AI:make_safe_move()
    print("safes size"..tostring(#self.safes))
    for _, tile in pairs(self.safes) do
        if find(self.moves_made, tile) == nil then
            print("making safe move")
            return tile
        end
    end
    return nil
end

function AI:make_random_move(board)
    print("making random move")
    local i = math.random(self.rows)
    local j = math.random(self.cols)

    while find(self.moves_made, {i = i, j = j}) ~= nil or find(self.mines, {i = i, j = j}) ~= nil do
        i = math.random(self.rows)
        j = math.random(self.cols)
    end
    if #self.mines == 0 then
        print("self.mines is empty")
    end
        return {i = i, j = j}
end

function AI:mark_mines(board)
    for _, mine in pairs(self.mines) do
        if board.board[mine.i][mine.j].code == 0 then
            board.board[mine.i][mine.j].code = -2
        end
    end
end