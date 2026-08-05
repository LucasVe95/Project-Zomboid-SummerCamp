# Summer Camp Survival

<div align="center">

## 🌲 Summer Camp Survival

### _Un Mod Multijoueur Psychologique pour Project Zomboid_

**15 Joueurs. 3 Équipes. 1 Île Isolée. Coopérez... ou Trahissez pour survivre.**

[![Project Zomboid](https://img.shields.io/badge/Game-Project_Zomboid-4682B4.svg)]()
[![Genre](https://img.shields.io/badge/Genre-Multiplayer_Social_Deduction-red.svg)]()
[![Mode](https://img.shields.io/badge/Focus-Streamer_Friendly-purple.svg)]()

[🎮 S'abonner sur le Steam Workshop](#) • [💬 Serveur Discord](#) • [📜 Regarder le Trailer](#)

---

</div>

## 🩸 À propos du Mod

**Summer Camp Survival** transforme l'expérience _Project Zomboid_ en une aventure sociale sous haute tension.

Dans cette expérience scénarisée sur une île coupée du monde, **15 joueurs** répartis en **3 équipes thématiques** s'affrontent et collaborent. Mais attention : chaque joueur possède des **objectifs secrets** qui peuvent inverser le cours des alliances à tout moment. Choisissez entre l'entraide héroïque ou la trahison sanglante pour faire partie des rares rescapés.

> 🎬 **Conçu pour le streaming :** Un gameplay dynamique, un suspense permanent et une vision spectateur pensée pour créer des moments épiques en live !

---

## ✨ Fonctionnalités Principales

```
┌────────────────────────────────────────────────────────────────────────┐
│ 🔥 15 Personnages Uniques & 3 Équipes Thématiques                      │
│ 🎴 Système de Sélection Libre ou Aléatoire au spawn                    │
│ 💀 Permadeath : La mort est définitive, chaque décision compte          │
│ 📜 Objectifs Secrets par Joueur (Coopération, Sabotage, Assassinat...) │
│ 🏝️ Map Sur-Mesure : Une île dédiée avec +15 routes d'évasion uniques   │
│ 🌪️ Événements Dynamiques & Environnement Évolutif                      │
│ 🎬 Interface & Mode Spectateur Optimisés pour Twitch/YouTube           │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 🏝️ Le Concept de Jeu

```
  [ ⛺ Équipe Alpha ]      [ 🌲 Équipe Beta ]      [ 📻 Équipe Gamma ]
          │                       │                       │
          └───────────────┬───────┴───────────────┬───────┘
                          │                       │
                          ▼                       ▼
            🤝 Alliance de Circonstance   OR   🗡️ Trahison Secrète
                          │                       │
                          └───────────┬───────────┘
                                      │
                                      ▼
                      🛸 15+ Voies d'Évasion Possibles
```

---

## 📂 Structure du Mod (Architecture)

> Projet structuré selon la convention **Project Zomboid** : `media/lua/{client,server,shared}` (minuscules, auto-chargés par le moteur).

```
SummerCampSurvival/
├── mod.info                      # Métadonnées Steam Workshop
├── README.md                     # Présentation du mod
├── media/
│   └── lua/
│       ├── shared/               # Données & logique commune (client + serveur)
│       │   ├── player_selection.lua
│       │   ├── teams.lua
│       │   ├── player_assignment.lua   # Flow commun (déduplication)
│       │   └── utils.lua
│       ├── server/               # Logique serveur (connexion, équipes, quêtes, events)
│       │   ├── server.lua            # Point d'entrée serveur
│       │   ├── player_connect.lua
│       │   ├── player_multijoueur.lua
│       │   ├── quest_manager.lua     # (stub — Phase 2)
│       │   ├── escape_routes.lua     # (stub — Phase 2/3)
│       │   ├── weather.lua           # (stub — Phase 3)
│       │   ├── zombie_horde.lua      # (stub — Phase 3)
│       │   ├── drama_events.lua      # (stub — Phase 3)
│       │   ├── spawn_points.lua      # (stub — Phase 3)
│       │   └── interactive_objects.lua # (stub — Phase 3)
│       └── client/               # Interfaces & affichage
│           ├── client.lua              # Point d'entrée client
│           ├── ui_selection.lua        # Lobby de sélection (ISUI)
│           ├── notifications.lua     # (stub — Phase 4)
│           ├── objectives_ui.lua       # (stub — Phase 4)
│           └── selection_ui.lua        # (stub — Phase 4)
├── docs/                         # Documentation
│   ├── roadmap.md                # Feuille de route par phases
│   └── game_design.md            # Cahier des charges fonctionnel
├── test/                         # Tests unitaires (Lua 5.4)
└── LICENSE
```
→ `media/maps/SummerCampIsland/` et `media/textures/` à intégrer (Phases 3 & 4).


---

## 🚦 Statut du Développement

| Fonctionnalité | Phase | Statut |
|---|---|---|
| 15 persos & 3 équipes + sélection lobby | 0 — MVP | ✅ Implémentée & testée |
| Permadeath & conditions de victoire | 1 | ✅ Implémentée & testée |
| Objectifs secrets par joueur | 2 | ⏳ Planifiée |
| Map île + 15 routes d'évasion | 3 | ⏳ Planifiée (stubs présents) |
| Événements dynamiques & environnement | 3 | ⏳ Planifiée (stubs présents) |
| UI & mode spectateur Twitch/YT | 4 | ⏳ Planifiée (stubs présents) |

> Les phases 1–4 sont décrites dans [`docs/roadmap.md`](docs/roadmap.md).  
> Tests unitaires (Lua 5.4) : `lua test/test_*.lua` — tous au code de sortie 0.

---

## 🚀 Installation & Lancement


### Pour les Joueurs :

1. Abonnez-vous au mod sur le **Steam Workshop**.
2. Rejoignez un serveur dédié hébergeant le mod **Summer Camp Survival**.
3. Choisissez (ou tirez au sort) votre personnage dans le lobby et découvrez vos **objectifs secrets** !

### Pour les Administrateurs de Serveur :

1. Ajoutez le mod à votre fichier `server.ini` :

```ini
Mods=SummerCampSurvival
Map=SummerCampIsland;Muldraugh, KY
```

2. Configurez le nombre de joueurs (recommandé : **15 joueurs**).

---

## 🛠️ Stack & Outils de Modding

- **Moteur de jeu :** Project Zomboid (Java / Lua Core)
- **Scripts :** Lua (Client & Server side)
- **Mapping :** WorldEd / TileMover (Zomboid Mapping Tools)

---

## 👨‍💻 Crédits & Auteurs

- **Créateur du Mod :** Lucas Veysset
- **Remerciements :** À la communauté des moddeurs de _Project Zomboid_

---

<div align="center">

_Survivor, surveille tes arrières... Même tes coéquipiers ont un secret._ 🩸

</div>
