-- media/lua/server/player_multijoueur.lua
-- Gestion multijoueur serveur : suivi des connexions et assignation d'équipes.
-- Corrige le bug BUG-02 (code mort) et la duplication BUG-03 grâce à
-- PlayerAssignment.selectAndAssign (auto-confirmation, sans UI).
local PlayerAssignment = require "media/lua/shared/player_assignment"
local Teams = require "media/lua/shared/teams"

local Multiplayer = {}
Multiplayer.connectedPlayers = {}

-- Appelée quand un joueur rejoint (auto-confirmation, aucune UI ici).
-- choice : nom du perso choisi, "random" ou nil
function Multiplayer.onPlayerJoin(playerName, choice)
    -- selectAndAssign marque le perso, assigne l'équipe et retourne le perso choisi.
    local selectedCharacter = PlayerAssignment.selectAndAssign(playerName, choice)

    if not selectedCharacter then
        return
    end

    table.insert(Multiplayer.connectedPlayers, { name = playerName, character = selectedCharacter })
end

function Multiplayer.printStatus()
    Teams.printTeams()
end

return Multiplayer
