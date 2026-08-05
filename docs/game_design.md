# Game Design Document — Summer Camp Survival

> Cahier des charges fonctionnel. Complète la feuille de route (`docs/roadmap.md`) et la présentation (`README.md`).
> État : **MVP Core implémentée, phases 1–4 planifiées**.

---

## 1. Concept & Vision

**Genre :** Survie multijoueur / déduction sociale
**Plateforme :** Project Zomboid (Java / Lua Core)
**Cible :** Joueurs + spectateurs (Twitch / YouTube)

Transforme l'expérience _Project Zomboid_ en une aventure sociale sous haute tension : 15 joueurs, 3 équipes thématiques, sur une île isolée. Chaque joueur reçoit des **objectifs secrets** (coopération, sabotage, meurtre) pouvant renverser les alliances à tout moment. La mort est **définitive** (permadeath). Objectif : être parmi les rares rescapés.

---

## 2. Équipes & Personnages

### Équipes (3 × 5 = 15 personnages)

| Équipe       | Personnages                       |
| ------------ | --------------------------------- |
| **Alpha** ⛺ | Alice, Bob, Charlie, Diana, Ethan |
| **Bravo** 🌲 | Fiona, George, Hannah, Ian, Julia |
| **Gamma** 📻 | Kevin, Laura, Mike, Nina, Oscar   |

> Les équipes sont thématiques (civils, militaires, scientifiques). Chaque team compte exactement 5 personnages.

### Sélection de personnage

- **Mode libre :** le joueur clique sur un personnage disponible.
- **Mode aléatoire :** tirage au sort parmi les personnages restants (`ZombRand` sous PZ, `math.random` en fallback test).
- Un personnage **pris ne peut être rechoisi** (`takenCharacters`).
- L'équipe est **assignée automatiquement** selon le personnage (`Teams.getTeamForCharacter`).

** Implémentée** (`media/lua/shared/player_selection.lua`, `media/lua/shared/teams.lua`, `media/lua/client/ui_selection.lua`).

---

## 3. Système de Connexion

### Flow serveur (Phase 0 — MVP ✅)

1. Un joueur rejoint → `Events.OnConnect` (client ouvre l'UI) / `OnClientCommand` "joinGame" (serveur).
2. L'UI propose les personnages disponibles + bouton « Aléatoire ».
3. Le joueur confirme → `PlayerAssignment.selectAndAssign` marque le perso, assigne l'équipe.
4. Annulation possible : le perso est remis à disposition.

**Modules :**

- `media/lua/shared/player_assignment.lua` — logique partagée (déduplication connect/multijoueur).
- `media/lua/server/player_connect.lua` — connexion + confirmation simulée (UI réelle en PZ).
- `media/lua/server/player_multijoueur.lua` — flux serveur auto-confirme + suivi `connectedPlayers`.

---

## 4. Permadeath & Conditions de Victoire (Phase 1)

### Règles

- **Permadeath :** un joueur tué meurt définitivement (plus de respawn). Son statut est persité (`setMetadata`).
- **Victoire par équipe :** accomplissement d'objectifs (survie de membres, évasion réussie, objectifs secrets remplis).
- **Défaite :** élimination de toute l'équipe ou échec critique d'objectif.
- **Scoreboard :** état chaque joueur (vivant / mort / trahit) + statut équipe.

**Modules à créer :** `media/lua/server/permadeath.lua`, `media/lua/server/victory_conditions.lua`.

---

## 5. Objectifs Secrets (Phase 2)

### Rôles possibles (attributs aléatoirement / par perso)

| Rôle                 | Objectif               | Comportement                        |
| -------------------- | ---------------------- | ----------------------------------- |
| **Coopérateur**      | Aider son équipe       | Survit, cache des ressources        |
| **Saboteur**         | Faire échouer l'équipe | Active des pièges, détruit la radio |
| **Assassin**         | Éliminer une cible     | Tue un joueur précis (hors team)    |
| **Survivant neutre** | Survivre seul          | Aucun allié, tout le monde suspect  |

### Mécanique

- L'objectif est **dévoilé au joueur** uniquement (`ui/objectives_ui.lua`).
- Le reste du monde ne voit que le personnage/équipe (pas le rôle).
- Un rôle peut rendre **la trahison** possible : le Saboteur/Assassin peut agir contre son équipe.
- La complétion est suivie serveur et affecte la victoire.

**Modules :** `media/lua/server/quest_manager.lua` (gestion cycle de vie), `media/lua/server/escape_routes.lua` (routes liées à l'évasion).

---

## 6. Carte & Environnement (Phase 3)

### Île "SummerCampIsland"

- Carte dédiée (WorldEd / TileMover), **15+ routes d'évasion uniques** (hélicoptère, tunnel, passage sous-marin, bateau de port, tour de radio, …).
- Chaque équipe a des spawns répartis (`media/lua/server/spawn_points.lua`).

### Env. dynamique

- **Météo** (`weather.lua`) : orage, brouillard, canicule → visibilité + agressivité zombies.
- **Hordes** (`zombie_horde.lua`) : vagues de zombies vers zones clés (timer).
- **Événements dramatiques** (`drama_events.lua`) : coupure radio, fuite d'eau, panne électricité → forces/ressources modifiées.
- **Objets interactifs** (`interactive_objects.lua`) : barrières, verrous, générateurs, caches de butin.

---

## 7. Interface & Spectateur (Phase 4)

### HUD joueur

- `ui/objectives_ui.lua` : objectif secret + objectifs d'équipe.
- `ui/notifications.lua` : notifications centrées (mort, trahison, événement).
- `ui/selection_ui.lua` : carte du personnage / rôle au lobby.

### Mode spectateur (Twitch/YT)

- Caméra libre ou follow-player.
- Overlays : noms vivants/morts, alliances, objectifs visibles, taux de trahison, timer événements.
- `ui/selection_ui.lua` enrichi pour le lobby visiteur.

---

## 8. Tests

| Fichier                     | Couvert                                           |
| --------------------------- | ------------------------------------------------- |
| `test/test_selection.lua`   | Choix perso (libre + random) + assignation équipe |
| `test/test_connect.lua`     | Flow connexion + confirmation simulée             |
| `test/test_multiplayer.lua` | Flow serveur auto-confirm (5 joueurs)             |
| `test/test_server.lua`      | Simulation complète 15 joueurs                    |
| `test/test_ui.lua`          | UI lobby (débogé : `UI.show`, guarde APIs PZ)     |

> Convention : modules PZ (ISUI, `getCore()`) sont mockés ou sautés hors-jeu via `rawget(_G,"getCore")`. Lancer avec : `lua test/test_*.lua`.

---

## 9. Packaging

- Structure : `media/lua/{shared,server,client}/` + `mod.info` (name, shortname `SummerCampSurvival`, version, author).
- `server.ini` administrateur : `Mods=SummerCampSurvival` / `Map=SummerCampIsland;Muldraugh, KY`.
- À venir : `media/maps/SummerCampIsland/` + `media/textures/` + `poster.png`.
