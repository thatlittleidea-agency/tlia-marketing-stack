# n8n Credentials Setup

## Required Credentials

### 1. Dolibarr API (HTTP Header Auth)

In n8n, go to **Credentials** → **New** → **HTTP Header Auth**

**Name:** `Dolibarr API`

**Header Name:** `DOLAPIKEY`

**Header Value:** Your Dolibarr API key

---

## Environment Variables

Set these in your n8n instance:

```bash
# In docker-compose.yml or environment
N8N_ENCRYPTION_KEY=your-encryption-key

# Custom env vars used in workflows
DOLIBARR_URL=https://your-dolibarr-instance.com
```

### Setting Environment Variables in n8n

**Docker Compose:**
```yaml
services:
  n8n:
    environment:
      - DOLIBARR_URL=https://your-dolibarr.com
```

**Standalone:**
```bash
export DOLIBARR_URL=https://your-dolibarr.com
n8n start
```

---

## Importing Workflows

1. Go to **Workflows** → **Import from File**
2. Select `retell-voice-webhook.json`
3. Repeat for `retell-sms-webhook.json`
4. Update credentials in each HTTP Request node
5. Activate both workflows

---

## Webhook URLs

After importing, your webhook URLs will be:

- **Voice:** `https://your-n8n.com/webhook/retell-call`
- **SMS:** `https://your-n8n.com/webhook/retell-sms`

Use these URLs in your Retell agent configuration.

---

## Testing Webhooks

Use the test script in `/scripts/test-webhook.sh` or:

```bash
# Test voice webhook
curl -X POST https://your-n8n.com/webhook/retell-call \
  -H "Content-Type: application/json" \
  -d '{
    "call_id": "test-123",
    "from_number": "+15551234567",
    "call_duration_seconds": 180,
    "transcript": "AI: Hello, thanks for calling! How can I help?\nCustomer: Hi, I need help with a website.",
    "call_analysis": {
      "extracted_fields": {
        "caller_name": "John Test",
        "service_interest": "website development",
        "lead_quality": "warm"
      }
    }
  }'

# Test SMS webhook
curl -X POST https://your-n8n.com/webhook/retell-sms \
  -H "Content-Type: application/json" \
  -d '{
    "conversation_id": "sms-test-456",
    "from_number": "+15559876543",
    "messages": [
      {"role": "user", "content": "Hi, do you do web design?"},
      {"role": "assistant", "content": "Hi! Yes we do. What kind of project are you thinking about?"},
      {"role": "user", "content": "I need a new site for my restaurant"}
    ],
    "extracted_fields": {
      "caller_name": "Jane Test",
      "service_interest": "restaurant website"
    }
  }'
```

---

## Troubleshooting

### Webhook not receiving data

1. Check workflow is **Active** (toggle on)
2. Verify URL is publicly accessible
3. Check n8n logs: `docker logs n8n`

### Dolibarr API errors

1. Verify API key is correct
2. Check API is enabled in Dolibarr (Setup → Security → API)
3. Test API directly:
   ```bash
   curl -H "DOLAPIKEY: your-key" https://your-dolibarr.com/api/index.php/status
   ```

### Missing environment variables

Error: `$env.DOLIBARR_URL is undefined`

Solution: Set environment variable in n8n config (see above)
