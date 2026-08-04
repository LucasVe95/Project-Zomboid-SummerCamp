-- media/lua/server/spawn_points.lua
-- Points d'apparition des joueurs, équitablement répartis sur l'île.
-- Phase 3 — Carte & environnement (à implémenter).
local SpawnPoints = {}

-- Un point de spawn par équipe (3) + points neutres (marche côtière, etc.)
SpawnPoints.teamSpawns = {
    Alpha = { x = 1200, y = 800,  z = 1 },
    Bravo = { x = 1500, y = 1100, z = 1 },
    Gamma = { x = 900,  y = 1300, z = 1 },
}

SpawnPoints.neutralSpawns = {
    { x = 1300, y = 950,  z = 1 },
    { x = 1100, y = 1200, z = 2 },
}

function SpawnPoints.getForTeam(teamName)
    return SpawnPoints.teamSpawns[teamName] or SpawnPoints.neutralSpawns[1]
end

return SpawnPoints
