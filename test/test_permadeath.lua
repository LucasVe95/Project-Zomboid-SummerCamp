package.path = package.path .. ";../?.lua;../?/init.lua"

local Permadeath = require "media/lua/server/permadeath"

-- 6 joueurs de test repartis entre les equipes
Permadeath.reset()
Permadeath.registerPlayer("Alice",   "Alpha", "Alice")
Permadeath.registerPlayer("Bob",     "Alpha", "Bob")
Permadeath.registerPlayer("Charlie", "Alpha", "Charlie")
Permadeath.registerPlayer("Fiona",   "Bravo", "Fiona")
Permadeath.registerPlayer("George",  "Bravo", "George")
Permadeath.registerPlayer("Kevin",   "Gamma", "Kevin")

local pass = true
local function check(cond, msg)
    if not cond then print("ECHEC : " .. msg); pass = false end
end

-- 1) état initial
check(Permadeath.getSide("Alice")   == "alive", "Alice alive")
check(Permadeath.aliveCount()       == 6,       "6 vivants")
check(Permadeath.zombieCount()      == 0,       "0 zombie")
check(Permadeath.livingInTeam("Alpha") == 3,    "3 vivants Alpha")

-- 2) mort humaine -> zombie + cadavre laisse sur place
Permadeath.onDeath("Alice")
check(Permadeath.getSide("Alice")   == "zombie", "Alice zombie après mort")
local a = Permadeath.getPlayer("Alice")
check(a.corpse ~= nil,                "cadavre reste sur place")
check(Permadeath.livingInTeam("Alpha") == 2, "2 vivants Alpha après mort Alice")
check(Permadeath.zombieCount()        == 1,    "1 zombie")
check(Permadeath.checkEndgame()       == nil,  "pas de fin pour l'instant")

-- 3) zombie touche par un humain -> dead (permadeath définitive)
Permadeath.onDeath("Alice")
check(Permadeath.getSide("Alice")   == "dead", "Alice dead (Z éliminé)")
check(Permadeath.aliveCount()       == 5,      "5 vivants restants")
check(Permadeath.zombieCount()      == 0,      "0 zombie restant")

-- 4) capacité spéciale Z : signal indirect (cooldown)
Permadeath.becomeZombie("Bob")
check(Permadeath.getSide("Bob") == "zombie", "Bob zombie")
check(Permadeath.sendSignal("Bob",     "radio_ok", 100) == true,  "Z peut signaler")
check(Permadeath.sendSignal("Charlie", "x",        100) == false, "alive ne peut pas signaler")
check(Permadeath.sendSignal("Bob",     "again",    105) == false, "signal en cooldown refusé")
check(Permadeath.sendSignal("Bob",     "again",    200) == true,  "signal après cooldown OK")

-- 5) fin ZOMBIE : tuer tous les humains vivants (mort x2 = alive→zombie→dead)
for _, n in ipairs({ "Charlie", "Fiona", "George", "Kevin" }) do
    Permadeath.onDeath(n)
    Permadeath.onDeath(n)
end
check(Permadeath.aliveCount() == 0, "aucun humain vivant")
check(Permadeath.checkEndgame() == "zombie_win", "fin Z : plus de humain vivant")

if pass then
    print("[test_permadeath] ✅ TOUS LES ASSERTS PASSENT")
else
    print("[test_permadeath] ❌ DES ASSERTS ONT ÉCHOUÉ")
    os.exit(1)
end
