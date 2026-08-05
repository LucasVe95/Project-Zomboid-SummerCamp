-- media/lua/server/player_connect.lua
-- Gestion de la connexion des joueurs et de la sélection des persos.
-- Utilise le module partagé PlayerAssignment (déduplication BUG-03).
local PlayerAssignment = require "media/lua/shared/player_assignment"
local Teams = require "media/lua/shared/teams"

local PlayerConnect = {}

-- Confimation simulée (à remplacer par une vraie UI dans Project Zomboid).
-- Retourne true pour confirmer, false pour re-sélectionner.
-- Exemple : dans PZ tu remplacerais par une vraie interaction UI client/serveur.
local function simulateConfirmation(playerName, character)
    print(playerName .. " choisi le personnage : " .. character)
    print("Confirmez votre choix ? (true = oui, false = non)")
    return true -- pour les tests : confirmation automatique
end

-- Appelée quand un joueur rejoint le serveur.
-- playerName : nom du joueur
-- choice     : nom du perso choisi ou "random" pour aléatoire
function PlayerConnect.onPlayerJoin(playerName, choice)
    print("\n=== Nouveau joueur connecté : " .. playerName .. " ===")

    local selectedCharacter = PlayerAssignment.selectAndAssign(playerName, choice, simulateConfirmation)

    if not selectedCharacter then
        print("Erreur : aucun personnage disponible ou choix invalide.")
        return
    end

    print(playerName .. " est prêt à jouer avec le personnage " .. selectedCharacter)
    return selectedCharacter
end

-- Affiche le statut actuel des équipes
function PlayerConnect.printStatus()
    print("\n=== Statut des équipes ===")
    Teams.printTeams()
end

return PlayerConnect