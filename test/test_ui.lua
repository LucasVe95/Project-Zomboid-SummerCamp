package.path = package.path .. ";../?.lua;../?/init.lua"

-- BUG-01 corrigé : l'API s'appelle UI.show (et non UI.showSelectionUI).
-- UI.show() dépend des APIs Project Zomboid (getCore, ISUI, getTextManager,
-- getPlayerData) qui ne sont pas disponibles hors-jeu. On ne charge le module
-- qu'en contexte PZ pour éviter les erreurs de require sur les classes ISUI.
if rawget(_G, "getCore") then
    local UI = require "media/lua/client/ui_selection"
    UI.show("Joueur1")
    UI.show("Joueur2")
    UI.show("Joueur3")
    UI.show("Joueur4")
    print("[test_ui] Interface de sélection affichée pour 4 joueurs.")
else
    print("[test_ui] SKIP : APIs PZ (getCore/ISUI) non disponibles hors-jeu — tester dans le jeu.")
    print("[test_ui] API corrigée : UI.show Joueur1..4 (et non UI.showSelectionUI).")
end
-- Test de l'interface utilisateur de sélection des persos
