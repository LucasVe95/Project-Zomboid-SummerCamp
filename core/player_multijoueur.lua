local PS = require "core/player_selection"
local Teams = require "core/teams"

Multiplayer = {}
Multiplayer.connectedPlayers = {}

function Multiplayer.onPlayerJoin(playerName, choice)
    local confirmed = false
    local selectedCharacter = nil

    while not confirmed do
        local available = PS.getAvailableCharacters()
        if #available == 0 then return end

        if choice == "random" or choice == nil then
            selectedCharacter = PS.chooseCharacter(playerName, "random")
        else
            selectedCharacter = PS.chooseCharacter(playerName, choice)
        end

        if not selectedCharacter then return end

        confirmed = true -- remplacé par UI dans PZ
        if not confirmed then
            PS.takenCharacters[selectedCharacter] = nil
            choice = "random"
        end
    end

    Teams.assignPlayer(playerName, selectedCharacter)
    table.insert(Multiplayer.connectedPlayers, {name = playerName, character = selectedCharacter})
end

function Multiplayer.printStatus()
    Teams.printTeams()
end

return Multiplayer
