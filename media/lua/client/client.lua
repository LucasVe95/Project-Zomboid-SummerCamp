-- media/lua/client/client.lua
-- Point d'entrée client du mod Summer Camp Survival.
print("Summer Camp Survival - Client Mod Loaded!")

local UISelection = require "media/lua/client/ui_selection"

-- Ouvre l'interface de sélection dès la connexion d'un joueur.
-- Project Zomboid : Events.OnConnect (ou OnCreatePlayer selon la version).
if Events then
    Events.OnConnect.Add(function(player)
        UISelection.show(player)
    end)
end
