# Roadmap

**Stand:** 2025-12-15
**Fokus:** Smart Home Heizungsautomatisierung

---

## Phase 0: Landing Page & AWIN (AKTUELL)

**Ziel:** Professionelle Webseite für AWIN-Freischaltung

- [ ] Domain registrieren (thermostat-vergleich.de o.ä.)
- [ ] Landing Page erstellen
  - [ ] index.html (Hero, Features, Marken, Coming Soon)
  - [ ] impressum/index.html
  - [ ] datenschutz/index.html
  - [ ] css/style.css
- [ ] Bei Strato deployen
- [ ] AWIN Profil aktualisieren
- [ ] Bei **tink.de** bewerben (Hauptpartner!)
- [ ] Bei Otto/Alternate erneut bewerben

---

## Phase 1: MVP Backend

**Ziel:** Erster funktionierender Thermostat-Vergleich

- [ ] Projekt-Repository erstellen
- [ ] Docker Compose Setup (PostgreSQL + Qdrant)
- [ ] FastAPI Grundstruktur
- [ ] Datenbank-Schema implementieren (siehe 02-architektur.md)
- [ ] Feed-Import für tink.de
  - [ ] Feed-URL von AWIN holen
  - [ ] CSV/XML Parser
  - [ ] Filter: Nur Thermostate/Heizung
  - [ ] Täglicher Cron-Job
- [ ] Basis-API Endpoints:
  - [ ] GET /products
  - [ ] GET /products/{id}
  - [ ] GET /products/{id}/prices
  - [ ] GET /search

---

## Phase 2: Kompatibilitäts-Datenbank

**Ziel:** Kern-USP implementieren

- [ ] Kompatibilitäts-Matrix aufbauen
  - [ ] Heizungstypen: Gas, Öl, Wärmepumpe, Fußbodenheizung, Fernwärme
  - [ ] Plattformen: HomeKit, Google, Alexa, Matter, Home Assistant
  - [ ] Gateway-Anforderungen
- [ ] Manuelles Seeding der Daten (Top 20 Produkte)
- [ ] API: GET /compatibility?heating=gas&platform=homekit

---

## Phase 3: Preisverlauf

**Ziel:** "Ist der Preis gut?" Feature

- [ ] Preisverlauf-Speicherung (täglich)
- [ ] API: GET /products/{id}/prices
- [ ] Statistiken berechnen:
  - [ ] Tiefstpreis (30/90/365 Tage)
  - [ ] Durchschnittspreis
  - [ ] Aktueller Preis vs. Durchschnitt
- [ ] "Guter Preis" Indikator

---

## Phase 4: Frontend MVP

**Ziel:** Nutzbare Website

- [ ] Next.js Setup
- [ ] Produktliste mit Filtern
  - [ ] Marke
  - [ ] Heizungstyp
  - [ ] Plattform
  - [ ] Preis
- [ ] Produktdetail-Seite
  - [ ] Specs
  - [ ] Kompatibilität
  - [ ] Preisverlauf-Chart
  - [ ] Shop-Links
- [ ] Responsive Design
- [ ] SEO-Grundlagen

---

## Phase 5: KI-Kaufberater

**Ziel:** Kern-USP Feature

- [ ] Qdrant Collection Setup
- [ ] FastEmbed Integration
- [ ] Hybrid Search (BM25 + Dense)
- [ ] RAG Pipeline
  - [ ] Query-Verarbeitung
  - [ ] Kompatibilitäts-Filter
  - [ ] Bundle-Berechnung
  - [ ] LLM Response
- [ ] Chat-Widget im Frontend
- [ ] Rate Limiting (5 Fragen/Tag kostenlos)

---

## Phase 6: Content & SEO

**Ziel:** Organischer Traffic

- [ ] Produktvergleiche schreiben
  - [ ] "Tado vs Homematic IP"
  - [ ] "Tado vs Netatmo"
- [ ] Kaufberatungen
  - [ ] "Thermostat für Gasheizung"
  - [ ] "Thermostat für Mietwohnung"
  - [ ] "Thermostat ohne Gateway"
- [ ] Kompatibilitäts-Guides
  - [ ] "Thermostat mit HomeKit"
  - [ ] "Thermostat mit Matter"
- [ ] Long-Tail SEO optimieren

---

## Phase 7: Erweiterungen (später)

- [ ] Preis-Alerts per E-Mail
- [ ] Newsletter
- [ ] Sommer-Erweiterung: Klimasteuerung, Rolladen
- [ ] Multi-Shop: Conrad, Otto hinzufügen

---

## Meilensteine

| Meilenstein | Ziel |
|-------------|------|
| **M0** | Landing Page live, bei tink.de beworben |
| **M1** | tink.de Feed importiert |
| **M2** | Erste Produktseite live |
| **M3** | Preisverlauf funktioniert |
| **M4** | KI-Kaufberater funktioniert |
| **M5** | Erster Affiliate-Sale |
| **M6** | 1.000 Besucher/Monat |

---

## Nächste Schritte (heute)

1. Domain-Verfügbarkeit prüfen bei Strato
2. Landing Page erstellen
3. Bei Strato deployen
4. AWIN Profil aktualisieren
5. Bei tink.de bewerben
