# Technische Architektur

**Stand:** 2025-12-15
**Fokus:** Smart Home Heizungsautomatisierung

---

## 1. Übersicht

```
┌─────────────────────────────────────────────────────────────┐
│                    Landing Page (Strato)                     │
│              thermostat-vergleich.de (o.ä.)                 │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼ (später)
┌─────────────────────────────────────────────────────────────┐
│                      Hetzner VPS                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │  FastAPI    │  │ PostgreSQL  │  │   Qdrant    │         │
│  │  Backend    │──│  Database   │──│ Vector DB   │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
│         │                                                   │
│         ▼                                                   │
│  ┌─────────────┐                                           │
│  │   Next.js   │                                           │
│  │  Frontend   │                                           │
│  └─────────────┘                                           │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Tech Stack

| Komponente | Technologie | Warum |
|------------|-------------|-------|
| Backend | Python FastAPI | Async, modern, schnell |
| Datenbank | PostgreSQL | Robust, JSON-Support |
| Vektor-DB | Qdrant | Hybrid Search (BM25 + Dense) |
| Embeddings | FastEmbed | Lokal, keine API-Kosten |
| Frontend | Next.js | SSR für SEO |
| Hosting | Hetzner VPS (CX31) | Günstig (~15€), DE-Server |
| KI | GPT-4o-mini / Claude Haiku | Für Kaufberater |

---

## 3. Datenbank-Schema (PostgreSQL)

```sql
-- Produkte (Thermostate)
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    ean VARCHAR(13),
    name VARCHAR(500),
    brand VARCHAR(100),          -- Tado, Homematic IP, Netatmo, Fritz, Eve, Bosch
    model VARCHAR(200),
    product_type VARCHAR(50),    -- 'radiator_thermostat', 'room_thermostat', 'starter_kit', 'gateway'
    specs JSONB,                 -- Siehe Specs-Schema unten
    image_url TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Specs JSONB Struktur:
-- {
--   "heating_types": ["gas", "oil", "heat_pump", "floor_heating"],
--   "platforms": ["homekit", "google_home", "alexa", "matter", "home_assistant"],
--   "protocol": "thread" | "zigbee" | "wifi" | "dect",
--   "needs_gateway": true | false,
--   "gateway_id": 123,
--   "battery_type": "AA" | "rechargeable" | "wired",
--   "display": true | false
-- }

-- Kompatibilitäts-Matrix
CREATE TABLE compatibility (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(id),
    heating_type VARCHAR(50),    -- 'gas', 'oil', 'heat_pump', 'floor_heating', 'district'
    platform VARCHAR(50),        -- 'homekit', 'google_home', 'alexa', 'matter'
    compatible BOOLEAN,
    notes TEXT                   -- z.B. "Benötigt Bridge für HomeKit"
);

-- Shops
CREATE TABLE shops (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),           -- tink, Otto, Conrad
    awin_id VARCHAR(50),         -- AWIN Advertiser ID
    commission_rate DECIMAL(5,2),
    cookie_days INTEGER,
    feed_url TEXT,
    active BOOLEAN DEFAULT TRUE
);

-- Angebote
CREATE TABLE offers (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(id),
    shop_id INTEGER REFERENCES shops(id),
    price DECIMAL(10,2),
    deep_link TEXT,
    in_stock BOOLEAN,
    last_updated TIMESTAMP DEFAULT NOW(),
    UNIQUE(product_id, shop_id)
);

-- Preisverlauf
CREATE TABLE price_history (
    id SERIAL PRIMARY KEY,
    offer_id INTEGER REFERENCES offers(id),
    price DECIMAL(10,2),
    recorded_at DATE DEFAULT CURRENT_DATE
);

-- Indizes
CREATE INDEX idx_products_brand ON products(brand);
CREATE INDEX idx_products_type ON products(product_type);
CREATE INDEX idx_compatibility_heating ON compatibility(heating_type);
CREATE INDEX idx_compatibility_platform ON compatibility(platform);
CREATE INDEX idx_offers_product ON offers(product_id);
CREATE INDEX idx_price_history_offer ON price_history(offer_id);
CREATE INDEX idx_price_history_date ON price_history(recorded_at);
```

---

## 4. KI-Kaufberater Pipeline (RAG)

```
User: "Ich habe Gasheizung, 5 Zimmer, Apple HomeKit, Budget 400€"
                    │
                    ▼
