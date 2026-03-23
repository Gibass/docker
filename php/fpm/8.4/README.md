# PHP 8.4 Image (Composer + perf)

Cette base fournit:
- PHP `8.4-fpm-alpine`
- Composer 2
- Extensions utiles (`intl`, `bcmath`, `gd`, `pdo_mysql`, `pdo_pgsql`, `zip`, `opcache`)
- Réglages de performance communs (`dev` + `prod`) intégrés dans l'image
- Surcharge de config PHP via des fichiers `.ini` ajoutés au runtime
- Exécution de scripts custom au démarrage du conteneur

La base Docker utilisée est `php:8.4-fpm-alpine`, avec installation des paquets système via `apk`.

## Build

```bash
docker compose build
```

L'image est taggée comme :

```text
gibass/php:8.4
```

Pour activer Xdebug au build:

```bash
docker compose build --build-arg INSTALL_XDEBUG=1
```

## Push

Après authentification à ton registre Docker :

```bash
docker login
./bin/publish-image.sh
```

Ce script publie :

```text
gibass/php:8.4
gibass/php:latest
```

Ou en flux explicite :

```bash
docker compose build php
docker tag gibass/php:8.4 gibass/php:latest
docker push gibass/php:8.4
docker push gibass/php:latest
```

## Run

```bash
docker compose up -d
```

## Ajouter tes configs PHP spécifiques (`dev` ou `prod`)

Dépose tes fichiers `.ini` dans :

```text
docker/php/conf/
```

Exemples:
- `docker/php/conf/10-dev.ini`
- `docker/php/conf/10-prod.ini`

Les fichiers sont chargés au démarrage du conteneur et copiés dans `conf.d` avec un préfixe `zz-custom-`, donc ils passent après la config commune embarquée dans l'image.

## Lancer des scripts custom au démarrage

Par défaut, l'entrypoint cherche des scripts dans :

```text
/var/www/html/scripts
```

Avec le volume `./:/var/www/html`, tu peux donc créer :

```text
scripts/10-setup.sh
scripts/20-cache-warmup.sh
```

Ils sont lancés dans l'ordre alphabétique.

Variables utiles:
- `SCRIPTS_DIR`: change le dossier des scripts (défaut `/var/www/html/scripts`)
- `SKIP_CHMOD=1`: évite le `chmod -Rf 750` avant exécution

## Vérifier la config effective

```bash
docker compose exec php php --ini
docker compose exec php php -i | grep -E 'opcache|memory_limit|upload_max_filesize'
```
