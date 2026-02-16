# DOGS APP - APPLICATION D'ADOPTION DE CHIENS

## Abstract du Projet

**Groupe :** One Fire  
**Institution :** ESIH (École Supérieure d'Infotronique d'Haïti)  
**Date :** Février 2026  
**Technologie :** Flutter / Dart

---

## 1. NOM DE L'APPLICATION

**DOGS App** - Adopt, Buy & Care for Dogs

Application mobile Flutter pour l'adoption et les soins de chiens.

---

## 2. OBJECTIF DE L'APPLICATION

DOGS App simplifie le processus d'adoption de chiens en offrant :

- **Plateforme centralisée** pour découvrir plus de 200 races de chiens
- **Informations détaillées** sur chaque race (caractéristiques, photos, tempérament)
- **Conseils pratiques** pour les soins quotidiens
- **Système de favoris** pour sauvegarder les races préférées
- **Interface intuitive** accessible sur mobile

**Mission :** Faciliter l'adoption responsable en éduquant et accompagnant les futurs propriétaires de chiens.
mksd
---

## 3. CAPTURES D'ÉCRAN

### Écran de Démarrage (Splash Screen)
Logo animé avec dégradé orange/marron chaleureux, animation élastique du logo, transition fluide vers la page de connexion après 3 secondes.

### Page de Connexion/Inscription
Design chaleureux avec palette beige/chocolat/pêche, formulaire avec validation en temps réel, toggle facile entre connexion et inscription, icônes de pattes de chien décoratives, animations fluides.

### Page d'Accueil
Navigation claire vers quatre sections principales : Explorer les races, Adopter un chien, Conseils de soins, et Mes favoris. Interface épurée avec icônes intuitives et design moderne.

### Liste des Races
Affichage en grille des races disponibles, images haute qualité chargées via l'API Dog CEO, mise en cache pour performances optimales, effet shimmer pendant le chargement.

### Détails d'une Race
Galerie d'images défilante, informations complètes sur la race, bouton d'ajout aux favoris, navigation fluide entre les photos.

### Page d'Adoption
Formulaire simplifié pour initier le processus d'adoption, validation des champs obligatoires, design cohérent avec le reste de l'application.

### Conseils de Soins
Collection de conseils organisés par catégories : Alimentation, Santé, Exercice, Toilettage. Cartes interactives avec illustrations.

### Favoris
Liste personnalisée des races sauvegardées, stockage persistant avec SharedPreferences, possibilité de retirer des favoris, synchronisation automatique.

---

## 4. PROBLÈME RÉSOLU

### Problèmes identifiés

**A. Information dispersée**
Les futurs propriétaires consultent plusieurs sites web différents pour comparer les races et obtenir des informations fiables. Cela prend du temps et les informations sont souvent contradictoires.

**B. Processus d'adoption complexe**
Les refuges manquent de visibilité en ligne. Les procédures d'adoption sont floues et décourageantes pour les adoptants potentiels.

**C. Manque d'accompagnement**
Les nouveaux propriétaires sont souvent mal préparés aux soins quotidiens. Ils manquent de ressources facilement accessibles sur mobile.

### Solutions apportées

**Information centralisée et fiable**
Base de données complète de plus de 200 races via l'API Dog CEO, fiches détaillées avec photos et caractéristiques, interface de recherche intuitive.

**Simplification du processus**
Formulaire d'adoption intégré et simplifié, système de favoris pour suivre les races d'intérêt, préparation pour connexion future avec refuges locaux.

**Accompagnement continu**
Section "Conseils de soins" accessible 24/7, guides pratiques catégorisés par thème, interface mobile pour consultation nomade.

**Résultat :** Une application tout-en-un qui accompagne le futur propriétaire de la découverte à l'adoption, puis dans les soins quotidiens.

---

## 5. ARCHITECTURE TECHNIQUE

