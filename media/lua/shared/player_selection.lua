-- media/lua/shared/player_selection.lua
-- Sélection de personnage : 15 persos répartis en 3 équipes.
-- Mode libre (nom) ou aléatoire. Suit les persos déjà pris.
local PlayerSelection = {}

PlayerSelection.teams = {
    Alpha = { "Alice", "Bob", "Charlie", "Diana", "Ethan" },
    Bravo = { "Fiona", "George", "Hannah", "Ian", "Julia" },
    Gamma = { "Kevin", "Laura", "Mike", "Nina", "Oscar" },
}

-- Liste plate de tous les personnages, pour la sélection libre
PlayerSelection.allCharacters = {}
for _, team in pairs(PlayerSelection.teams) do
    for _, char in ipairs(team) do
        table.insert(PlayerSelection.allCharacters, char)
    end
end

-- Personnages déjà pris (éviter les doublons)
PlayerSelection.takenCharacters = {}

-- Retourne les personnages encore disponibles.
function PlayerSelection.getAvailableCharacters()
    local available = {}
    for _, char in ipairs(PlayerSelection.allCharacters) do
        if not PlayerSelection.takenCharacters[char] then
            table.insert(available, char)
        end
    end
    return available
end

-- Choix libre (nom) ou aléatoire ("random").
-- Utilise ZombRand dans le jeu, math.random en fallback (tests).
-- Marque le perso comme pris et le retourne, ou nil si impossible.
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
