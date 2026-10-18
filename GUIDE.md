# Installer l'application de caisse (privée)

L'application est **séparée du site vitrine** :
- son propre projet Firebase, avec la base de données ;
- sa propre adresse web, jamais indiquée sur le site public ;
- son propre dépôt GitHub, **privé**.

Si le site vitrine était un jour piraté, l'attaquant n'aurait aucun chemin vers la caisse ni vers vos données.

## 1. Créer un projet Firebase dédié

1. Sur **console.firebase.google.com**, créez un **nouveau** projet, par exemple `chez-manou-caisse`. Ne réutilisez pas celui du site.
2. Menu **Firestore Database**, puis **Créer une base de données** : choisissez le **mode production** et l'emplacement **eur3 (Europe)**.
3. Menu **Authentication**, puis **Commencer** : activez **Adresse e-mail/Mot de passe**.
4. Dans **Authentication, puis Paramètres, puis Actions utilisateur**, décochez **Activer la création de compte** si l'option est proposée. Ainsi, personne ne peut créer de compte à part vous.

## 2. Créer un accès par téléphone

Dans **Authentication, onglet Utilisateurs**, créez un compte email par appareil ou par responsable, par exemple `caisse.bar@…` ou `manou@…`. C'est la **première serrure** : sans elle, impossible même de voir l'écran de connexion de la caisse.

## 3. Autoriser ces adresses

Ouvrez `firestore.rules` et mettez-y **uniquement** les adresses de l'étape 2, en minuscules. Toute autre adresse est refusée par Google, même si quelqu'un obtient le code de l'application.

## 4. Coller la configuration

1. Dans Firebase, ouvrez la roue dentée, puis **Paramètres du projet**, puis **Vos applications**, puis l'icône **</>** (Web).
2. Copiez les valeurs affichées dans `public/firebase-config.js`, à la place des `COLLER_ICI`.

Ces valeurs ne sont pas secrètes : ce sont les règles de l'étape 3 qui protègent les données.

## 5. Envoyer en ligne

```
npm install -g firebase-tools
firebase login
firebase use --add        (choisissez chez-manou-caisse, puis « default »)
firebase deploy
```

L'application est en ligne à l'adresse `https://chez-manou-caisse.web.app`.

## 6. Choisir l'adresse de la caisse

Deux possibilités :
- **Garder l'adresse `.web.app`** : la plus simple et la plus discrète.
- **Un sous-domaine**, par exemple `gestion.chezmanou.sn` : ajoutez-le dans **Hosting, puis Ajouter un domaine personnalisé** de **ce** projet.

Dans les deux cas :
- ne mettez jamais ce lien sur le site public, ni sur Facebook ou Google Maps ;
- l'application demande aux moteurs de recherche de ne pas la référencer.

## Comptes de l'application et niveaux d'accès

Après la connexion Firebase du téléphone (étape 2), chaque personne se connecte à la caisse avec **son propre compte**. Six comptes sont créés d'office :

| Compte | Identifiant | Mot de passe de départ | Ce qu'il peut faire |
|---|---|---|---|
| Administrateur | `admin` | `admin123` | Tout, y compris créer les comptes, fixer les droits et lire le journal d'activité |
| Gestionnaire | `gestionnaire` | `gestion123` | Tout le quotidien : ventes, remises, annulations, stock, prix, fournisseurs, dépenses, rapports. Pas les comptes |
| Vendeur | `vendeur` | `vend123` | Encaisse, gère les tables et les clients à crédit. Pas de remise, pas d'annulation, pas de bénéfices |
| Serveur | `serveur` | `serv123` | Prend les commandes aux tables du bar-resto. N'encaisse pas |
| Magasinier | `magasinier` | `stock123` | Arrivages, transferts dépôt vers bar, commandes fournisseurs. Ne vend pas |
| Comptable | `comptable` | `compta123` | Rapports, factures, bénéfices, dépenses et exports. Ne vend pas |

**Changez ces mots de passe dès le premier jour** : ils sont écrits dans ce guide. Chacun peut changer le sien en touchant son nom en haut à droite. L'administrateur voit un rappel tant qu'un compte garde son mot de passe de départ.

L'administrateur gère tout depuis **son nom, puis Comptes et accès** :
- créer un compte par personne (Awa, Ibou…), avec son rôle et le ou les commerces auxquels elle a accès ;
- désactiver un compte quand quelqu'un part, sans perdre son historique ;
- consulter le tableau complet des droits de chaque rôle.

Protections incluses :
- mots de passe chiffrés (SHA-256 avec sel), jamais enregistrés en clair ;
- blocage de 30 secondes après 5 essais ratés ;
- verrouillage automatique après une inactivité réglable (Réglages, Sécurité) ;
- **journal d'activité** : connexions, échecs, annulations, remises, changements de prix, de stock et de comptes, avec l'heure et la personne.

## 7. Installer sur les téléphones

Ouvrez l'adresse de la caisse dans le navigateur du téléphone, puis :
- **Android** : menu ⋮, puis **Ajouter à l'écran d'accueil** ;
- **iPhone** : bouton Partager, puis **Sur l'écran d'accueil**.

Connectez-vous une fois avec l'email de l'étape 2 : le téléphone reste connecté. Chaque employé se connecte ensuite avec son propre compte de caisse.

## Liste de sécurité à faire une fois

- **Validation en deux étapes** sur le compte Google qui possède Firebase (myaccount.google.com, puis Sécurité).
- **Validation en deux étapes** sur GitHub, et **dépôt privé** pour ce projet.
- **Validation en deux étapes** chez votre registraire de nom de domaine, pour qu'on ne puisse pas détourner vos adresses.
- **Changer les 6 mots de passe de départ** de la caisse.
- **Désactiver les comptes génériques** inutilisés, et créer un compte nominatif par employé.
- **Verrouillage automatique** : Réglages, puis Sécurité, par exemple 15 minutes.
- **Jamais de mot de passe ni de jeton** envoyé par WhatsApp ou dans une conversation.
- Rester sur le forfait **Spark** (gratuit, sans carte). Si vous passez un jour au forfait Blaze, créez une alerte de budget.

## Protections incluses

Elles sont configurées dans `firebase.json` :

- **Politique de sécurité du contenu (CSP)** : seuls les fichiers de l'application et les serveurs de Google Firebase sont autorisés. Un script injecté serait bloqué.
- **Interdiction d'afficher l'application dans une autre page**, contre les pages pièges qui volent les clics.
- **https obligatoire** (HSTS), aucune information transmise aux autres sites (Referrer-Policy), pas d'accès caméra, micro ni position.
- **Non-référencement** : balise `noindex`, en-tête `X-Robots-Tag` et `robots.txt`.
- **Deux serrures** : l'email Firebase du téléphone, puis le compte personnel de l'employé.

## Sauvegardes

Chaque début de mois :
1. Ouvrez l'onglet **Rapports**, puis **Exporter le mois (Excel)** et **Rapport d'activité (PDF)**.
2. Rangez les fichiers dans un dossier Google Drive privé.

## En cas de souci

| Problème | Solution |
|---|---|
| « Configuration Firebase manquante » | Revoir l'étape 4 |
| « Ce compte n'a pas accès aux données » | L'email n'est pas dans `firestore.rules`, ou `firebase deploy` n'a pas été relancé |
| Mot de passe de caisse oublié | L'administrateur le change dans Comptes et accès |
| Mot de passe administrateur oublié | Demandez-moi : il faut réinitialiser le compte dans Firestore |
