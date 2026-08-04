-- media/lua/server/escape_routes.lua
-- Définition des routes d'évasion de l'île (liées aux quêtes).
-- Phase 2/3 — Quêtes & environnement (à implémenter).
local EscapeRoutes = {}

-- Tableau des 15+ routes d'évasion (exemples inspirés du README).
EscapeRoutes.list = {
    { id = "harbor_boat", name = "Bateau du port",         locked = true,  team = nil },
    { id = "radio_tower", name = "Tour de radio",          locked = true,  team = nil },
    { id = "cave_tunnel", name = "Tunnel de la grotte",    locked = true,  team = "Alpha" },
    { id = "helico_pad",  name = "Helicoptere du helipad", locked = true,  team = nil },
    { id = "underwater",  name = "Passage sous-marin",     locked = true,  team = "Gamma" },
}

-- Retourne les routes exploitables par une équipe donnée.
function EscapeRoutes.getAvailableForTeam(teamName)
    local result = {}
    for _, route in ipairs(EscapeRoutes.list) do
        if not route.locked and (route.team == nil or route.team == teamName) then
            table.insert(result, route)
        end
    end
    return result
end

return EscapeRoutes
