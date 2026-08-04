-- media/lua/server/zombie_horde.lua
-- Apparitions périodiques de hordes de zombies vers les zones clés.
-- Phase 3 — Événements dynamiques (à implémenter).
local ZombieHorde = {}

ZombieHorde.lastSpawn = 0
ZombieHorde.cooldown = 600 -- secondes entre hordes
ZombieHorde.hordeSize = { min = 10, max = 30 }

-- Liste des points ciblés par les hordes (à relier à map/spawn_points).
ZombieHorde.targets = { "camp_center", "radio_tower", "harbor", "player_base" }

function ZombieHorde.shouldSpawn(now)
    return (now - ZombieHorde.lastSpawn) >= ZombieHorde.cooldown
end

function ZombieHorde.spawnHorde(target)
    local size = ZombieHorde.hordeSize.min + math.random(0, ZombieHorde.hordeSize.max - ZombieHorde.hordeSize.min)
    ZombieHorde.lastSpawn = os.time()
    print("[ZombieHorde] Horde de " .. size .. " zombies attaque : " .. tostring(target))
    return { target = target, size = size }
end

return ZombieHorde
