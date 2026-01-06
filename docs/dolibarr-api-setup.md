# Dolibarr Module Requirements

## Required Modules

Enable these in **Home → Setup → Modules/Applications**:

- [x] **Third Parties** - Customers/Prospects
- [x] **Projects** - Enable "Opportunities" in settings
- [x] **Agenda** - Calendar/Activity logging
- [x] **REST API** - In Setup → Security → API

---

## API Setup

### 1. Enable REST API
Go to **Setup → Security → API** and enable it.

### 2. Create API User
1. Users & Groups → New User
2. Username: `api_user`
3. Grant permissions for Third Parties, Projects, Agenda

### 3. Generate API Key
1. Go to API user's card → Modify
2. Generate API Key → Copy and save

---

## Test API Connection

```bash
# Test status
curl -H "DOLAPIKEY: your-key" https://your-dolibarr.com/api/index.php/status

# Test create third party
curl -X POST https://your-dolibarr.com/api/index.php/thirdparties \
  -H "DOLAPIKEY: your-key" \
  -H "Content-Type: application/json" \
  -d '{"name": "Test", "client": 2, "phone": "+15551234567"}'
```

---

## Activity Types

Ensure these exist in **Setup → Dictionaries → Event types**:
- `AC_TEL` - Phone call (for voice)
- `AC_OTH` - Other (for SMS)
