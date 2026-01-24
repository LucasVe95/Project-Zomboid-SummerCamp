package.path = package.path .. ";../?.lua;../?/init.lua"

local PS = require "core/player_selection"

-- Choix libre
PS.chooseCharacter("Joueur1", "Alice")

-- Choix aléatoire
PS.chooseCharacter("Joueur2", "random")

-- Assignation à une équipe
PS.assignToTeam("Joueur1", "Alpha")

-- Exemple pour afficher les équipes
for teamName, players in pairs(PS.teams) do
    print("Équipe " .. teamName .. " : ")
    for _, p in ipairs(players) do
        print(" - " .. p)
    end
end