┌─────────────────────────────────────┐
│  1. Query-Verarbeitung              │
│     → Heizungstyp: Gas              │
│     → Zimmer: 5                     │
│     → Plattform: HomeKit            │
│     → Budget: 400€                  │
└─────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────┐
│  2. Kompatibilitäts-Check           │
│     → Welche Marken: Gas + HomeKit? │
│     → Gateway nötig?                │
│     → Tado ✓, Netatmo ✓, Eve ✓     │
└─────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────┐
│  3. Hybrid Search (Qdrant)          │
│     → BM25 (Keywords)               │
│     → Dense Embeddings (Semantik)   │
│     → RRF Fusion                    │
└─────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────┐
│  4. Bundle-Berechnung               │
│     → Starter Kit + X Thermostate   │
│     → Aktuelle Preise               │
│     → Unter Budget? ✓/✗            │
└─────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────┐
│  5. RAG Response (LLM)              │
│     → GPT-4o-mini                   │
│     → Personalisierte Empfehlung    │
│     → Affiliate-Links               │
└─────────────────────────────────────┘
```

### Beispiel-Response

```
"Für deine Anforderungen empfehle ich Tado:

✅ Tado Starter Kit V3+ (Bridge + 2 Thermostate) - 179€
✅ 3x Tado Zusatz-Thermostat - je 59€ = 177€
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Gesamt: 356€ ✓ (unter Budget)

Warum Tado?
• ✓ Kompatibel mit Gasheizung
• ✓ Apple HomeKit zertifiziert
• ✓ Matter-Support für Zukunftssicherheit

💡 Tipp: Aktuell 15% günstiger als vor 30 Tagen!

[Jetzt bei tink.de ansehen →]"
```

---

## 5. Feed-Import Pipeline

```
AWIN Product Feed (CSV/XML)
        │
        ▼
┌─────────────────────────────────────┐
│  1. Download (täglich, cron)        │
│     → tink.de Feed                  │
│     → Filter: Kategorie Heizung     │
└─────────────────────────────────────┘
        │
        ▼
┌─────────────────────────────────────┐
│  2. Parse & Normalize               │
│     → EAN extrahieren               │
│     → Marke/Modell erkennen         │
│     → Preis normalisieren           │
└─────────────────────────────────────┘
        │
        ▼
┌─────────────────────────────────────┐
│  3. Upsert in Datenbank             │
│     → Produkt anlegen/updaten       │
│     → Angebot anlegen/updaten       │
│     → Preisverlauf speichern        │
└─────────────────────────────────────┘
        │
        ▼
┌─────────────────────────────────────┐
│  4. Embeddings generieren           │
│     → FastEmbed (lokal)             │
│     → In Qdrant speichern           │
└─────────────────────────────────────┘
```

---

## 6. Docker Compose

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:16
    environment:
      POSTGRES_DB: thermostat
      POSTGRES_USER: thermostat
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  qdrant:
    image: qdrant/qdrant:latest
    volumes:
      - qdrant_data:/qdrant/storage
    ports:
      - "6333:6333"
      - "6334:6334"

  api:
    build: ./api
    environment:
      DATABASE_URL: postgresql://thermostat:${DB_PASSWORD}@postgres/thermostat
      QDRANT_HOST: qdrant
      OPENAI_API_KEY: ${OPENAI_API_KEY}
    ports:
      - "8000:8000"
    depends_on:
      - postgres
      - qdrant

volumes:
  postgres_data:
  qdrant_data:
```

---

## 7. API Endpoints (geplant)

| Endpoint | Methode | Beschreibung |
|----------|---------|--------------|
| `/products` | GET | Produktliste mit Filtern |
| `/products/{id}` | GET | Produktdetails |
| `/products/{id}/prices` | GET | Preisverlauf |
| `/search` | GET | Hybrid-Suche |
| `/compatibility` | GET | Kompatibilitäts-Check |
| `/advisor` | POST | KI-Kaufberater |
| `/shops` | GET | Shop-Liste |

---

## 8. Kosten

| Posten | Kosten/Monat |
|--------|--------------|
| Hetzner VPS (CX31) | ~15€ |
| Domain (.de) | ~1€ |
| KI-API (GPT-4o-mini) | ~5-20€ |
| **Gesamt** | **~20-35€** |