### Technologies utilisées
- **Framework :** Flutter 3.0+ (langage Dart)
- **API externe :** Dog CEO API (https://dog.ceo/api)
- **Stockage local :** SharedPreferences
- **Packages clés :** http, cached_network_image, shimmer

### Structure de l'application

**Couche Présentation (8 écrans)**
splash_screen, login_screen, home_screen, dog_list_screen, dog_detail_screen, adopt_screen, care_tips_screen, favorites_screen

**Couche Services (Logique métier)**
DogService (appels API), AuthService (authentification), StorageService (persistence)

**Couche Données (Modèles)**
Dog (races), User (utilisateur), CareTip (conseils)

### Fonctionnalités principales

**Authentification**
Connexion et inscription avec email/mot de passe, validation des formulaires en temps réel, session persistante avec SharedPreferences.

**Gestion des races**
Chargement dynamique depuis l'API Dog CEO, mise en cache des images pour performance, affichage optimisé avec shimmer loading.

**Système de favoris**
Sauvegarde locale des races préférées, persistence entre les sessions, synchronisation automatique.

**Navigation fluide**
Routes nommées avec transitions animées, retour en arrière géré correctement, préservation de l'état des écrans.

---

## 6. AUTEURS ET RÔLES

### Groupe One Fire - ESIH

**Membre 1 : [Nom Complet]**
- **Rôle :** UI/UX Designer + Navigation
- **Responsabilités :**
  - Design de l'interface utilisateur
  - Création des écrans (Splash, Login, Home)
  - Mise en place de la navigation entre écrans
  - Animations et transitions
  - Choix de la palette de couleurs

**Membre 2 : [Nom Complet]**
- **Rôle :** Backend Developer
- **Responsabilités :**
  - Intégration de l'API Dog CEO
  - Création des modèles de données
  - Gestion du stockage avec SharedPreferences
  - Services et logique métier
  - Gestion des états de chargement

**Membre 3 : [Nom Complet]**
- **Rôle :** Features Developer + Tests
- **Responsabilités :**
  - Développement du système de favoris
  - Page d'adoption et conseils
  - Tests et debugging
  - Gestion des erreurs
  - Documentation

---

## 7. DIFFICULTÉS RENCONTRÉES

### Techniques

**Gestion asynchrone de l'API**
Problème : Délais de chargement variables. Solution : Shimmer loading et cache d'images avec cached_network_image.

**Navigation splash vers login**
Problème : Le splash screen ne naviguait pas correctement. Solution : Vérification de session avec SharedPreferences et navigation conditionnelle.

**Méthode dépréciée withOpacity()**
Problème : 29 warnings dans le code. Solution : Migration vers withValues(alpha: ...).

**Configuration NDK Android**
Problème : Erreur lors de la génération de l'APK. Solution : Configuration des ABI filters dans build.gradle.

### Organisationnelles

**Gestion du temps**
Équilibrage entre fonctionnalités et délais. Solution : Priorisation des features essentielles (MVP).

**Coordination d'équipe**
Gestion des branches Git et conflits. Solution : Revues de code régulières et communication constante.

---

## 8. PERSPECTIVES D'AVENIR

### Court terme (Version 1.1)
Profil utilisateur complet, mode sombre, support multilingue (Français/Anglais/Créole), notifications.

### Moyen terme (Version 2.0)
Géolocalisation des refuges, chat en temps réel avec refuges, système de rendez-vous, historique des adoptions.

### Long terme (Version 3.0)
Intégration de paiement, marketplace d'accessoires, communauté et partage d'expériences, suivi vétérinaire intégré.

---

## 9. CONCLUSION

DOGS App démontre la maîtrise des concepts du développement mobile Flutter : architecture propre, consommation d'API REST, gestion d'état, stockage local, et design responsive.

L'application répond à un besoin réel en facilitant l'adoption responsable de chiens tout en éduquant les futurs propriétaires. Le projet combine technologie moderne et impact social positif.

**Résultats obtenus :**
- Application fonctionnelle complète
- Intégration API réussie
- Stockage persistant opérationnel
- Design professionnel et cohérent
- APK prêt pour distribution

---

**Contact :**  
Groupe One Fire  
Email : groupeonefire.esih@gmail.com  
Institution : ESIH - École Supérieure d'Infotronique d'Haïti  
GitHub : https://github.com/onefire-esih/dogs-app

**Technologies :** Flutter • Dart • Dog CEO API • SharedPreferences  
**Licence :** MIT

---

*Document rédigé dans le cadre du projet final de développement mobile - ESIH 2026*