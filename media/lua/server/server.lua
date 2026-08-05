-- media/lua/server/server.lua
-- Point d'entrée serveur du mod Summer Camp Survival.
print("Summer Camp Survival - Server Mod Loaded!")

local Multiplayer = require "media/lua/server/player_multijoueur"
local Permadeath  = require "media/lua/server/permadeath"
local Teams       = require "media/lua/shared/teams"

-- Enregistre un joueur dans le suivi de mort/perma juste après son assignation d'equipe.
local function registerPlayer(playerObj, character)
    if not playerObj or not playerObj.getUsername then return end
    local pname = playerObj:getUsername()
    local teamName = Teams.getTeamForCharacter(character)
    if teamName then
        Permadeath.registerPlayer(pname, teamName, character)
    end
end

if Events then
    -- A la connexion d'un joueur, on l'inscrit (connexion + perma).
    -- Le client envoie "joinGame" avec son choix de personnage.
    Events.OnClientCommand.Add(function(player, command, args)
        if command == "joinGame" then
            local choice = (args and args[1]) or "random"
            local character = Multiplayer.onPlayerJoin(player:getUsername(), choice)
            if character then
                registerPlayer(player, character)
            end
        end
    end)

    -- Mort d'un personnage -> reanimation en Z ou elimination definitive d'un Z.
    Events.OnCharacterDeath.Add(function(character)
        if character and character.getUsername then
            Permadeath.onDeath(character:getUsername())
        end
    end)
end

return Multiplayer
