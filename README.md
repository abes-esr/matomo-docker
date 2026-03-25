# matomo-docker

Déploiement Matomo via Docker Compose avec MariaDB, PHP-FPM (Matomo) et Nginx, plus un conteneur cron pour l’archivage et un conteneur de backup de base.

## Prérequis

- Docker et Docker Compose
- Accès aux ports nécessaires (par défaut `80` côté conteneur web)

## Services

- `matomo-db` : MariaDB 10.11
- `matomo-db-dumper` : sauvegardes via `tiredofit/db-backup`
- `matomo-app` : Matomo FPM (image construite depuis `Dockerfile`)
- `matomo-cron` : exécute `crond` avec les tâches de `cron.txt`
- `matomo-web` : Nginx 1.27

## Démarrage rapide

1. Créez un fichier `.env` avec les variables nécessaires.
2. Lancez les services.

```bash
docker compose up -d
```

Ouvrez ensuite `http://<hôte>:${MATOMO_WEB_PORT}` pour terminer l’installation Matomo,ou directement l'URL du Proxy, en https.

## Variables d’environnement

À définir dans `.env` (exemple) :

```dotenv
# Base de données
MATOMO_DB_ROOT_PASSWORD=change_me
MATOMO_DB_PASSWORD=change_me
MATOMO_DB_USER=matomo
MATOMO_DB_AUTO_UPGRADE=1
MATOMO_DB_INITDB_SKIP_TZINFO=1
MATOMO_DB_DISABLE_UPGRADE_BACKUP=1

# Application Matomo
MATOMO_APP_USERNAME=matomo
MATOMO_APP_DBNAME=matomo

# Web
MATOMO_WEB_PORT=8080

# Limites (optionnel)
MEM_LIMIT=1g
CPU_LIMIT=1.0
```

## Structure des fichiers

- `Dockerfile` : image Matomo FPM avec cron intégré
- `cron.txt` : tâches CRON (archivage Matomo + logs)
- `docker-compose.yml` : définition des services
- `matomo.conf` : configuration Nginx

## Volumes

- `./volumes/matomo-db/data` : données MariaDB
- `./volumes/matomo-db/dump` : dumps de sauvegarde
- `./volumes/matomo-app/www` : fichiers Matomo
- `./volumes/matomo-app/logs` : logs Matomo
- `./configs/matomo-app/config` : config Matomo
- `./configs/matomo-app/plugins` : plugins Matomo

## Cron Matomo

Le conteneur `matomo-cron` exécute les tâches définies dans `cron.txt`. Par défaut, un archivage Matomo est lancé toutes les 5 minutes et un log CRON est écrit toutes les minutes.

## Sauvegardes

Le service `matomo-db-dumper` utilise `tiredofit/db-backup`.

- Fréquence par défaut : quotidienne à 01:30 (GMT)
- Rétention : 7 jours
- Compression : GZ

## Arrêt

```bash
docker compose down
```

## Dépannage rapide

- Vérifiez les logs :

```bash
docker compose logs -f matomo-web
```

- Vérifiez la connectivité DB :

```bash
docker compose exec matomo-db mariadb -u matomo -p
```
