local MP = require "core/player_multijoueur"

-- Simulation de connexion des joueurs
MP.onPlayerJoin("Joueur1", "Alice")
MP.onPlayerJoin("Joueur2", "random")
MP.onPlayerJoin("Joueur3", "Kevin")
MP.onPlayerJoin("Joueur4", "random")
MP.onPlayerJoin("Joueur5", "Fiona")

-- Affiche le statut des équipes
MP.printStatus()
