-- media/lua/server/quest_manager.lua
-- Gestion des objectifs secrets + etat du monde (prerequisites globalaux).
-- Phase 2 — Quêtes. Phase 1/3 — worldFlags pour les routes d'evasion.
local QuestManager = {}

QuestManager.activeQuests = {}
QuestManager.worldFlags = {}   -- ex: generator_on=true, radio_scanned=true

-- === World flags (conditions globales du monde) ===
function QuestManager.setFlag(flag, value)
    QuestManager.worldFlags[flag] = (value ~= false)
end

function QuestManager.hasFlag(flag)
    return QuestManager.worldFlags[flag] == true
end

function QuestManager.clearFlags()
    for k in pairs(QuestManager.worldFlags) do QuestManager.worldFlags[k] = nil end
end

-- === Objectifs secrets (Phase 2) ===
QuestManager.objectiveTypes = { "cooperate", "sabotage", "assassin", "survivor" }

function QuestManager.assignSecretObjective(playerName)
    local otype = QuestManager.objectiveTypes[math.random(#QuestManager.objectiveTypes)]
    local objective = {
        type = otype,
        target = nil,
        description = QuestManager.describe(otype),
        completed = false,
    }
    QuestManager.activeQuests[playerName] = objective
    return objective
end

function QuestManager.describe(otype)
    local t = {
        cooperate = "Aidez votre equipe a survivre.",
        sabotage  = "Faites echouer les objectifs de votre equipe.",
        assassin  = "Eliminez le joueur cible.",
        survivor  = "Survivez seul, sans allié.",
    }
    return t[otype]
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
