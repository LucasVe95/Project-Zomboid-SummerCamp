-- media/lua/server/server.lua
-- Point d'entrée serveur du mod Summer Camp Survival.
print("Summer Camp Survival - Server Mod Loaded!")

local Multiplayer = require "media/lua/server/player_multijoueur"

-- À la connexion d'un joueur, on l'inscrit dans le système multijoueur.
-- En contexte Project Zomboid, écoute une commande client (ex: "joinGame").
if Events then
    Events.OnClientCommand.Add(function(player, command, args)
        if command == "joinGame" then
            local choice = (args and args[1]) or "random"
            Multiplayer.onPlayerJoin(player:getUsername(), choice)
        end
    end)
end

return Multiplayer
