-- media/lua/client/selection_ui.lua
-- UI de sélection en contexte de lobby (infos perso, rôle, équipe).
-- Phase 4 — UI enrichie (à implémenter).
local SelectionUI = {}

function SelectionUI.showPlayerInfo(playerObj, characterName, teamName, role)
    print("[SelectionUI] " .. tostring(playerObj) .. " | perso: " .. tostring(characterName)
          .. " | équipe: " .. tostring(teamName) .. " | rôle: " .. tostring(role))
    -- TODO: afficher une carte du personnage dans le lobby (Phase 4).
end

return SelectionUI
