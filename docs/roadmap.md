# Feuille de Route — Summer Camp Survival

> **Document de suivi du développement.** Dernière mise à jour : août 2026.
> Conçu à partir du cahier des charges du `README.md` et de l'état actuel du code.
> Chaque phase vise à livrer un ensemble **cohérent et testable** de fonctionnalités.
> Structure du projet : `media/lua/{shared,server,client}/` (convention PZ).

---

## 🎯 Vision Générale

Transformer _Project Zomboid_ en une expérience multijoueur de **déduction sociale sous haute tension** :
15 joueurs répartis en 3 équipes thématiques, sur une île isolée, avec des **objectifs secrets** qui peuvent renverser les alliances. Conçu pour le **streaming** (Twitch / YouTube) avec un mode spectateur et des overlays optimisés.

---

## 📋 Fonctionnalités du README (Backlog Produit)

| # | Fonctionnalité | Description | Phase |
|---|---|---|---|
| F1 | 15 persos & 3 équipes | 15 personnages uniques, 3 équipes (Alpha / Beta / Gamma) | 0 — MVP ✅ |
| F2 | Sélection libre/ou aléatoire | Choix au spawn, mode libre ou tirage au sort | 0 — MVP ✅ |
| F3 | Permideath | La mort est définitive, chaque décision a un impact | 1 |
| F4 | Objectifs secrets | Coopération, sabotage, assassinat — attributs par joueur | 2 |
| F5 | Map île sur-mesure | Île dédiée, +15 routes d'évasion uniques | 3 |
| F6 | Événements dynamiques | Météo évolutive, hordes de zombies, événements dramatiques | 3 |
| F7 | UI & mode spectateur | Interface & mode observateur optimisés Twitch/YT | 4 |

---

## 🗺️ Phasage du Développement

### Phase 0 — MVP Core (Terminée ✅)

**Objectif :** Valider la chaîne de base *connexion → sélection → assignation → UI*.

**Fonctionnalités livrées :**
- 15 personnages répartis en 3 équipes (Alpha, Beta, Gamma — 5 persos chacune).
- Sélection de personnage en mode libre ou aléatoire (`ZombRand` / `math.random` fallback).
- Gestion des personnages déjà pris (`takenCharacters`).
- Assignation automatique à l'équipe selon le personnage (`Teams.assignPlayer`).
- Interface lobby ISUI complète : panel, boutons par personnage, bouton « Aléatoire », boîte de confirmation.
- Flow de connexion serveur + déduplication via le module partagé `player_assignment`.
- Points d'entrée client/serveur (`media/lua/client/client.lua`, `media/lua/server/server.lua`).

**Fichiers livrés :**
- `media/lua/shared/player_selection.lua`, `media/lua/shared/teams.lua`,
  `media/lua/shared/player_assignment.lua`, `media/lua/shared/utils.lua`.
- `media/lua/server/player_connect.lua`, `media/lua/server/player_multijoueur.lua`, `media/lua/server/server.lua`.
- `media/lua/client/ui_selection.lua`, `media/lua/client/client.lua`.

**Tests :**
- `test/test_selection.lua`, `test/test_connect.lua`, `test/test_multiplayer.lua`,
  `test/test_server.lua` (15 joueurs), `test/test_ui.lua`.

**Jalons :** ✅ Sélection validée — ✅ Équipes assignées — ✅ UI lobby opérationnelle — ✅ Tests 15 joueurs passants.

---

### Phase 1 — Permideath & Conditions de Victoire (À faire)

**Objectif :** Introduire la **mort définitive** et un **système de victoire/défaite** par équipe pour donner du sens stratégique au jeu.

**Fonctionnalités :**
- `F3` Permideath : le joueur mort ne peut plus respawnner comme membre de son équipe. La mort déclenche une notification et un changement de statut.
- Conditions de victoire par équipe (survie de membres, accomplissement d'objectifs, etc.).
- Défaite collective d'une équipe si tous ses membres sont éliminés.
- Scoreboard dynamique affichant l'état de chaque équipe / joueur (vivant / mort / traitre).
- Persistance du statut des joueurs (survie du personnage, statut permideath) via `setMetadata` / stockage serveur.

**Fichiers concernés (nouveaux / à créer) :**
- `media/lua/server/permadeath.lua` — gestion de la mort, statut, notification.
- `media/lua/server/victory_conditions.lua` — logique de victoire/défaite et scoreboard.
- Modifications éventuelles de `media/lua/server/player_connect.lua` / `player_multijoueur.lua` pour enregistrer le statut.
- `media/lua/client/notifications.lua` — notifications à l'écran (victoire, mort, etc.).

**Tests :**
- `test/test_permadeath.lua` — simule des morts et vérifie que les équipes s'effondrent.
- `test/test_victory.lua` — scénarios de victoire/défaite.

**Dépendances :** Phase 0 (MVP) — nécessite un personnage assigné et une équipe.

**Jalons :** Mort définitive implémentée — Scoreboard fonctionnel — Conditions de victoire testées.

---

### Phase 2 — Quêtes & Objectifs Secrets (À faire)

**Objectif :** Donner un **but individuel** à chaque joueur via des **objectifs secrets** (coopération, sabotage, meurtre), source de trahison possible.

**Fonctionnalités :**
- `F4` Objectifs secrets par joueur — chaque personnage reçoit un rôle/objectif secret à la connexion.
  - Types d'objectifs : **Coopérateur** (aider son équipe), **Saboteur** (faire échouer l'équipe), **Assassin** (éliminer un joueur cible), **Survivant neutre** (survivre seul).
