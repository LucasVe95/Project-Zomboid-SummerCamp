local MP = require "core/player_multijoueur"

-- Liste des joueurs qui se connectent
local players = {
    {name = "AliceJ", choice = "Alice"},
    {name = "BobJ", choice = "random"},
    {name = "CharlieJ", choice = "Kevin"},
    {name = "DianaJ", choice = "random"},
    {name = "EthanJ", choice = "Fiona"},
    {name = "FionaJ", choice = "random"},
    {name = "GeorgeJ", choice = "George"},
    {name = "HannahJ", choice = "random"},
    {name = "IanJ", choice = "Ian"},
    {name = "JuliaJ", choice = "Julia"},
    {name = "KevinJ", choice = "random"},
    {name = "LauraJ", choice = "Laura"},
    {name = "MikeJ", choice = "random"},
    {name = "NinaJ", choice = "Nina"},
    {name = "OscarJ", choice = "Oscar"}
}

-- Boucle pour simuler la connexion des joueurs
for _, p in ipairs(players) do
    MP.onPlayerJoin(p.name, p.choice)
end

-- Affiche le statut final des équipes
MP.printStatus()
-- Test de la gestion multijoueur avec sélection des persos et équipes