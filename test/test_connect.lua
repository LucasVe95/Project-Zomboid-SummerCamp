package.path = package.path .. ";../?.lua;../?/init.lua"
local Connect = require "media/lua/server/player_connect"

-- Joueurs qui se connectent avec choix libre ou aléatoire
Connect.onPlayerJoin("Joueur1", "Alice")    -- Choix libre
Connect.onPlayerJoin("Joueur2", "random")   -- Choix aléatoire
Connect.onPlayerJoin("Joueur3", "Kevin")    -- Choix libre
Connect.onPlayerJoin("Joueur4", "random")

-- Affiche le statut final des équipes
Connect.printStatus()
