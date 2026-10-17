# ⚽ Analyse du Football Européen & Modèle Multi-Critères du Ballon d'Or

Une analyse statistique complète des performances individuelles et collectives de **2 839 joueurs de football** évoluant dans les 5 grands championnats européens (Premier League, La Liga, Serie A, Bundesliga, Ligue 1).

Ce projet combine l'extraction automatisée des meilleurs profils par poste et l'élaboration d'un **modèle d'évaluation multi-critères sur 100 points** pour désigner objectivement le vainqueur du Ballon d'Or.

## 📋 Table des Matières

* [Aperçu du Projet](#-aperçu-du-projet)

* [Fonctionnalités Principales](#-fonctionnalités-principales)

* [Modèle Multi-Critères Ballon d'Or](#-modèle-multi-critères-ballon-dor)

* [Structure du Dépôt](#-structure-du-dépôt)

* [Prérequis et Installation](#-prérequis-et-installation)

* [Exécution du Script](#-exécution-du-script)

* [Résultats Majeurs](#-résultats-majeurs)

* [Auteur](#-auteur)

## 🎯 Aperçu du Projet

L'évaluation des performances des footballeurs se limite souvent aux simples totaux de buts et de passes décisives. Ce projet propose une approche data-driven plus riche :

1. **Analyse Spécifique par Poste** : Segmentation et identification du Top 5 pour chaque rôle (Attaquants, Milieux, Défenseurs, Gardiens).

2. **Visualisation Avancée** : Représentation graphique individuelle et vue d'ensemble sous forme de grille comparative $2 \times 2$.

3. **Modélisation Composite Ballon d'Or** : Pondération de 5 dimensions clés (efficacité par 90 min, précision, impact sur les résultats de l'équipe, contributions défensives, régularité).

## 🚀 Fonctionnalités Principales

* **Nettoyage Automatisé** : Normalisation des noms de colonnes via `janitor::clean_names()` et extraction robuste du poste principal (`poste_principal`).

* **Filtrage Contextuel par Temps de Jeu** : Application de seuils de minutes jouées minimums ($\ge 900$ min pour la défense, $\ge 1500$ min pour le Ballon d'Or, $\ge 10$ matchs pour les gardiens) afin d'éviter les biais statistiques.

* **Normalisation Min-Max (0 à 10)** : Harmonisation de métriques aux échelles disparates (pourcentages, comptages, ratios par match).

* **Exportation de Graphiques HD** : Génération et sauvegarde automatique de visualisations haute résolution (300 DPI).

## 🧮 Modèle Multi-Critères Ballon d'Or

Le score global sur $100$ points repose sur la formule pondérée suivante :

$$
Score = (3,5 \times Note_{GA90}) + (2,0 \times Note_{PPM}) + (1,5 \times Note_{SoT\%}) + (1,5 \times Note_{Def}) + (1,5 \times Note_{Min})
$$

Chaque métrique est ramenée sur une échelle de $0$ à $10$ selon la formule de normalisation Min-Max :

$$
Note = \frac{x - \min(x)}{\max(x) - \min(x)} \times 10
$$

### Répartition des 5 Dimensions :

| Dimension | Métrique R | Pondération | Description | 
| ----- | ----- | ----- | ----- | 
| **1. Rendement Offensif** | `ga_90` | **35%** | Total Buts + Passes Décisives ramené par 90 minutes. | 
| **2. Impact Équipe** | `ppm` | **20%** | Points Par Match moyens obtenus par l'équipe avec le joueur. | 
| **3. Précision au Tir** | `so_t_percent` | **15%** | Pourcentage de tirs cadrés sur l'ensemble de la saison. | 
| **4. Travail Défensif** | `tkl_w + int` | **15%** | Volume total de tacles gagnés et d'interceptions. | 
| **5. Régularité & Volume** | `min` | **15%** | Nombre total de minutes disputées sur la saison. | 

## 📁 Structure du Dépôt

```
.
├── Dataplayers.csv                 # Jeu de données d'origine (2 839 joueurs, 102 variables)
├── main_analysis.R                 # Script R complet (nettoyage, tops, graphiques, modèle)
├── README.md                       # Documentation du projet
│
├── outputs/                        # Dossier généré lors de l'exécution
│   ├── 1_comparaison_attaquants.png
│   ├── 2_comparaison_milieux.png
│   ├── 3_comparaison_defenseurs.png
│   ├── 4_comparaison_gardiens.png
│   ├── grille_complete_4_postes.png
│   └── ballon_dor_multicritere.png




```

## 🛠 Prérequis et Installation

### Prérequis

* **R** (version $\ge$ 4.1.0)

* **RStudio** (recommandé)

### Packages R Requis

Le script vérifie et installe automatiquement les packages manquants lors de l'exécution :

* `tidyverse` (manipulation de données et `ggplot2`)

* `janitor` (nettoyage des variables)

* `ggrepel` (évitement du chevauchement des étiquettes texte)

* `patchwork` (assemblage de sous-graphiques)

## ⚙️ Exécution du Script

1. Cloner le dépôt GitHub :

   ```
   git clone https://github.com/Omarito-66/analyse-joueurs-foot.git
   cd analyse-joueurs-foot
   
   
   
   
   ```

2. Placer votre fichier `Dataplayers.csv` dans le dossier racine.

3. Lancer l'analyse directement depuis la console R ou RStudio :

   ```
   source("main_analysis.R")
   
   
   
   
   ```

## 🏆 Résultats Majeurs

### Vainqueur du Ballon d'Or : **Harry Kane** (**72,0 / 100**)

* **Performance Offensive** : Indice exceptionnel de **1,55 action décisive (G+A) par 90 minutes**.

* **Précision** : **56,3%** de tirs cadrés, le meilleur taux du Top 5.

* **Impact Collectif** : **2,58 points par match** glanés avec son club.

### Top 5 Global du Modèle Multi-Critères :

1. 🥇 **Harry Kane** — **72,0 / 100**

2. 🥈 **Michael Olise** — **66,0 / 100**

3. 🥉 **Luis Díaz** — **61,3 / 100**

4. 4️⃣ **Erling Haaland** — **58,2 / 100**

5. 5️⃣ **Lamine Yamal** — **57,0 / 100**

## 👤 Auteur

* **Omar Omari /** Data scientiste

* GitHub : @**Omarito-66**