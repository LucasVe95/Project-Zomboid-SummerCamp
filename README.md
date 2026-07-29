<div align="center">

# 🌲 Summer Camp Survival
### *Un Mod Multijoueur Psychologique pour Project Zomboid*

**15 Joueurs. 3 Équipes. 1 Île Isolée. Coopérez... ou Trahissez pour survivre.**

[![Project Zomboid](https://img.shields.io/badge/Game-Project_Zomboid-4682B4.svg)]()
[![Genre](https://img.shields.io/badge/Genre-Multiplayer_Social_Deduction-red.svg)]()
[![Mode](https://img.shields.io/badge/Focus-Streamer_Friendly-purple.svg)]()

[🎮 S'abonner sur le Steam Workshop](#) • [💬 Serveur Discord](#) • [📜 Regarder le Trailer](#)

---

</div>

## 🩸 À propos du Mod

**Summer Camp Survival** transforme l'expérience *Project Zomboid* en une aventure sociale sous haute tension. 

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

```
SummerCampSurvival/
├── media/
│   ├── maps/
│   │   └── SummerCampIsland/        # Carte personnalisée de l'île
│   ├── lua/
│   │   ├── Client/                  # UIs, objectifs secrets et évènements client
│   │   ├── Server/                  # Gestion des équipes, victoires et permadeath
│   │   └── Shared/                  # Configuration des personnages et items du mod
│   └── textures/                    # Assets graphiques, icônes & UI
├── mod.info                         # Informations du mod Steam Workshop
└── poster.png                       # Visuel d'illustration du mod
```

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

* **Créateur du Mod :** Lucas Veysset
* **Remerciements :** À la communauté des moddeurs de *Project Zomboid*

---

<div align="center">

*Survivor, surveille tes arrières... Même tes coéquipiers ont un secret.* 🩸

</div>
