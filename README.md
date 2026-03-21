# Dock

Depot de build et de publication d'images Docker.

Le depot peut contenir plusieurs systemes ou stacks selon les besoins, par exemple:

- PHP
- Node
- Nginx
- Redis

## Structure

Chaque technologie peut avoir son propre dossier, sa propre image, ses scripts et ses fichiers Compose.

Exemple de structure possible:

```text
php/
node/
nginx/
redis/
```

Etat actuel du depot:

- `php/`: systeme actuellement disponible
- `php/bin/publish-image.sh`: script de build + tag + push
- `php/fpm/8.4/`: image PHP 8.4 FPM

## Systeme disponible actuellement

Le compose principal disponible aujourd'hui est:

```bash
php/fpm/8.4/docker-compose.yml
```

L'image produite est:

```text
gibass/php:8.4
```

Le tag `latest` est publie a partir de cette meme image.

## Build local

Depuis la racine du depot:

```bash
docker compose -f php/fpm/8.4/docker-compose.yml build php
```

Depuis `php/`:

```bash
docker compose -f /home/gino/Projects/perso/dock/php/fpm/8.4/docker-compose.yml build php
```

## Lancer le conteneur

```bash
docker compose -f php/fpm/8.4/docker-compose.yml up -d
```

## Publier l'image

Le script de publication attend:

- `IMAGE_NAME` (defaut: `gibass/php`)
- `VERSION_TAG` (defaut: `8.4`)
- `COMPOSE_FILE` (defaut: `fpm/docker-compose.yml`)

Exemple utilise dans ce depot:

```bash
cd php
IMAGE_NAME=gibass/php COMPOSE_FILE=/home/gino/Projects/perso/dock/php/fpm/8.4/docker-compose.yml ./bin/publish-image.sh
```

Ce script:

1. build le service `php`
2. tag l'image en `latest`
3. push `gibass/php:8.4`
4. push `gibass/php:latest`

## Notes

- Xdebug est active dans `php/fpm/8.4/docker-compose.yml`
- le `Dockerfile` installe `linux-headers` pour permettre le build de Xdebug
- d'autres systemes pourront etre ajoutes plus tard sans changer la logique generale du depot

## Documentation detaillee

Voir aussi:

- `php/fpm/8.4/README.md`
- `php/fpm/8.4/conf/README.md`
