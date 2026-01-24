local PS = require "core/player_selection"
local Teams = require "core/teams"

PlayerConnect = {}

-- Simule la confirmation du joueur (dans PZ tu remplacerais par UI)
-- Ici on met true si le joueur confirme, false s'il refuse
local function simulateConfirmation(playerName, character)
    -- Exemple : remplacer par input UI dans le mod
    -- Retourne true pour confirmer, false pour rejouer
    print(playerName .. " choisi le personnage : " .. character)
    print("Confirmez votre choix ? (true = oui, false = non)")
    
    -- Pour test, on peut toujours renvoyer true
    return true
end

-- Fonction appelée quand un joueur rejoint le serveur
-- playerName = nom du joueur qui se connecte
-- choice = nom du personnage choisi ou "random" pour aléatoire
function PlayerConnect.onPlayerJoin(playerName, choice)
    print("\n=== Nouveau joueur connecté : " .. playerName .. " ===")

    local confirmed = false
    local selectedCharacter = nil

    while not confirmed do
        -- Affiche les persos encore disponibles
        local available = PS.getAvailableCharacters()
        print("Personnages disponibles :")
        for _, char in ipairs(available) do
            print(" - " .. char)
        end

        -- Choix du perso
        selectedCharacter = PS.chooseCharacter(playerName, choice)

        if not selectedCharacter then
            print("Erreur : aucun personnage disponible ou choix invalide.")
            return
        end

        -- Simule la confirmation (à remplacer par UI réel)
        confirmed = simulateConfirmation(playerName, selectedCharacter)

        -- Si le joueur annule le choix, on le remet dispo
        if not confirmed then
            print(playerName .. " a annulé le choix, nouvelle sélection...")
            PS.takenCharacters[selectedCharacter] = nil
            -- Ici tu peux demander au joueur un nouveau choix
            -- Par exemple dans PZ : tu ré-affiches l'UI de sélection
        end
    end

    -- Assignation automatique à l'équipe
    Teams.assignPlayer(playerName, selectedCharacter)
    print(playerName .. " est prêt à jouer avec le personnage " .. selectedCharacter)
end

-- Fonction pour afficher les équipes actuelles
function PlayerConnect.printStatus()
    print("\n=== Statut des équipes ===")
    Teams.printTeams()
end

return PlayerConnect
-- Gestion de la connexion des joueurs et de la sélection des persos avec confirmation
