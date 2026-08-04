-- media/lua/server/quest_manager.lua
-- Gestion du cycle de vie des quêtes / objectifs secrets.
-- Phase 2 — Quêtes & objectifs secrets (à implémenter).
local QuestManager = {}

QuestManager.activeQuests = {}

-- Attribue un objectif secret à un joueur à la connexion.
function QuestManager.assignSecretObjective(playerName)
    -- TODO: choisir via la table d'objectifs (coop / sabotage / assassin / survie).
    local objective = {
        type = "cooperate", -- coop | sabotage | assassin | survivor
        target = nil,
        description = "Aidez votre équipe à survivre.",
        completed = false,
    }
    QuestManager.activeQuests[playerName] = objective
    return objective
end

function QuestManager.isCompleted(playerName)
    local q = QuestManager.activeQuests[playerName]
    return q and q.completed
end

function QuestManager.complete(playerName)
    local q = QuestManager.activeQuests[playerName]
    if q then q.completed = true end
end

return QuestManager
