-- media/lua/server/weather.lua
-- Gestion dynamique de la météo (orage, brouillard, canicule...).
-- Phase 3 — Événements & environnement (à implémenter).
local Weather = {}

Weather.current = "clear"

Weather.presets = {
    clear    = { visibility = 1.0, danger = 0.0 },
    fog      = { visibility = 0.3, danger = 0.2 },
    storm    = { visibility = 0.6, danger = 0.5 },
    heatwave = { visibility = 0.9, danger = 0.4 },
}

function Weather.set(presetName)
    if Weather.presets[presetName] then
        Weather.current = presetName
        print("[Weather] Conditions changées : " .. presetName)
    end
end

function Weather.cycle()
    -- TODO: planifier des changements de météo périodiques (Phase 3).
    local keys = {}
    for k in pairs(Weather.presets) do table.insert(keys, k) end
    Weather.set(keys[math.random(#keys)])
end

return Weather
