#!/bin/bash

##############################################################################
# Thermostat-Vergleich Website Deployment Script
# Lädt alle Website-Dateien per SFTP auf den Strato-Webserver hoch
##############################################################################

set -e  # Bei Fehler abbrechen

# Farben für Output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script-Verzeichnis ermitteln
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
SITE_DIR="$PROJECT_DIR/web/landing"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Thermostat-Vergleich Deployment - Strato SFTP Upload    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

##############################################################################
# 1. Prüfe ob .ftp-config existiert
##############################################################################

CONFIG_FILE="$SCRIPT_DIR/.ftp-config"

if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${RED}❌ FEHLER: .ftp-config Datei nicht gefunden!${NC}"
    echo ""
    echo -e "${YELLOW}Bitte erstelle die Datei:${NC}"
    echo "  $CONFIG_FILE"
    echo ""
    echo "Inhalt:"
    echo "  FTP_HOST=5018891497.ssh.w2.strato.hosting"
    echo "  FTP_USER=su491668"
    echo "  FTP_PASS=dein_passwort"
    echo "  FTP_PORT=22"
    echo "  FTP_PROTOCOL=sftp"
    exit 1
fi

##############################################################################
# 2. Lade FTP-Zugangsdaten
##############################################################################

echo -e "${BLUE}📋 Lade FTP-Konfiguration...${NC}"
source "$CONFIG_FILE"

# Prüfe ob Variablen gesetzt sind
if [ -z "$FTP_HOST" ] || [ -z "$FTP_USER" ] || [ -z "$FTP_PASS" ]; then
    echo -e "${RED}❌ FEHLER: FTP-Zugangsdaten unvollständig!${NC}"
    exit 1
fi

# Setze Defaults
FTP_PORT=${FTP_PORT:-22}
FTP_PROTOCOL=${FTP_PROTOCOL:-sftp}

# Zielverzeichnis für thermostat-vergleich.de
TARGET_DIR="/web/thermostat-vergleich.de"

echo -e "${GREEN}✓ Konfiguration geladen${NC}"
echo "  Host: $FTP_HOST"
echo "  User: $FTP_USER"
echo "  Port: $FTP_PORT"
echo "  Protokoll: $FTP_PROTOCOL"
echo "  Zielverzeichnis: $TARGET_DIR"
echo ""

##############################################################################
# 3. Prüfe ob lftp installiert ist
##############################################################################

if ! command -v lftp &> /dev/null; then
    echo -e "${RED}❌ FEHLER: lftp ist nicht installiert!${NC}"
    echo -e "${YELLOW}Bitte installiere lftp: sudo apt install lftp${NC}"
    exit 1
fi

##############################################################################
# 4. Prüfe Quellverzeichnis
##############################################################################

echo -e "${BLUE}📦 Bereite Upload vor...${NC}"
echo "  Quellverzeichnis: $SITE_DIR"
echo ""

if [ ! -d "$SITE_DIR" ]; then
    echo -e "${RED}❌ FEHLER: Website-Verzeichnis nicht gefunden:${NC}"
    echo "  $SITE_DIR"
    exit 1
fi

cd "$SITE_DIR"

# Prüfe ob wichtige Dateien existieren
if [ ! -f "index.html" ]; then
    echo -e "${RED}❌ FEHLER: index.html nicht gefunden!${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Alle wichtigen Dateien vorhanden${NC}"
echo ""

##############################################################################
# 5. SFTP-Upload mit lftp
##############################################################################

echo -e "${BLUE}🚀 Starte Upload auf $FTP_HOST...${NC}"
echo ""

lftp -c "
set ftp:ssl-allow no
set ssl:verify-certificate no
set sftp:auto-confirm yes
set ssh:auto-confirm yes
open -u $FTP_USER,$FTP_PASS -p $FTP_PORT $FTP_PROTOCOL://$FTP_HOST

# Erstelle Zielverzeichnis falls nicht vorhanden
mkdir -p $TARGET_DIR
cd $TARGET_DIR

echo 'Uploading files...'

# Mirror-Upload: Nur geänderte Dateien hochladen
mirror --reverse \
       --delete \
       --verbose \
       --exclude .git/ \
       --exclude .DS_Store \
       ./ ./

echo 'Upload complete!'

# Fix file permissions
echo 'Fixing file permissions...'
chmod 644 index.html
chmod 644 impressum.html
chmod 644 datenschutz.html
chmod 644 css/style.css
echo 'Permissions fixed!'

quit
"

UPLOAD_STATUS=$?

##############################################################################
# 6. Ergebnis anzeigen
##############################################################################

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"

if [ $UPLOAD_STATUS -eq 0 ]; then
    echo -e "${BLUE}║                   ${GREEN}✅ UPLOAD ERFOLGREICH${BLUE}                    ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}🎉 Die Website wurde erfolgreich hochgeladen!${NC}"
    echo ""
    echo -e "${YELLOW}🌐 Deine Website ist jetzt live:${NC}"
    echo -e "   👉 https://thermostat-vergleich.de/"
    echo ""
    echo -e "${YELLOW}💡 Hinweis: Die Domain muss in Strato auf /web/thermostat-vergleich.de zeigen.${NC}"
else
    echo -e "${BLUE}║                    ${RED}❌ UPLOAD FEHLGESCHLAGEN${BLUE}                 ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${RED}Der Upload ist fehlgeschlagen. Überprüfe deine .ftp-config${NC}"
    exit 1
fi

echo ""
