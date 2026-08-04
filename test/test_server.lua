package.path = package.path .. ";../?.lua;../?/init.lua"

local MP = require "media/lua/server/player_multijoueur"

-- NOTE : les choix "random" peuvent voler un personnage nommé demandé plus
-- tard dans la liste (ex: Nina/Oscar), auquel cas chooseCharacter renvoie nil
-- et le joueur n'est pas assigné. Comportement correct, mais le scénario n'est
-- donc pas déterministe. Voir docs/roadmap.md Phase 1 pour un assignation
-- robuste (re-pick aléatoire en cas d'échec).

-- Liste des 15 joueurs qui se connectent
local players = {
    { name = "AliceJ",   choice = "Alice"  },
    { name = "BobJ",     choice = "random" },
    { name = "CharlieJ", choice = "Kevin"  },
    { name = "DianaJ",   choice = "random" },
    { name = "EthanJ",   choice = "Fiona"  },
    { name = "FionaJ",   choice = "random" },
    { name = "GeorgeJ",  choice = "George"  },
    { name = "HannahJ",  choice = "random" },
    { name = "IanJ",     choice = "Ian"    },
    { name = "JuliaJ",   choice = "Julia"  },
    { name = "KevinJ",   choice = "random" },
    { name = "LauraJ",   choice = "Laura"  },
    { name = "MikeJ",    choice = "random" },
    { name = "NinaJ",    choice = "Nina"   },
    { name = "OscarJ",   choice = "Oscar"  },
}

-- Boucle pour simuler la connexion des 15 joueurs
for _, p in ipairs(players) do
    MP.onPlayerJoin(p.name, p.choice)
end

-- Affiche le statut final des équipes
MP.printStatus()
-- Test de la gestion multijoueur avec 15 joueurs + sélection des persos et équipes
