function zerosBoard(rows, cols)
    board = {}

    for i = 1, rows do
        local row = {}
        for j = 1, cols do
            row[#row + 1] = 0
        end
        board[#board + 1] = row
    end

    return board
end

function GenerateQuads(atlas, tileWidth, tileHeight)
    local sheetWidth = atlas:getWidth() / tileWidth
    local sheetHeight = atlas:getHeight() / tileHeight

    local spriteSheets = {}
    local counter = 1

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spriteSheets[counter] = love.graphics.newQuad(x * tileWidth, y * tileHeight, tileWidth, tileHeight,
                atlas:getDimensions())
            counter = counter + 1
        end
    end

    return spriteSheets
end

function find(table, value)
    for k, val in pairs(table) do
        if val.i == value.i and val.j == value.j then
            return k
        end
    end
    return nil
end