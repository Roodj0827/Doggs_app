RAPPORT DE PROJET : DOGS APP
Groupe : One Fire

Date : Février 2026

Technos : Flutter / Dart

Présentation du projet
DOGS App est une application mobile conçue pour simplifier l'adoption et l'achat de chiens, tout en accompagnant les propriétaires dans les soins quotidiens de leur animal. L'idée est de regrouper au même endroit des infos fiables sur les races et un outil pratique pour ceux qui veulent sauter le pas de l'adoption.

Pourquoi cette application ?
On a remarqué que les futurs propriétaires de chiens font souvent face à trois problèmes :

Les infos sur les races sont éparpillées partout.

Le processus d'adoption est souvent flou ou manque de visibilité.

Une fois le chien adopté, les conseils de santé ou d'éducation sont difficiles à retrouver rapidement sur mobile.

Nos solutions :

Une base de données complète via l'API Dog CEO.

Un système de favoris pour comparer et choisir tranquillement.

Une section dédiée aux conseils (santé, nourriture, exercice).

Un formulaire d'adoption direct pour faciliter les démarches.

Organisation de l'interface
L'app s'articule autour d'un design chaleureux (tons beige, chocolat et pêche) pour rester dans l'univers canin.

Splash & Login : Une entrée en matière fluide avec validation des champs en temps réel.

Accueil & Liste : Une grille d'images dynamique pour explorer les races.

Détails : Chaque chien a sa fiche avec sa galerie photo et ses caractéristiques.

Espace Soins : Des cartes interactives classées par catégories.

Favoris : Un espace perso pour retrouver ses coups de cœur, sauvegardés localement.

Aspects techniques
Nous avons utilisé Flutter 3.0 avec une architecture en couches pour séparer l'interface de la logique métier :

Frontend : Flutter/Dart avec des packages comme http pour les requêtes, cached_network_image pour la fluidité et shimmer pour les écrans de chargement.

Données : Consommation de l'API Dog CEO et stockage local via SharedPreferences pour les favoris et la session utilisateur.

Modèles : Structuration propre des données (Dog, User, CareTip) pour faciliter la maintenance.

L'équipe One Fire
Petit-Homme Rood-Jerry : S'est occupé du Design UI/UX, de la navigation entre les écrans et des animations.

Rudmyr Francois : A géré la partie "back" (intégration API, modèles de données et stockage local).

saint Germain Will-Gasly : A développé les fonctionnalités comme les favoris, la page de soins et a réalisé les tests.

Difficultés et solutions
Le développement n'a pas été sans embûches, notamment sur la gestion du login et l'ajout des "likes".

API & Asynchrone : Les temps de réponse variaient, on a donc ajouté des Shimmers pour que l'utilisateur ne reste pas devant un écran vide.

Stockage des favoris : On a dû passer par de la sérialisation JSON pour que les données persistent après la fermeture de l'app.

Code obsolète : On a corrigé une trentaine d'erreurs liées à la méthode withOpacity() en migrant vers withValues(alpha: ...).

Travail d'équipe : Les conflits sur Git nous ont forcés à être plus rigoureux sur nos revues de code.

La suite pour DOGS App
À court terme, on veut ajouter un vrai profil utilisateur et un mode sombre. Plus tard, l'objectif est d'intégrer la géolocalisation des refuges partenaires et un système de messagerie pour discuter directement avec eux.

Conclusion
Ce projet nous a permis de mettre en pratique les concepts clés de Flutter. De la gestion d'état au stockage local en passant par la consommation d'API, DOGS App est aujourd'hui une base solide pour une solution d'adoption responsable