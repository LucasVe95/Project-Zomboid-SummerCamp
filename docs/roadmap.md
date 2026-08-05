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
| F3 | Permideath | La mort est définitive, chaque décision a un impact | 1 ✅ |
| F4 | Objectifs secrets | Coopération, sabotage, assassinat — attributs par joueur | 2 |
| F5 | Map île sur-mesure | Île dédiée, +15 routes d'évasion uniques | 3 |
| F6 | Événements dynamiques | Météo évolutive, hordes de zombies, événements dramatiques | 3 |
| F7 | UI & mode spectateur | Interface & mode observateur optimisés Twitch/YT | 4 |

---

## 🗺️ Phasage du Développement

### Phase 0 — MVP Core (Terminée ✅)

**Objectif :** Valider la chaîne de base *connexion → sélection → assignation → UI*.

**Fonctionnalités livrées :**
- 15 personnages répartis en 3 équipes (Alpha, Beta, Gamma — 5 persos chacunes).
- Sélection de personnage en mode libre ou aléatoire (`ZombRand` / `math.random` fallback).
- Gestion des personnages déjà pris (`takenCharacters`) + **re-pick aléatoire** si nom pris.
- Assignation automatique à l'équipe selon le personnage (`Teams.assignPlayer`).
- Interface lobby ISUI complète : panel, boutons par personnage, bouton « Aléatoire », boîte de confirmation.
- Flow de connexion serveur + déduplication via le module partagé `player_assignment`.
- Points d'entrée client/serveur (`media/lua/client/client.lua`, `media/lua/server/server.lua`).

**Fichiers livrés :**
- `media/lua/shared/player_selection.lua`, `media/lua/shared/teams.lua`,
  `media/lua/shared/player_assignment.lua`, `media/lua/shared/utils.lua`,
  `media/lua/shared/spawn_points.lua`.
- `media/lua/server/player_connect.lua`, `media/lua/server/player_multijoueur.lua`,
  `media/lua/server/server.lua`, `media/lua/server/quest_manager.lua`,
  `media/lua/server/escape_routes.lua`, `media/lua/server/permadeath.lua`.
- `media/lua/client/ui_selection.lua`, `media/lua/client/client.lua`,
  `media/lua/client/notifications.lua`.

**Tests :**
- `test/test_selection.lua`, `test/test_connect.lua`, `test/test_multiplayer.lua`,
  `test/test_server.lua` (15 joueurs), `test/test_ui.lua`.

**Jalons :** ✅ Sélection validée — ✅ Équipes assignées — ✅ UI lobby opérationnelle — ✅ Re-pick aléatoire — ✅ Tests 15 joueurs passants.

---

### Phase 1 — Permideath & Conditions de Victoire (Terminée ✅)

**Objectif :** Introduire la **mort définitive** et un **système de victoire/défaite** par équipe, avec **reanimation en Z** et **deux fins**.

**Mécanique (validée avec le product owner) :**
- **Mort** → le **cadavre reste sur place** ; le joueur est **téléporté dans la `zombieZone`** et devient un **Z**.
- **Reanimation en Z** : le Z garde ses **capacités Z** (`spawn_points.zombieAbilities` : vitesse +15 %, claw, vision nocturne) **et une capacité spéciale** : envoyer un **signal indirect** aux humains (canal de trahison).
- **Perception** : un humain voit un Z comme un zombie (pas de chat vocal) ; le Z peut **prétendre sympa pour trahir** ou **défier pour aider**.
- **Permideath vraie** : si un **humain tue un Z**, le Z est **définitivement éliminé** (retiré du registre).
- **Fin humaine (✅)** : une équipe s'évite via une route dont les **prérequis sont remplis** (`EscapeRoutes.canUseRoute`).
- **Fin zombie (🧟)** : tous les humains éliminés → `Permadeath.checkEndgame() == "zombie_win"`.

**Fichiers livrés :**
- `media/lua/server/permadeath.lua` (nouveau) — `registerPlayer`, `onDeath`, `becomeZombie`, `killZombie`, `getSide`, `sendSignal` (+cooldown), `livingInTeam`, `zombieCount`, `aliveCount`, `checkEndgame`, `tryEscape`.
- `media/lua/shared/spawn_points.lua` (étendu) — `zombieZone` + `zombieAbilities` + getters.
- `media/lua/server/escape_routes.lua` (étendu) — `prerequisites` + `canUseRoute` / `unlockRoute` / `get`.
- `media/lua/server/quest_manager.lua` (étendu) — `worldFlags` (conditions globales) + API quête secrète (Phase 2).
- `media/lua/server/server.lua` (étendu) — hook `Events.OnCharacterDeath` → `Permadeath.onDeath` + inscription des joueurs.
- `media/lua/shared/player_selection.lua` (étendu) — **re-pick aléatoire** si le nom choisi est déjà pris.

> La logique de victoire est intégrée dans `permadeath.checkEndgame()` (au lieu d'un `victory_conditions.lua` séparé) pour limiter la surface serveur.

**Tests :**
- `test/test_permadeath.lua` — mort→Z (cadavre sur place), Z tué→dead, signal+cooldown, fin Z.
- `test/test_endgame.lua` — routes bloquées/verrouillées/prêtes, évasion H ✅, évasion sans prérequis bloquée, fin Z `zombie_win`.

**Dépendances :** Phase 0 (MVP).

**Jalons :** ✅ Reanimation Z (zone + capacités) — ✅ Permadeath Z-kill — ✅ Canal signal/trahison — ✅ 2 fins (human_win / zombie_win) — ✅ Routes avec prérequis — ✅ Re-pick aléatoire.

---

### Phase 2 — Quêtes & Objectifs Secrets (À faire)

**Objectif :** Donner un **but individuel** à chaque joueur via des **objectifs secrets** (coopération, sabotage, meurtre), source de trahison possible.

**Fonctionnalités :**
- `F4` Objectifs secrets par joueur — chaque personnage reçoit un rôle/objectif secret à la connexion.
  - Types d'objectifs : **Coopérateur** (aider son équipe), **Saboteur** (faire échouer l'équipe), **Assassin** (éliminer un joueur cible), **Survivant neutre** (survivre seul).
