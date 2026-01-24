-- Gestion de la sélection des personnages
PlayerSelection = {}

-- Liste complète des 15 personnages
PlayerSelection.characters = {
    "Alice", "Bob", "Charlie", "Diana", "Ethan",
    "Fiona", "George", "Hannah", "Ian", "Julia",
    "Kevin", "Laura", "Mike", "Nina", "Oscar"
}

-- Tableau pour suivre les personnages déjà choisis
PlayerSelection.takenCharacters = {}

-- Liste des équipes
PlayerSelection.teams = {
    Alpha = {},
    Bravo = {},
    Charlie = {}
}

-- Fonction pour obtenir les personnages restants
function PlayerSelection.getAvailableCharacters()
    local available = {}
    for _, char in ipairs(PlayerSelection.characters) do
        if not PlayerSelection.takenCharacters[char] then
            table.insert(available, char)
        end
    end
    return available
end

-- Fonction pour choisir un personnage (libre ou aléatoire)
function PlayerSelection.chooseCharacter(playerName, chosenCharacter)
    local available = PlayerSelection.getAvailableCharacters()

    local finalChoice = nil

    if chosenCharacter and chosenCharacter ~= "random" then
        -- Vérifie si le perso choisi est disponible
        local isAvailable = false
        for _, char in ipairs(available) do
            if char == chosenCharacter then
                isAvailable = true
                break
            end
        end

        if isAvailable then
            finalChoice = chosenCharacter
        else
            print("Personnage déjà pris : " .. chosenCharacter)
            return nil
        end
    else
        -- Choix aléatoire parmi les persos restants
        if #available == 0 then
            print("Plus aucun personnage disponible !")
            return nil
        end
        local index = math.random(1, #available)
        finalChoice = available[index]
    end

    -- Marque le personnage comme pris
    PlayerSelection.takenCharacters[finalChoice] = true
    print(playerName .. " a choisi le personnage : " .. finalChoice)
    return finalChoice
end

-- Exemple de distribution dans les équipes
function PlayerSelection.assignToTeam(playerName, teamName)
    if PlayerSelection.teams[teamName] then
        table.insert(PlayerSelection.teams[teamName], playerName)
        print(playerName .. " a ete ajoute à l'equipe " .. teamName)
    else
        print("equipe inexistante : " .. teamName)
    end
end

return PlayerSelection
