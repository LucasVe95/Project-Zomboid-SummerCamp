-- media/lua/server/permadeath.lua
-- Système de mort / reanimation "Z" et fins de partie.
-- Phase 1 — Permideath & conditions de victoire.
-- NOTE : aucune API Project Zomboid dans ce module → testable avec lua standard.
local Teams       = require "media/lua/shared/teams"
local SpawnPoints = require "media/lua/shared/spawn_points"
local EscapeRoutes = require "media/lua/server/escape_routes"
local QuestManager = require "media/lua/server/quest_manager"

local Permadeath = {}

-- Registre serveur : [name] = { team, character, side, corpse, x,y,z, abilities, lastSignal }
Permadeath.players = {}
Permadeath.escapedTeam = nil
Permadeath.minSurvivorsPerTeam = 2
Permadeath.signalCooldown = 30  -- secondes entre deux signaux Z (hors-jeu on passe now=0/60)

-- Inscrit un joueur (appelé juste après l'assignation d'equipe).
function Permadeath.registerPlayer(playerName, teamName, character)
    local spawn = SpawnPoints.getForTeam(teamName)
    Permadeath.players[playerName] = {
        team = teamName,
        character = character,
        side = "alive",
        corpse = nil,
        x = spawn.x, y = spawn.y, z = spawn.z,
        abilities = nil,
        lastSignal = 0,
    }
end

function Permadeath.getSide(playerName)
    local p = Permadeath.players[playerName]
    return p and p.side
end

function Permadeath.getPlayer(playerName)
    return Permadeath.players[playerName]
end

-- Comptes rapides
function Permadeath.aliveCount()
    local n = 0
    for _, p in pairs(Permadeath.players) do if p.side == "alive" then n = n + 1 end end
    return n
end

function Permadeath.zombieCount()
    local n = 0
    for _, p in pairs(Permadeath.players) do if p.side == "zombie" then n = n + 1 end end
    return n
end

function Permadeath.deadCount()
    local n = 0
    for _, p in pairs(Permadeath.players) do if p.side == "dead" then n = n + 1 end end
    return n
end

function Permadeath.livingInTeam(teamName)
    local n = 0
    for _, p in pairs(Permadeath.players) do
        if p.team == teamName and p.side == "alive" then n = n + 1 end
    end
    return n
end

-- A la mort d'un joueur :
--  - un humain vivant -> cadavre sur place + reanimation en Z (zone Z)
--  - un Z touche par un humain -> elimination definitive (permadeath)
function Permadeath.onDeath(playerName)
    local p = Permadeath.players[playerName]
    if not p then return end

    if p.side == "alive" then
        p.corpse = { x = p.x, y = p.y, z = p.z }  -- le cadavre reste sur le lieu de mort
        print("[Permadeath] " .. playerName .. " est mort — cadavre laisse sur place.")
        Permadeath.becomeZombie(playerName)
    elseif p.side == "zombie" then
        Permadeath.killZombie(playerName)
    end
end

-- Reanimation en zombie dans la zone Z (corps rejoue, cadavre resté en place)
function Permadeath.becomeZombie(playerName)
    local p = Permadeath.players[playerName]
    if not p or p.side ~= "alive" then return false end

    local z = SpawnPoints.getZombieZone()
    p.x, p.y, p.z = z.x, z.y, z.z
    p.side = "zombie"
    p.abilities = SpawnPoints.getZombieAbilities()
    print("[Permadeath] " .. playerName .. " reanimé en Z (" .. tostring(z.name) .. ").")
    return true
end

-- Un zombie elimine par un humain -> sortie definitative du joueur
function Permadeath.killZombie(playerName)
    local p = Permadeath.players[playerName]
    if not p or p.side ~= "zombie" then return false end

    p.side = "dead"
    print("[Permadeath] " .. playerName .. " (Z) elimine definitivement par un humain.")
    return true
end

-- Capacite speciale Z : envoyer un signal indirect aux humains (ex: indice).
-- Restreint aux Z ; cooldown configurable.
function Permadeath.sendSignal(playerName, clue, now)
    local p = Permadeath.players[playerName]
    if not p or p.side ~= "zombie" then return false end

    now = now or 0
    if p.lastSignal > 0 and (now - p.lastSignal) < Permadeath.signalCooldown then
        return false  -- cooldown
    end
    p.lastSignal = now
    print("[Z Signal] " .. playerName .. " -> indice pour les humains : " .. tostring(clue))
    return true
end

-- Tentative d'evasion : une equipe tente d'utiliser une route.
-- (bool, reason). En cas de succes, la team est marquee comme echappee -> fin humaine.
function Permadeath.tryEscape(teamName, routeId)
    local ok, reason = EscapeRoutes.canUseRoute(teamName, routeId)
    if not ok then
        print("[Permadeath] Evasion de " .. teamName .. " bloquee : " .. tostring(reason))
        return false, reason
    end
    Permadeath.escapedTeam = teamName
    print("[Permadeath] Equipe " .. teamName .. " s'evade via " .. routeId .. " -> VICTOIRE HUMAINE.")
    return true, "escaped"
end

-- Determine la fin de partie, le cas echeant.
--  - "human_win" : une equipe s'est evacuee.
--  - "zombie_win" : il ne reste plus aucun humain vivant.
--  - nil : la partie continue.
function Permadeath.checkEndgame()
    if Permadeath.escapedTeam then
        return "human_win"
    end
    if Permadeath.aliveCount() <= 0 then
        return "zombie_win"
    end
    return nil
end

-- Reinitialise l'etat (utile entre parties / tests)
function Permadeath.reset()
    Permadeath.players = {}
    Permadeath.escapedTeam = nil
end

return Permadeath
