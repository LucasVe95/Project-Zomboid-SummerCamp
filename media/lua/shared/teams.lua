-- media/lua/shared/teams.lua
-- Gestion des équipes thématiques et de leur appartenance.
-- Partagé : données communes à client et serveur.
local Teams = {}

-- Les 3 équipes thématiques, chacune avec 5 personnages (15 total)
Teams.list = {
    Alpha  = { "Alice", "Bob", "Charlie", "Diana", "Ethan" },
    Bravo  = { "Fiona", "George", "Hannah", "Ian", "Julia" },
    Gamma  = { "Kevin", "Laura", "Mike", "Nina", "Oscar" },
}

-- Mapping dynamique : nom du joueur (PZ) → nom du personnage
Teams.playerTeams = {}

-- Retourne le nom de l'équipe à laquelle appartient un personnage.
function Teams.getTeamForCharacter(characterName)
    for teamName, characters in pairs(Teams.list) do
        for _, char in ipairs(characters) do
            if char == characterName then
                return teamName
            end
        end
    end
    return nil
end

-- Assigne un joueur (nom PZ) à l'équipe de son personnage.
function Teams.assignPlayer(playerName, characterName)
    local teamName = Teams.getTeamForCharacter(characterName)
    if not teamName then return end

    if not Teams.playerTeams[teamName] then
        Teams.playerTeams[teamName] = {}
    end

    table.insert(Teams.playerTeams[teamName], playerName)
end

-- Affiche l'état actuel des équipes (debug)
function Teams.printTeams()
    for teamName, players in pairs(Teams.playerTeams) do
        print("Équipe " .. teamName .. " :")
        for _, p in ipairs(players) do
            print(" - " .. p)
        end
    end
end

return Teams
