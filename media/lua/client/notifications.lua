-- media/lua/client/notifications.lua
-- Affichage des notifications en jeu (mort, trahison, événements...).
-- Phase 4 — UI & mode spectateur (à implémenter).
local Notifications = {}

-- Affiche une notification centrale à l'écran.
-- Exemple d'usage futur depuis le serveur via ISChat / popup.
function Notifications.show(message, isImportant)
    if not getCore() then
        print("[Notifications] " .. tostring(message))
        return
    end
    -- TODO: implémenter avec l'ISUI de Project Zomboid (popup / chat).
    print("NOTIFICATION : " .. tostring(message))
end

return Notifications
