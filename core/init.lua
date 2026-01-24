-- core/init.lua

print("Summer Camp Survival Mod Loaded!")

local PS = require "core/player_selection"
local Teams = require "core/teams"
local Multiplayer = require "core/player_multijoueur"
local UISelection = require "core/ui_selection"

-- Ouvre automatiquement la sélection UI à la connexion d’un joueur
Events.OnConnect.Add(function(player)
    UISelection.show(player)
end)
