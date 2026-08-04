-- media/lua/server/drama_events.lua
-- Événements scénarisés (coupure de radio, fuite d'eau, panne d'électricité...).
-- Phase 3 — Événements dramatiques (à implémenter).
local DramaEvents = {}

DramaEvents.active = {}

DramaEvents.events = {
    { id = "radio_silence",     desc = "Coupure de la radio — les équipes ne peuvent plus communiquer.",    duration = 300 },
    { id = "water_leak",        desc = "Fuite d'eau dans le réservoir — moins de ressources potables.",      duration = 240 },
    { id = "power_outage",      desc = "Panne d'électricité générale — les lumières s'éteignent.",           duration = 360 },
    { id = "supply_drop_good",  desc = "Livraison d'urgence — des fournitures apparaissent sur l'île.",       duration = 600 },
}

function DramaEvents.trigger(id)
    local ev = nil
    for _, e in ipairs(DramaEvents.events) do
        if e.id == id then ev = e; break end
    end
    if not ev then return end
    DramaEvents.active[ev.id] = { event = ev, started = os.time() }
    print("[Drama] Événement déclenché : " .. ev.desc)
    return ev
end

function DramaEvents.random()
    local id = DramaEvents.events[math.random(#DramaEvents.events)].id
    return DramaEvents.trigger(id)
end

return DramaEvents
