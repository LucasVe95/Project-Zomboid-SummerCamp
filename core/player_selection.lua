PlayerSelection = {}

-- Les 15 persos
PlayerSelection.teams = {
    Alpha = {"Alice", "Bob", "Charlie", "Diana", "Ethan"},
    Bravo = {"Fiona", "George", "Hannah", "Ian", "Julia"},
    Charlie = {"Kevin", "Laura", "Mike", "Nina", "Oscar"}
}

-- Liste globale pour choisir librement
PlayerSelection.allCharacters = {}
for _, team in pairs(PlayerSelection.teams) do
    for _, char in ipairs(team) do
        table.insert(PlayerSelection.allCharacters, char)
    end
end

-- Persos déjà pris
PlayerSelection.takenCharacters = {}

-- Retourne les persos disponibles
function PlayerSelection.getAvailableCharacters()
    local available = {}
    for _, char in ipairs(PlayerSelection.allCharacters) do
        if not PlayerSelection.takenCharacters[char] then
            table.insert(available, char)
        end
    end
    return available
end

-- Choix libre ou aléatoire
function PlayerSelection.chooseCharacter(playerName, chosenCharacter)
    local available = PlayerSelection.getAvailableCharacters()
    local finalChoice = nil

    if chosenCharacter and chosenCharacter ~= "random" then
        for _, char in ipairs(available) do
            if char == chosenCharacter then
                finalChoice = chosenCharacter
                break
            end
        end
        if not finalChoice then return nil end
    else
        if #available == 0 then return nil end
        -- Use ZombRand if available (in-game), otherwise fall back to math.random (testing)
        local index
        if ZombRand then
            index = ZombRand(#available) + 1
        else
            index = math.random(1, #available)
        end
        finalChoice = available[index]
    end

    PlayerSelection.takenCharacters[finalChoice] = true
    return finalChoice
end

return PlayerSelection
