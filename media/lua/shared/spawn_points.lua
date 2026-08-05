-- media/lua/shared/spawn_points.lua
-- Points d'apparition des joueurs + zone de reanimation "Z" + capacites zombies.
-- Partagé : utilise par le serveur (mort/perma) et les donnees de base.
local SpawnPoints = {}

-- Points de spawn par equipe (3 equipes) + points neutres
SpawnPoints.teamSpawns = {
    Alpha = { x = 1200, y = 800,  z = 1 },
    Bravo = { x = 1500, y = 1100, z = 1 },
    Gamma = { x = 900,  y = 1300, z = 1 },
}

SpawnPoints.neutralSpawns = {
    { x = 1300, y = 950,  z = 1 },
    { x = 1100, y = 1200, z = 2 },
}

-- Zone Z : zone de reanimation des joueurs morts (devenus zombies).
-- Distincte du lieu de mort : le cadavre reste sur place, le corps rejoue ici.
SpawnPoints.zombieZone = { x = 1350, y = 975, z = 1, name = "Zone Z" }

-- Capacites speciales des zombies (reanimation)
SpawnPoints.zombieAbilities = {
    speedMultiplier  = 1.15,  -- +15% vitesse de deplacement
    clawAttack       = true,  -- attaque griffure melee
    nightVision      = true,  -- vision nocturne
    healthMultiplier = 0.7,   -- plus fragiles (un humain les tue plus vite)
    canSignal        = true,  -- capacite speciale : envoyer un signal indirect aux humains
}

function SpawnPoints.getForTeam(teamName)
    return SpawnPoints.teamSpawns[teamName] or SpawnPoints.neutralSpawns[1]
end

function SpawnPoints.getZombieZone()
    return SpawnPoints.zombieZone
end

function SpawnPoints.getZombieAbilities()
    return SpawnPoints.zombieAbilities
end

return SpawnPoints
