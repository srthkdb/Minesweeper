Sentence = Class{}

function Sentence:init(tiles, count)
    self.tiles = tiles
    self.count = count
end

function Sentence:print()
    print("{ tiles = ")
    for key, k in pairs(self.tiles) do
        print("( x = "..tostring(k.i)..", y = "..tostring(k.j).." )")
    end
    print(", count = "..tostring(self.count).." }")
end

function Sentence:equal(other)
    return self.tiles.j == other.tiles.j and self.tiles.i == other.tiles.i and self.count == other.count
end

function Sentence:known_mines()
    if #self.tiles == self.count then
        return self.tiles
    end
end

function Sentence:known_safes()
    if self.count == 0 then
        return self.tiles
    end
end

function Sentence:mark_mine(tile)
    local k = find(self.tiles, tile)
    if k ~= nil then
        table.remove(self.tiles, k)
        self.count = self.count - 1
    end
end

function Sentence:mark_safe(tile)
    local k = find(self.tiles, tile)
    if k ~= nil then
        table.remove(self.tiles, k)
    end
end

