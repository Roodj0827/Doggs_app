ANNEXE : USAGE DE L'INTELLIGENCE ARTIFICIELLE
Projet : DOGS APP | Groupe : One Fire

Outil utilisé : Claude (Anthropic) - Version Sonnet 3.5/4.5

Période : Février 2026

1. Pourquoi avons-nous utilisé l'IA ?
Pour ce projet Flutter, nous avons intégré l'IA non pas pour "faire le travail à notre place", mais comme un mentor technique disponible 24h/24. Nos objectifs étaient clairs :

Accélérer la création des interfaces répétitives (formulaires, mises en page).

Diagnostiquer rapidement des erreurs de compilation qui nous bloquaient.

Structurer une documentation professionnelle et claire.

2. Exemples concrets d'utilisation
A. Conception de l'authentification (Login/Signup)
Nous avions besoin d'une page de connexion qui respecte notre charte graphique (tons beiges et chocolat).

Le prompt : "On a besoin d'une page de login complète en Flutter. Il faut des champs email/password, un bouton pour créer un compte, et un style visuel chaleureux avec des rappels sur l'univers des chiens."

Le résultat : L'IA a généré le fichier login_screen.dart.

Ce qu'on a dû ajuster : On a dû intégrer manuellement la logique de SharedPreferences pour que l'application se souvienne vraiment de l'utilisateur au redémarrage, ce qui n'était pas parfait dans le premier jet.

B. Debugging et erreurs de version
Lors du développement, nous avons été confrontés à 35 warnings et erreurs dans la console.

Le problème : Beaucoup de messages concernaient la méthode withOpacity() qui est maintenant dépréciée dans les dernières versions de Flutter.

L'aide de l'IA : En lui soumettant le log d'erreurs, elle nous a expliqué qu'il fallait migrer vers withValues(alpha: ...). Cela nous a évité de chercher pendant des heures dans la documentation officielle.

C. Correction de la navigation (Splash Screen)
Un moment critique : après avoir ajouté la page de login, le Splash Screen continuait d'envoyer l'utilisateur directement sur l'accueil, sans vérifier s'il était connecté.

L'échange : "La page login ne s'affiche pas, l'app charge directement la home."

La solution : L'IA nous a montré comment utiliser un Future.delayed combiné à une vérification de variable booléenne dans le stockage local pour rediriger vers la bonne page (/login ou /home).

4. Ce que nous avons appris grâce à cet outil
Travailler avec Claude nous a permis de monter en compétence plus vite que prévu sur plusieurs points :

La rigueur du code : Voir comment l'IA structure ses widgets (_buildTextField, etc.) nous a appris à mieux organiser notre propre code Dart.

La lecture des logs : On a appris à ne plus paniquer devant une liste de 30 erreurs, mais à les traiter par priorité (erreurs bloquantes vs warnings).

L'importance des tests : On a réalisé que même si l'IA donne un code "propre", il ne marche presque jamais du premier coup sans une adaptation manuelle à notre architecture de dossiers.

5. Conclusion sur l'usage de l'IA
L'IA a été un accélérateur incroyable, surtout pour respecter la deadline de minuit. Elle nous a permis de passer moins de temps sur la syntaxe pure et plus de temps sur l'expérience utilisateur et la logique de l'application. Cependant, le rôle du groupe est resté central pour assembler les pièces du puzzle et s'assurer que l'APK final était parfaitement fonctionnel sur nos téléphones.