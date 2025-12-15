# Thermostat-Vergleich - Smart Home Heizungsportal

**Erstellt:** 2025-12-13
**Aktualisiert:** 2025-12-15
**Status:** Landing Page Phase

## Projekt-Übersicht

Spezialisiertes Vergleichsportal für **smarte Thermostate und Heizungssteuerung**.

### Nische
- Heizkörperthermostate (Tado, Homematic IP, Netatmo, Fritz!DECT, Eve, Bosch)
- Raumthermostate / Wandthermostate
- Starter-Kits / Bundles
- Gateways / Bridges

### Kernfeatures
- **Kompatibilitäts-Check:** Welches Thermostat passt zu meiner Heizung? (Gas, Öl, Wärmepumpe, Fußbodenheizung)
- **Preisverlauf-Analyse:** Ist der aktuelle Preis gut?
- **KI-Kaufberater:** "5 Zimmer, 400€ Budget, HomeKit → Beste Empfehlung"
- **Smart-Home-Plattform-Filter:** HomeKit, Google Home, Alexa, Matter, Home Assistant

### Warum diese Nische?
- Hoher Beratungsbedarf (komplexe Kompatibilitätsfragen)
- Aktuelles Thema (Energiekrise, Heizkosten sparen)
- Höhere Provisionen (tink.de bis 6%)
- Wachsender Markt (17,76% CAGR bis 2031)
- Saisonalität: Peak Oktober-Februar (Heizsaison)

## AWIN Account

- **Publisher Name:** PreisCheck Media
- **Publisher ID:** 2694910
- **Registriert:** 13.12.2025

## Shops

### Hauptpartner
| Shop | Netzwerk | Status | Provision |
|------|----------|--------|-----------|
| **tink.de** | AWIN (13686) | Zu bewerben | bis 6% |

### Zusätzliche Partner
| Shop | Netzwerk | Status | Provision |
|------|----------|--------|-----------|
| Otto DE | AWIN (14336) | Abgelehnt (fehlende Webseite) | bis 12% |
| Alternate DE | AWIN (11731) | Abgelehnt (fehlende Webseite) | 2% |
| Conrad | AWIN (5769) | Beworben | 4% |

### Nächster Schritt
Landing Page erstellen → Bei tink.de bewerben → Otto/Alternate erneut bewerben

## Domain-Optionen (SEO-fokussiert)

| Domain | Status | SEO-Potenzial |
|--------|--------|---------------|
| thermostat-vergleich.de | Prüfen | Hoch (direktes Keyword) |
| thermostat-test.de | Prüfen | Hoch |
| smarthome-heizung.de | Prüfen | Mittel-Hoch |

## Tech Stack

| Komponente | Technologie |
|------------|-------------|
| Backend | Python FastAPI |
| Datenbank | PostgreSQL |
| Vektor-DB | Qdrant (Hybrid Search) |
| Embeddings | FastEmbed (lokal) |
| Frontend | Next.js (SSR für SEO) |
| Hosting | Hetzner VPS (~15€/Monat) |
| KI | GPT-4o-mini / Claude Haiku |

## Ordnerstruktur

```
/home/robert/preischeck/
├── README.md              # Diese Datei
├── plans/                 # Pläne und Dokumentation
│   ├── 01-recherche.md
│   ├── 02-architektur.md
│   └── 03-roadmap.md
├── landing/               # Landing Page für AWIN
│   ├── index.html
│   ├── impressum/
│   ├── datenschutz/
│   └── css/
└── src/                   # (später) Backend + Frontend
```

## Kosten

| Posten | Kosten/Monat |
|--------|--------------|
| Hetzner VPS | ~15€ |
| Domain (.de) | ~1€ |
| KI-API | ~5-20€ |
| **Gesamt** | **~20-35€** |

Break-Even bei ~2-3 Sales/Monat (bei 4% Provision, 300€ Warenkorb)

## Dokumentation

| Dokument | Pfad | Inhalt |
|----------|------|--------|
| Strategie-Dokument | `~/.claude/plans/deep-mapping-newt.md` | Ausführliche Nischen-Analyse, Pivot-Entscheidung, SEO-Strategie |
| Aktueller Plan | `~/.claude/plans/glowing-popping-glacier.md` | Landing Page Plan für AWIN-Freischaltung |

## Kontakte

- AWIN Support: publishersupport@awin.com
- tink.de Affiliate: (über AWIN)
- Otto Affiliate: affiliate@otto.de