- Attribution aléatoire ou basée sur le personnage.
- Interface qui dévoile l'objectif secret au joueur sans le révéler aux autres.
- Contrôle du respect des objectifs (progression, complétion).
- Interaction avec la Phase 1 : un objectif peut nécessiter la mort d'un joueur (perma déjà activé).

**Fichiers concernés :**
- `media/lua/server/quest_manager.lua` — gestion du cycle de vie des quêtes (attribution, suivi, complétion).
- `media/lua/server/escape_routes.lua` — définition des routes d'évasion (liées aux quêtes d'évasion).
- `media/lua/server/player_connect.lua` — déclenche l'attribution d'un objectif secret après la sélection.
- `media/lua/client/objectives_ui.lua` — affichage de l'objectif secret du joueur.

**Tests :**
- `test/test_quest_manager.lua` — attribution et suivi d'objectifs.
- `test/test_escape_routes.lua` — validation des routes d'évasion.

**Dépendances :** Phases 0 + 1 — nécessite la sélection de personnage et le perma.

**Jalons :** Attribution d'objectifs validée — Suivi de progression — Validation d'objectifs complétés.

---

### Phase 3 — Événements Dynamiques & Environnement (À faire)

**Objectif :** Rendre l'île **vivante et hostiles** avec des événements qui changent le cours du jeu.

