package.path = package.path .. ";../?.lua;../?/init.lua"

local Permadeath   = require "media/lua/server/permadeath"
local QuestManager = require "media/lua/server/quest_manager"
local EscapeRoutes = require "media/lua/server/escape_routes"

local pass = true
local function check(cond, msg)
    if not cond then print("ECHEC : " .. msg); pass = false end
end

-- 1) Route bloquee tant qu'elle est verrouillee
local ok, reason = EscapeRoutes.canUseRoute("Alpha", "harbor_boat")
check(ok == false, "harbor_boat bloquee tant qu'elle est locked")
check(reason == "verrouillee", "raison = verrouillee")

-- 2) Deverrouillee mais sans prerequisites -> toujours bloquee
EscapeRoutes.unlockRoute("harbor_boat")
ok = EscapeRoutes.canUseRoute("Alpha", "harbor_boat")
check(ok == false, "harbor_boat bloquee sans prerequisites")

-- 3) Avec tous les prerequisites -> OK (Alpha n'a aucune restriction team)
QuestManager.setFlag("generator_on", true)
ok = EscapeRoutes.canUseRoute("Alpha", "harbor_boat")
check(ok == false, "harbor_boat bloquee: manque radio_scanned")
QuestManager.setFlag("radio_scanned", true)
ok = EscapeRoutes.canUseRoute("Alpha", "harbor_boat")
check(ok == true, "harbor_boat OK avec tous les prerequisites")

-- 4) Fin HUMAINE : l'equipe Alpha s'evade
Permadeath.reset()
Permadeath.registerPlayer("Alice", "Alpha", "Alice")
local escaped = Permadeath.tryEscape("Alpha", "harbor_boat")
check(escaped == true, "evasion reussie -> fin humaine")
check(Permadeath.checkEndgame() == "human_win", "fin H : evasion reussie")

-- 5) Evasion echouee sans prerequisites -> pas de fin
Permadeath.reset()
QuestManager.clearFlags()
Permadeath.registerPlayer("Bob", "Alpha", "Bob")
local ok2 = Permadeath.tryEscape("Alpha", "harbor_boat")
check(ok2 == false, "evasion echouee sans prerequisites")
check(Permadeath.checkEndgame() == nil, "pas de fin si evasion echouee")

-- 6) Fin ZOMBIE : plus de humain vivant
Permadeath.registerPlayer("Charlie", "Alpha", "Charlie")
Permadeath.onDeath("Bob");      Permadeath.onDeath("Bob")      -- alive->zombie->dead
Permadeath.onDeath("Charlie");  Permadeath.onDeath("Charlie")  -- alive->zombie->dead
check(Permadeath.aliveCount() == 0, "aucun humain vivant")
check(Permadeath.checkEndgame() == "zombie_win", "fin Z : plus de humain vivant")

if pass then
    print("[test_endgame] ✅ TOUS LES ASSERTS PASSENT")
else
    print("[test_endgame] ❌ DES ASSERTS ONT ÉCHOUÉ")
    os.exit(1)
end
