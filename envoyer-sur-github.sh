#!/bin/sh
# Envoie les deux projets Chez Manou sur GitHub.
# 1. Créez d'abord sur github.com deux dépôts VIDES (sans README) :
#      chez-manou-caisse   -> Private (obligatoire)
#      chez-manou-vitrine  -> Public ou Private
# 2. Lancez ce script dans Git Bash, depuis ce dossier :
#      sh envoyer-sur-github.sh VOTRE_NOM_GITHUB
set -e
U="$1"
if [ -z "$U" ]; then echo "Usage : sh envoyer-sur-github.sh VOTRE_NOM_GITHUB"; exit 1; fi
for P in chez-manou-caisse chez-manou-vitrine; do
  echo "== Envoi de $P"
  cd "$P"
  git remote remove origin 2>/dev/null || true
  git remote add origin "https://github.com/$U/$P.git"
  git push -u origin main
  cd ..
done
echo "Terminé. Vérifiez que chez-manou-caisse est bien en Private."
