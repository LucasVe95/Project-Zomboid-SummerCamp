-- media/lua/shared/player_assignment.lua
-- Logique partagée de sélection + assignation d'équipe.
-- Centralise le flow commun entre player_connect et player_multijoueur
-- afin d'éviter la duplication (BUG-03).
local PS = require "media/lua/shared/player_selection"
local Teams = require "media/lua/shared/teams"

local PlayerAssignment = {}

-- Sélectionne un personnage pour un joueur et l'assigne à son équipe.
--
-- playerName : nom du joueur connecté
-- choice     : nom du personnage choisi, ou "random" / nil
-- confirmFn  : (optionnel) callback(playerName, character) -> bool.
--              Si fourni, permet de demander confirmation à l'UI.
--              Si nil, la sélection est auto-confirmée (flux serveur simple).
--
-- Retourne le personnage choisi, ou nil en cas d'échec.
function PlayerAssignment.selectAndAssign(playerName, choice, confirmFn)
    local confirmed = false
    local selectedCharacter = nil

    while not confirmed do
        local available = PS.getAvailableCharacters()
        if #available == 0 then
            return nil
        end

        if choice == "random" or choice == nil then
            selectedCharacter = PS.chooseCharacter(playerName, "random")
        else
            selectedCharacter = PS.chooseCharacter(playerName, choice)
        end

        if not selectedCharacter then
            return nil
        end

        if confirmFn then
            confirmed = confirmFn(playerName, selectedCharacter)
        else
            confirmed = true -- auto-confirmation (remplacé par UI dans le vrai mod)
        end

        -- Annulation : le joueur a refusé → on remet le perso disponible
        if not confirmed then
            PS.takenCharacters[selectedCharacter] = nil
            choice = "random" -- re-sélection aléatoire au prochain tour
        end
    end

    Teams.assignPlayer(playerName, selectedCharacter)
    return selectedCharacter
end

return PlayerAssignment