**Fonctionnalités :**
- `F6` Événements dynamiques & environnement évolutif :
  - `media/lua/server/weather.lua` — météo changeante (orage, brouillard, canicule) impactant la visibilité et la survie.
  - `media/lua/server/zombie_horde.lua` — apparitions périodiques de hordes de zombies vers les zones clés.
  - `media/lua/server/drama_events.lua` — événements scénarisés (coupure de radio, fuite d'eau, électricité qui tombe) créant des tensions.
- `F5` Map île sur-mesure :
  - `media/lua/server/spawn_points.lua` — points d'apparition des joueurs équitablement répartis.
  - `media/lua/server/interactive_objects.lua` — objets interactifs (barrières, verrous, générateurs, caches de butin).
  - 15+ routes d'évasion uniques (marche côtière, sous-eau, tunnel, hélicoptère, etc.) — liées aux quêtes.
- Intégration des routes d'évasion dans `media/lua/server/escape_routes.lua` (Phase 2) et l'UI.

**Fichiers concernés :**
- `media/lua/server/weather.lua`, `media/lua/server/zombie_horde.lua`, `media/lua/server/drama_events.lua`.
- `media/lua/server/spawn_points.lua`, `media/lua/server/interactive_objects.lua`.
- `media/lua/server/escape_routes.lua` (complété en Phase 3).
- `media/lua/server/server.lua` / `media/lua/client/client.lua` — orchestration des événements (timers, événements PZ).

**Tests :**
- `test/test_weather.lua` — cycle météo.
- `test/test_zombie_horde.lua` — apparition des hordes.
- `test/test_drama_events.lua` — déclenchement des événements.

**Dépendances :** Phases 0, 2 — nécessite un environnement de base et des quêtes.

**Jalons :** Météo dynamique — Hordes zombies — 3+ événements dramatiques — 15 routes d'évasion.

---

### Phase 4 — UI & Mode Spectateur Streaming (À faire)

**Objectif :** Finaliser l'expérience pour les **joueurs** et les **spectateurs** (Twitch / YouTube).

**Fonctionnalités :**
- `F7` Interface & mode spectateur optimisé :
  - `media/lua/client/notifications.lua` — notifications centrées pendant la partie (mort, trahison, événement).
  - `media/lua/client/objectives_ui.lua` — HUD de l'objectif secret + objectifs d'équipe visibles.
  - `media/lua/client/selection_ui.lua` — UI de sélection enrichie (infos perso, rôle).
  - Mode spectateur libre : caméra flottante ou suivi de joueur, overlays.
  - Overlays compatibles stream (nom des joueurs vivants/morts, alliances, objectifs visibles aux spectateurs).
- Indicateurs visuels pour le streaming (taux de trahison, équipe dominante, timer des événements).

**Fichiers concernés :**
- `media/lua/client/notifications.lua`, `media/lua/client/objectives_ui.lua`, `media/lua/client/selection_ui.lua`.
- `media/lua/client/ui_selection.lua` (itération / enrichissement).
- `media/lua/client/client.lua` / `media/lua/server/server.lua` — enregistrement des événements UI.

**Tests :**
- `test/test_ui.lua` (corrigé) — vérifie l'affichage de l'UI.
- `test/test_notifications.lua` — envoi de notifications.

**Dépendances :** Toutes les phases précédentes — est l'aboutissement visuel et UX.

**Jalons :** HUD objectifs — Mode spectateur — Notifications — Overlays stream-ready.

---

## 🔬 Validation Continue

Chaque phase doit être validée par des tests avant de passer à la suivante :

| Phase | Tests associés | Commande exécution | OK |
|---|---|---|---|
| 0 — MVP | `test/test_*.lua` (5 fichiers) | `lua test/test_*.lua` | ✅ |
| 1 — Permideath | `test/test_permadeath.lua`, `test/test_victory.lua` | — | — |
| 2 — Quêtes | `test/test_quest_manager.lua`, `test/test_escape_routes.lua` | — | — |
| 3 — Événements | `test/test_weather.lua`, `test/test_zombie_horde.lua`, `test/test_drama_events.lua` | — | — |
| 4 — UI | `test/test_ui.lua` (corrigé), `test/test_notifications.lua` | — | — |

> ⚠️ Les APIs Project Zomboid (ex: `getCore()`, `ISPanel`, `getTextManager()`, `getPlayerData()`) ne sont pas disponibles hors-jeu. Les tests unitaires mockent ou contournent ces dépendances (ex: `test_ui.lua` saute via `rawget(_G,"getCore")`) pour rester exécutables avec un interpréteur Lua standard (`lua test/test_*.lua`).

> 📝 **Note `test_server.lua` :** le scénario mélange des choix nommés et `random` ; un `random` peut voler un personnage nommé demandé après, fait que `chooseCharacter` renvoie `nil` et que le joueur n'est assigné. Comportement **correct**, mais rend le test non-déterministe. Un re-pick aléatoire en cas d'échec sera ajouté (Phase 1).

---

## 📦 Packaging & Distribution (Cross-cutting — ✅ Phase 0)

La restructure PZ est **implémentée** :

- [x] Structure du mod selon la convention PZ : `media/lua/{shared,server,client}/` (minuscules, auto-chargés par le moteur).
- [x] Fichier `mod.info` créé à la racine (`name=Summer Camp Survival`, `shortname=SummerCampSurvival`, version, auteur, url).
- [ ] Ajouter les assets graphiques (`media/textures/`, `poster.png`).
- [ ] Intégrer la carte personnalisée (`media/maps/SummerCampIsland/`).
- [ ] Valider le mod sur le serveur de développement PZ puis le publier sur Steam Workshop.

> Le README décrit la structure en majuscules (`Client/Server/Shared`) à titre documentaire ; l'implémentation utilise les minuscules (`client/server/shared`) conformément à l'auto-chargement du moteur PZ. Les points d'entrée sont `media/lua/client/client.lua` (client) et `media/lua/server/server.lua` (serveur). Le `server.ini` administrateur : `Mods=SummerCampSurvival` / `Map=SummerCampIsland;Muldraugh, KY`.

---

## 🐛 Suivi des Bugs Connus

| ID | Bug | Statut | Phase |
|---|---|---|---|
| BUG-01 | `test/test_ui.lua` appelait `UI.showSelectionUI` (n'existe pas → `show`) | ✅ **Corrigé** (appel `UI.show` + garde APIs PZ) | UI |
| BUG-02 | `player_multijoueur.lua` : bloc mort `if not confirmed then` après `confirmed = true` | ✅ **Corrigé** (logique unie via `player_assignment`) | MVP |
| BUG-03 | Duplication logique entre `player_connect` & `player_multijoueur` | ✅ **Corrigé** (module partagé `player_assignment.lua`) | MVP |
| BUG-04 | Modules globaux (non `local`) : risque de collisions de noms | ℹ️ Accepté (convention PZ) — modules sont désormais `local` + `return` | — |
| BUG-05 | Structure du mod (`core/` racine) ne correspondait pas au `README.md` | ✅ **Résolu** (restructurée en `media/lua/{shared,server,client}`) | Packaging |

---

## 🚦 Statut Global

```
[Phase 0 MVP Core]      ████████████░░░░░░ 100% → TERMINÉE ✅
[Phase 1 Permideath]    ░░░░░░░░░░░░░░░░░░   0% → À PLANIFIER
[Phase 2 Objectifs]     ░░░░░░░░░░░░░░░░░░   0% → À PLANIFIER
[Phase 3 Événements]    ░░░░░░░░░░░░░░░░░░   0% → À PLANIFIER
[Phase 4 Spectateur]    ░░░░░░░░░░░░░░░░░░   0% → À PLANIFIER
```

**Conclusion :** Le projet est au stade de **prototype fonctionnel**. Le cœur du mécanisme de sélection, d'équipes et de connexion est implémenté, dédupliqué et testé (MVP ✅). Toutes les fonctionnalités différenciantes décrites dans le README (perma, objectifs secrets, carte, événements, spectateur) restent à développer, organisées en 4 phases incrémentales. La structure du mod est alignée sur la convention Project Zomboid (`media/lua/{shared,server,client}` + `mod.info`).
