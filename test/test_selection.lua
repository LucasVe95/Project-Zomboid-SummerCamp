package.path = package.path .. ";../?.lua;../?/init.lua"

local PS = require "media/lua/shared/player_selection"
local Teams = require "media/lua/shared/teams"

-- Joueur choisit un perso
local perso = PS.chooseCharacter("Joueur1", "Alice")
Teams.assignPlayer("Joueur1", perso)

local perso2 = PS.chooseCharacter("Joueur2", "random")
Teams.assignPlayer("Joueur2", perso2)

Teams.printTeams()
-- Test de la selection + assignation d'équipe
