-- media/lua/server/escape_routes.lua
-- Definition des routes d'evasion de l'ile (liées aux quêtes).
-- Phase 2/3 — Environnement. Chaque route a des prerequisites a satisfaire.
local QuestManager = require "media/lua/server/quest_manager"

local EscapeRoutes = {}

-- Tableau des routes d'evasion avec leurs prerequisites (ex: activer le générateur).
EscapeRoutes.list = {
    { id = "harbor_boat",   name = "Bateau du port",           locked = true, team = nil,
      prerequisites = { "generator_on", "radio_scanned" } },
    { id = "radio_tower",   name = "Tour de radio",            locked = true, team = nil,
      prerequisites = { "tower_key" } },
    { id = "cave_tunnel",   name = "Tunnel de la grotte",      locked = true, team = "Alpha",
      prerequisites = { "pickaxe" } },
    { id = "helico_pad",    name = "Helicoptere du helipad",   locked = true, team = nil,
      prerequisites = { "rotor_blade", "fuel" } },
    { id = "underwater",    name = "Passage sous-marin",       locked = true, team = "Gamma",
      prerequisites = { "oxygen_tank", "diving_gear" } },
}

-- Retourne une route par id.
function EscapeRoutes.get(routeId)
    for _, route in ipairs(EscapeRoutes.list) do
        if route.id == routeId then return route end
    end
    return nil
end

-- Retourne les routes exploitables par une equipe donnee (deverrouillees, prêts).
function EscapeRoutes.getAvailableForTeam(teamName)
    local result = {}
    for _, route in ipairs(EscapeRoutes.list) do
        if not route.locked and (route.team == nil or route.team == teamName) then
            table.insert(result, route)
        end
    end
    return result
end

-- Deverrouille une route (ex: apres validation d'un objectif).
function EscapeRoutes.unlockRoute(routeId)
    local route = EscapeRoutes.get(routeId)
    if route then route.locked = false end
end

-- Verifie si une equipe peut utiliser une route.
-- flags : (optionnel) table des conditions remplies ; defaut = QuestManager.worldFlags.
-- Retourne (bool, reason).
function EscapeRoutes.canUseRoute(teamName, routeId, flags)
    flags = flags or QuestManager.worldFlags
    local route = EscapeRoutes.get(routeId)
    if not route then return false, "route_inconnue" end
    if route.locked then return false, "verrouillee" end
    if route.team and route.team ~= teamName then return false, "team_incompatible" end
    for _, pre in ipairs(route.prerequisites or {}) do
        if not flags[pre] then return false, "prerequis:" .. pre end
    end
    return true, "ok"
end

return EscapeRoutes
