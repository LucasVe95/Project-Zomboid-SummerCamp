-- media/lua/server/interactive_objects.lua
-- Objets interactifs de l'île (barrières, verrous, générateurs, caches de butin).
-- Phase 3 — Environnement interactif (à implémenter).
local InteractiveObjects = {}

InteractiveObjects.objects = {
    { id = "generator",  type = "power",   state = "off",  location = { x = 1250, y = 980 } },
    { id = "gate_alpha", type = "barrier", state = "closed", location = { x = 1180, y = 820 } },
    { id = "supply_crate_survival", type = "loot", state = "full", location = { x = 1400, y = 1050 } },
    { id = "radio_scanner", type = "tool", state = "usable", location = { x = 950, y = 1330 } },
}

function InteractiveObjects.interact(id, action)
    for _, obj in ipairs(InteractiveObjects.objects) do
        if obj.id == id then
            print("[Objet] " .. id .. " : action '" .. tostring(action) .. "' — état : " .. obj.state)
            -- TODO: logique d'interaction concrète (ouver/fermer, activer, prendre).
            return obj
        end
    end
    return nil
end

return InteractiveObjects