- Attribution aléatoire ou basée sur le personnage.
- Interface qui dévoile l'objectif secret au joueur sans le révéler aux autres.
- Contrôle du respect des objectifs (progression, complétion).
- Interaction avec la Phase 1 : un objectif peut nécessiter la mort d'un joueur (perma activé).

**Fichiers concernés :**
- `media/lua/server/quest_manager.lua` — gestion du cycle de vie des quêtes (Phase 2 ; `worldFlags` déjà présent pour la Phase 3).
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
  - `media/lua/server/spawn_points.lua` (déjà partiellement implémenté : spawns + zone Z).
  - `media/lua/server/interactive_objects.lua` — objets interactifs (barrières, verrous, générateurs, caches de butin).
  - 15+ routes d'évasion uniques (marche côtière, sous-eau, tunnel, hélicoptère, etc.) — liées aux quêtes.
- Intégration des routes d'évasion dans `media/lua/server/escape_routes.lua` (Phase 2) et l'UI.

**Fichiers concernés :**
- `media/lua/server/weather.lua`, `media/lua/server/zombie_horde.lua`, `media/lua/server/drama_events.lua`.
- `media/lua/server/interactive_objects.lua`.
- `media/lua/server/escape_routes.lua` (étendu en Phase 3).
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
  - `media/lua/client/notifications.lua` — notifications centrées pendant la partie (mort, trahison, événement, fin de partie).
  - `media/lua/client/objectives_ui.lua` — HUD de l'objectif secret + objectifs d'équipe visibles.
  - `media/lua/client/selection_ui.lua` — UI de sélection enrichie (infos perso, rôle).
  - Mode spectateur libre : caméra flottante ou suivi de joueur, overlays.
  - Overlays compatibles stream (noms vivants/morts, alliances, objectifs visibles aux spectateurs).
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
| 0 — MVP | `test/test_selection`, `test_connect`, `test_multiplayer`, `test_server`, `test_ui` | `lua test/test_*.lua` | ✅ |
| 1 — Permideath | `test/test_permadeath.lua`, `test/test_endgame.lua` | `lua test/test_*.lua` | ✅ |
| 2 — Quêtes | `test/test_quest_manager.lua`, `test/test_escape_routes.lua` | — | — |
| 3 — Événements | `test/test_weather.lua`, `test/test_zombie_horde.lua`, `test/test_drama_events.lua` | — | — |
| 4 — UI | `test/test_ui.lua` (corrigé), `test/test_notifications.lua` | — | — |

> ⚠️ Les APIs Project Zomboid (ex: `getCore()`, `ISPanel`, `getTextManager()`, `getPlayerData()`, `Events`) ne sont pas disponibles hors-jeu. Les modules serveur sont écrits **sans dépendance forçée aux APIs PZ** (les hooks `if Events then ... end` sont sautés hors-jeu), de sorte que les tests unitaires restent exécutables avec un interpréteur Lua standard (`lua test/test_*.lua`). `test_ui.lua` saute via `rawget(_G,"getCore")`.

> 📝 **Note `test_server.lua` :** le scénario mélange des choix nommés et `random`. Depuis la Phase 1, un nom déjà pris déclenche un **re-pick aléatoire** → tous les 15 joueurs sont désormais assignés (plus de non-détermination).

---

## 📦 Packaging & Distribution (Cross-cutting — ✅ Phase 0/1)

- [x] Structure du mod selon la convention PZ : `media/lua/{shared,server,client}/` (minuscules, auto-chargés par le moteur).
- [x] Fichier `mod.info` créé à la racine (`name=Summer Camp Survival`, `shortname=SummerCampSurvival`, version, auteur, url).
- [ ] Ajouter les assets graphiques (`media/textures/`, `poster.png`).
- [ ] Intégrer la carte personnalisée (`media/maps/SummerCampIsland/`).
- [ ] Valider le mod sur le serveur de développement PZ puis le publier sur Steam Workshop.

> Le README décrit la structure en majuscules (`Client/Server/Shared`) à titre documentaire ; l'implémentation utilise les minuscules (`client/server/shared`) conformément à l'auto-chargement du moteur PZ. Points d'entrée : `media/lua/client/client.lua` (client) et `media/lua/server/server.lua` (serveur). `server.ini` : `Mods=SummerCampSurvival` / `Map=SummerCampIsland;Muldraugh, KY`.

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
[Phase 1 Permideath]    ████████████░░░░░░ 100% → TERMINÉE ✅
[Phase 2 Objectifs]     ░░░░░░░░░░░░░░░░░░   0% → À PLANIFIER
[Phase 3 Événements]    ░░░░░░░░░░░░░░░░░░   0% → À PLANIFIER
[Phase 4 Spectateur]    ░░░░░░░░░░░░░░░░░░   0% → À PLANIFIER
```

**Conclusion :** Le projet est au stade de **prototype jouable**. Le MVP (sélection/équipes/UI/connexion) et la **Phase 1** (perma, reanimation en Z, canal de trahison, 2 fins, routes avec prérequis) sont **implémentés, dédupliqués et testés (7 tests ✅)**. Les fonctionnalités restantes décrites dans le README (objectifs secrets, carte île + 15 éVASIONS, événements dynamiques, UI/spectateur) sont structurées en 3 phases incrémentales, prêtes à l'emploi.
