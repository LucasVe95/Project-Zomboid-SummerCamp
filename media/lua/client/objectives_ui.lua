-- media/lua/client/objectives_ui.lua
-- HUD affichant les objectifs secrets du joueur et les objectifs d'équipe.
-- Phase 2/4 — Quêtes & UI (à implémenter).
local ObjectivesUI = {}

ObjectivesUI.currentObjective = nil

function ObjectivesUI.setObjective(objectiveText)
    ObjectivesUI.currentObjective = objectiveText
    print("[ObjectivesUI] Objectif : " .. tostring(objectiveText))
    -- TODO: dessiner le HUD via ISUI (Phase 4).
end

function ObjectivesUI.clear()
    ObjectivesUI.currentObjective = nil
end

return ObjectivesUI
