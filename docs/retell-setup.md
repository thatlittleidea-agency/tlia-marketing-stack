# Retell AI + n8n + Dolibarr Integration

## Voice & SMS Lead Capture System

### Overview

This system provides a conversational AI receptionist that handles inbound calls and SMS, qualifies leads through natural conversation, and pushes structured lead data to Dolibarr CRM.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            INBOUND CHANNELS                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│    ┌──────────────┐         ┌──────────────┐                                │
│    │   Phone      │         │    SMS       │                                │
│    │   Call       │         │   Message    │                                │
│    └──────┬───────┘         └──────┬───────┘                                │
│           │                        │                                         │
│           ▼                        ▼                                         │
│    ┌─────────────────────────────────────────┐                              │
│    │              TWILIO                      │                              │
│    │         (Your existing number)           │                              │
│    │    SIP Trunk / Programmable Messaging    │                              │
│    └─────────────────┬───────────────────────┘                              │
│                      │                                                       │
└──────────────────────┼───────────────────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          RETELL AI PLATFORM                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│    ┌─────────────────────────────────────────────────────────────────┐      │
│    │                      AI AGENT                                    │      │
│    │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │      │
│    │  │ Voice Engine│  │    LLM      │  │ SMS Handler │              │      │
│    │  │ (ElevenLabs)│  │  (Claude)   │  │             │              │      │
│    │  └─────────────┘  └─────────────┘  └─────────────┘              │      │
│    │                                                                  │      │
│    │  System Prompt: Warm receptionist personality                    │      │
│    │  Knowledge Base: Services, pricing, FAQs                         │      │
│    │  Data Extraction: Name, company, need, budget, timeline          │      │
│    └─────────────────────────────────────────────────────────────────┘      │
│                      │                                                       │
│                      │ Webhook (call_ended / sms_received)                   │
│                      ▼                                                       │
└──────────────────────┼───────────────────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              n8n WORKFLOW                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│    ┌──────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────┐    │
│    │ Webhook  │───▶│ Parse Lead   │───▶│ Enrich Data  │───▶│ Dolibarr │    │
│    │ Trigger  │    │ Data         │    │ (optional)   │    │ API      │    │
│    └──────────┘    └──────────────┘    └──────────────┘    └──────────┘    │
│                                                                              │
│    Receives:                Extracts:              Creates:                  │
│    - transcript             - contact info         - Third Party             │
│    - call metadata          - qualification        - Contact                 │
│    - extracted data         - lead score           - Opportunity             │
│                                                    - Activity log            │
└─────────────────────────────────────────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                            DOLIBARR CRM                                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│    ┌────────────────┐   ┌────────────────┐   ┌────────────────┐            │
│    │  Third Party   │   │  Opportunity   │   │   Activity     │            │
│    │  (Company)     │   │  (Lead/Deal)   │   │   (Call Log)   │            │
│    └────────────────┘   └────────────────┘   └────────────────┘            │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Project Structure

```
retell-dolibarr/
├── README.md
├── .env.example
├── .gitignore
│
├── retell/
│   ├── agent-config.json          # Retell agent configuration
│   ├── system-prompt.md           # AI personality & instructions
│   └── knowledge-base.md          # Your services, FAQs, pricing
│
├── n8n/
│   ├── workflows/
│   │   ├── retell-voice-webhook.json    # Voice call handler
│   │   └── retell-sms-webhook.json      # SMS handler
│   └── credentials-setup.md
│
├── dolibarr/
│   ├── api-examples/
│   │   ├── create-thirdparty.sh
│   │   ├── create-contact.sh
│   │   └── create-opportunity.sh
│   └── module-requirements.md
│
└── scripts/
    ├── test-webhook.sh            # Test n8n webhook locally
    └── validate-setup.sh          # Verify all connections
```

---

## Phase 1: Retell AI Setup

### 1.1 Create Retell Account & Agent

```bash
# Sign up at https://www.retellai.com/
# Get API key from dashboard
```

### 1.2 Agent Configuration

Create `retell/agent-config.json`:

```json
{
  "agent_name": "Reception AI",
  "voice_id": "elevenlabs_rachel",
  "language": "en-US",
  "llm_model": "claude-3-5-sonnet",
  "response_engine": {
    "type": "retell_llm",
    "llm_id": null
  },
  "voice_settings": {
    "stability": 0.7,
    "similarity_boost": 0.8
  },
  "conversation_settings": {
    "interruption_sensitivity": 0.8,
    "ambient_sound": "off",
    "responsiveness": 0.9,
    "enable_backchannel": true,
    "backchannel_frequency": 0.6
  },
  "post_call_analysis": {
    "enabled": true,
    "extract_fields": [
      "caller_name",
      "company_name",
      "email",
      "phone_number",
      "service_interest",
      "budget_range",
      "timeline",
      "pain_points",
      "lead_score"
    ]
  },
  "webhook_url": "https://your-n8n-instance.com/webhook/retell-call",
  "sms_webhook_url": "https://your-n8n-instance.com/webhook/retell-sms"
}
```

### 1.3 System Prompt

Create `retell/system-prompt.md`:

```markdown
# Role

You are the friendly receptionist for [YOUR BUSINESS NAME]. You're warm, helpful, and genuinely interested in understanding what callers need.

# Personality

- Conversational and natural, not corporate or robotic
- Use the caller's name once you learn it
- Be curious and ask follow-up questions
- If you don't know something, be honest: "I'm not sure about that, but I can have someone get back to you with details"
- Keep responses concise for voice (1-2 sentences typically)

# Your Goals

1. Greet warmly and ask how you can help
2. Understand what they're looking for
3. Collect their contact information naturally
4. Qualify the lead (budget, timeline, decision-making)
5. Set expectations for follow-up

# Information to Collect

Gather these naturally through conversation (don't interrogate):
- Name
- Company (if applicable)
- Email or phone for follow-up
- What service/help they need
- Rough budget or budget range
- Timeline/urgency
- Any specific pain points

# Qualifying Questions (ask naturally, not as a checklist)

- "What's prompting you to look into this now?"
- "Do you have a timeline in mind?"
- "Have you worked with [service type] before?"
- "Is there a budget range you're working within?"

# Handling Common Scenarios

**Pricing questions:**
"Our pricing depends on the scope of what you need. Typically [give range]. I can have someone put together a specific quote for you."

**Technical questions you don't know:**
"That's a great question - I want to make sure you get accurate info. Can I have our team follow up with you on that?"

**Spam/sales calls:**
Keep it brief and polite: "Thanks, but we're not interested. Have a good day."

**Angry/frustrated caller:**
Listen, empathize, don't get defensive: "I hear you, that sounds frustrating. Let me make sure the right person gets back to you today."

# Closing the Call

"Great talking with you, [name]. Someone from our team will [specific next step] by [timeframe]. Is there anything else I can help with before we go?"

# Knowledge Base

[REFERENCE: knowledge-base.md - Your services, pricing, FAQs]
```

### 1.4 Knowledge Base

Create `retell/knowledge-base.md`:

```markdown
# [YOUR BUSINESS NAME] - Knowledge Base

## About Us
[Brief description of your business - 2-3 sentences]

## Services We Offer

### Service 1: [Name]
- Description: [What it is]
- Typical price range: [Range]
- Timeline: [How long it takes]
- Good for: [Who benefits]

### Service 2: [Name]
[Repeat pattern]

## Frequently Asked Questions

**Q: Do you offer free consultations?**
A: [Your answer]

**Q: What areas do you serve?**
A: [Your answer]

**Q: How quickly can you start?**
A: [Your answer]

## Business Hours
[Your hours]

## Contact Information
- Phone: [Number]
- Email: [Email]
- Website: [URL]
```

---

## Phase 2: Twilio Integration with Retell

### 2.1 Connect Your Existing Twilio Number

In Retell dashboard:
1. Go to Phone Numbers → Import from Twilio
2. Enter Twilio Account SID and Auth Token
3. Select your existing number
4. Retell handles the SIP connection

### 2.2 SMS Setup

In Retell dashboard:
1. Go to SMS Settings
2. Connect same Twilio number
3. Configure webhook URL for SMS events

In Twilio console:
1. Go to your phone number settings
2. Set SMS webhook to Retell's SMS endpoint
3. (Retell provides this URL when you enable SMS)

---

## Phase 3: n8n Workflows

### 3.1 Voice Call Webhook Workflow

Create `n8n/workflows/retell-voice-webhook.json`:

```json
{
  "name": "Retell Voice → Dolibarr",
  "nodes": [
    {
      "name": "Webhook",
      "type": "n8n-nodes-base.webhook",
      "position": [250, 300],
      "parameters": {
        "path": "retell-call",
        "httpMethod": "POST",
        "responseMode": "onReceived",
        "responseData": "allEntries"
      }
    },
    {
      "name": "Parse Call Data",
      "type": "n8n-nodes-base.function",
      "position": [450, 300],
      "parameters": {
        "functionCode": "// Extract data from Retell webhook payload\nconst payload = $input.first().json;\n\n// Call metadata\nconst callId = payload.call_id;\nconst callDuration = payload.call_duration_seconds;\nconst callerNumber = payload.from_number;\nconst transcript = payload.transcript;\n\n// Extracted fields from post-call analysis\nconst extracted = payload.call_analysis?.extracted_fields || {};\n\n// Calculate lead score (simple example)\nlet leadScore = 0;\nif (extracted.budget_range) leadScore += 30;\nif (extracted.timeline) leadScore += 25;\nif (extracted.email) leadScore += 20;\nif (extracted.pain_points) leadScore += 15;\nif (callDuration > 120) leadScore += 10; // 2+ min call\n\nreturn {\n  json: {\n    // Contact info\n    caller_name: extracted.caller_name || 'Unknown',\n    company_name: extracted.company_name || '',\n    email: extracted.email || '',\n    phone: callerNumber,\n    \n    // Lead info\n    service_interest: extracted.service_interest || '',\n    budget_range: extracted.budget_range || '',\n    timeline: extracted.timeline || '',\n    pain_points: extracted.pain_points || '',\n    \n    // Metadata\n    lead_score: leadScore,\n    source: 'phone_call',\n    call_id: callId,\n    call_duration: callDuration,\n    transcript: transcript,\n    \n    // Timestamp\n    created_at: new Date().toISOString()\n  }\n};"
      }
    },
    {
      "name": "Check Existing ThirdParty",
      "type": "n8n-nodes-base.httpRequest",
      "position": [650, 300],
      "parameters": {
        "url": "={{ $env.DOLIBARR_URL }}/api/index.php/thirdparties",
        "method": "GET",
        "authentication": "genericCredentialType",
        "genericAuthType": "httpHeaderAuth",
        "qs": {
          "sqlfilters": "(t.phone:=:'{{ $json.phone }}')"
        }
      }
    },
    {
      "name": "Create or Update ThirdParty",
      "type": "n8n-nodes-base.httpRequest",
      "position": [850, 300],
      "parameters": {
        "url": "={{ $env.DOLIBARR_URL }}/api/index.php/thirdparties",
        "method": "POST",
        "authentication": "genericCredentialType",
        "genericAuthType": "httpHeaderAuth",
        "body": {
          "name": "={{ $json.company_name || $json.caller_name }}",
          "client": 2,
          "phone": "={{ $json.phone }}",
          "email": "={{ $json.email }}",
          "note_private": "Lead Score: {{ $json.lead_score }}\nInterest: {{ $json.service_interest }}\nBudget: {{ $json.budget_range }}\nTimeline: {{ $json.timeline }}\nSource: {{ $json.source }}"
        }
      }
    },
    {
      "name": "Create Opportunity",
      "type": "n8n-nodes-base.httpRequest",
      "position": [1050, 300],
      "parameters": {
        "url": "={{ $env.DOLIBARR_URL }}/api/index.php/projects",
        "method": "POST",
        "authentication": "genericCredentialType",
        "genericAuthType": "httpHeaderAuth",
        "body": {
          "ref": "LEAD-{{ $now.format('yyyyMMdd') }}-{{ $json.call_id.slice(-4) }}",
          "title": "Lead: {{ $json.caller_name }} - {{ $json.service_interest }}",
          "socid": "={{ $node['Create or Update ThirdParty'].json.id }}",
          "description": "Budget: {{ $json.budget_range }}\nTimeline: {{ $json.timeline }}\nPain Points: {{ $json.pain_points }}\n\n--- Transcript ---\n{{ $json.transcript }}",
          "opp_status": 1,
          "opp_amount": 0,
          "opp_percent": "={{ $json.lead_score }}"
        }
      }
    },
    {
      "name": "Log Activity",
      "type": "n8n-nodes-base.httpRequest",
      "position": [1250, 300],
      "parameters": {
        "url": "={{ $env.DOLIBARR_URL }}/api/index.php/agendaevents",
        "method": "POST",
        "authentication": "genericCredentialType",
        "genericAuthType": "httpHeaderAuth",
        "body": {
          "type_code": "AC_TEL",
          "label": "AI Call: {{ $json.caller_name }}",
          "socid": "={{ $node['Create or Update ThirdParty'].json.id }}",
          "datep": "={{ $now.toISO() }}",
          "datef": "={{ $now.plus({ seconds: $json.call_duration }).toISO() }}",
          "note": "Duration: {{ $json.call_duration }}s\nLead Score: {{ $json.lead_score }}\n\n{{ $json.transcript }}"
        }
      }
    }
  ],
  "connections": {
    "Webhook": {
      "main": [[{ "node": "Parse Call Data", "type": "main", "index": 0 }]]
    },
    "Parse Call Data": {
      "main": [[{ "node": "Check Existing ThirdParty", "type": "main", "index": 0 }]]
    },
    "Check Existing ThirdParty": {
      "main": [[{ "node": "Create or Update ThirdParty", "type": "main", "index": 0 }]]
    },
    "Create or Update ThirdParty": {
      "main": [[{ "node": "Create Opportunity", "type": "main", "index": 0 }]]
    },
    "Create Opportunity": {
      "main": [[{ "node": "Log Activity", "type": "main", "index": 0 }]]
    }
  }
}
```

### 3.2 SMS Webhook Workflow

Create `n8n/workflows/retell-sms-webhook.json`:

```json
{
  "name": "Retell SMS → Dolibarr",
  "nodes": [
    {
      "name": "Webhook",
      "type": "n8n-nodes-base.webhook",
      "position": [250, 300],
      "parameters": {
        "path": "retell-sms",
        "httpMethod": "POST",
        "responseMode": "onReceived"
      }
    },
    {
      "name": "Parse SMS Data",
      "type": "n8n-nodes-base.function",
      "position": [450, 300],
      "parameters": {
        "functionCode": "const payload = $input.first().json;\n\n// SMS conversation metadata\nconst conversationId = payload.conversation_id;\nconst phoneNumber = payload.from_number;\nconst messages = payload.messages || [];\n\n// Get extracted data if conversation ended\nconst extracted = payload.extracted_fields || {};\n\n// Build conversation transcript\nconst transcript = messages.map(m => \n  `${m.role === 'user' ? 'Customer' : 'AI'}: ${m.content}`\n).join('\\n');\n\n// Lead score for SMS (typically lower than calls)\nlet leadScore = 0;\nif (extracted.email) leadScore += 25;\nif (extracted.service_interest) leadScore += 20;\nif (extracted.budget_range) leadScore += 20;\nif (messages.length > 4) leadScore += 15; // Engaged conversation\n\nreturn {\n  json: {\n    caller_name: extracted.caller_name || 'SMS Lead',\n    company_name: extracted.company_name || '',\n    email: extracted.email || '',\n    phone: phoneNumber,\n    service_interest: extracted.service_interest || '',\n    budget_range: extracted.budget_range || '',\n    timeline: extracted.timeline || '',\n    lead_score: leadScore,\n    source: 'sms',\n    conversation_id: conversationId,\n    transcript: transcript,\n    message_count: messages.length,\n    created_at: new Date().toISOString()\n  }\n};"
      }
    },
    {
      "name": "Create ThirdParty",
      "type": "n8n-nodes-base.httpRequest",
      "position": [650, 300],
      "parameters": {
        "url": "={{ $env.DOLIBARR_URL }}/api/index.php/thirdparties",
        "method": "POST",
        "authentication": "genericCredentialType",
        "genericAuthType": "httpHeaderAuth",
        "body": {
          "name": "={{ $json.company_name || $json.caller_name }}",
          "client": 2,
          "phone": "={{ $json.phone }}",
          "email": "={{ $json.email }}",
          "note_private": "Lead Score: {{ $json.lead_score }}\nSource: SMS\nInterest: {{ $json.service_interest }}"
        }
      }
    },
    {
      "name": "Create Opportunity",
      "type": "n8n-nodes-base.httpRequest",
      "position": [850, 300],
      "parameters": {
        "url": "={{ $env.DOLIBARR_URL }}/api/index.php/projects",
        "method": "POST",
        "authentication": "genericCredentialType",
        "genericAuthType": "httpHeaderAuth",
        "body": {
          "ref": "SMS-{{ $now.format('yyyyMMdd') }}-{{ $json.conversation_id.slice(-4) }}",
          "title": "SMS Lead: {{ $json.caller_name }}",
          "socid": "={{ $node['Create ThirdParty'].json.id }}",
          "description": "{{ $json.service_interest }}\n\n--- SMS Conversation ---\n{{ $json.transcript }}",
          "opp_status": 1,
          "opp_percent": "={{ $json.lead_score }}"
        }
      }
    }
  ],
  "connections": {
    "Webhook": {
      "main": [[{ "node": "Parse SMS Data", "type": "main", "index": 0 }]]
    },
    "Parse SMS Data": {
      "main": [[{ "node": "Create ThirdParty", "type": "main", "index": 0 }]]
    },
    "Create ThirdParty": {
      "main": [[{ "node": "Create Opportunity", "type": "main", "index": 0 }]]
    }
  }
}
```

---

## Phase 4: Dolibarr Configuration

### 4.1 Enable Required Modules

In Dolibarr admin:
1. **Third Parties** (Customers/Prospects) - enabled
2. **Projects/Opportunities** - enabled  
3. **Agenda** (for activity logging) - enabled
4. **API/Web Services** - enabled

### 4.2 Generate API Key

1. Go to: Home → Setup → Security → API
2. Enable REST API
3. Create API user or use existing user
4. Generate API key (DOLAPIKEY)

### 4.3 Test API Connection

Create `dolibarr/api-examples/test-connection.sh`:

```bash
#!/bin/bash

DOLIBARR_URL="https://your-dolibarr.com"
API_KEY="your-api-key"

# Test API connection
curl -s -X GET \
  "${DOLIBARR_URL}/api/index.php/status" \
  -H "DOLAPIKEY: ${API_KEY}" \
  -H "Content-Type: application/json"
```

### 4.4 API Examples

Create `dolibarr/api-examples/create-thirdparty.sh`:

```bash
#!/bin/bash

curl -X POST "${DOLIBARR_URL}/api/index.php/thirdparties" \
  -H "DOLAPIKEY: ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Acme Corp",
    "client": 2,
    "phone": "+15551234567",
    "email": "contact@acme.com",
    "note_private": "Lead from AI receptionist"
  }'
```

---

## Phase 5: Environment Configuration

### 5.1 Environment Variables

Create `.env.example`:

```bash
# Retell AI
RETELL_API_KEY=your_retell_api_key
RETELL_AGENT_ID=your_agent_id

# Twilio (your existing credentials)
TWILIO_ACCOUNT_SID=your_account_sid
TWILIO_AUTH_TOKEN=your_auth_token
TWILIO_PHONE_NUMBER=+15551234567

# n8n
N8N_WEBHOOK_BASE_URL=https://your-n8n.com/webhook

# Dolibarr
DOLIBARR_URL=https://your-dolibarr.com
DOLIBARR_API_KEY=your_dolibarr_api_key
```

### 5.2 Git Ignore

Create `.gitignore`:

```
.env
*.log
node_modules/
__pycache__/
.DS_Store
```

---

## Phase 6: Deployment Checklist

### 6.1 Pre-Deployment

- [ ] Retell account created and funded
- [ ] Agent configured with system prompt
- [ ] Knowledge base populated with your business info
- [ ] Twilio number connected to Retell
- [ ] n8n workflows imported
- [ ] Dolibarr API enabled and key generated
- [ ] Environment variables set in production

### 6.2 Testing Sequence

1. **Test Retell agent standalone**
   - Use Retell's test call feature in dashboard
   - Verify voice quality and conversation flow

2. **Test n8n webhook**
   ```bash
   # Simulate Retell webhook payload
   curl -X POST https://your-n8n.com/webhook/retell-call \
     -H "Content-Type: application/json" \
     -d '{"call_id":"test123","from_number":"+15551234567","transcript":"Test call","call_analysis":{"extracted_fields":{"caller_name":"John Test"}}}'
   ```

3. **Test Dolibarr API**
   - Verify third party was created
   - Verify opportunity was created
   - Check activity log

4. **End-to-end test**
   - Call your Twilio number
   - Have real conversation with AI
   - Verify lead appears in Dolibarr

### 6.3 Go Live

1. Update Twilio webhook to point to Retell
2. Enable SMS webhook
3. Monitor first few calls in Retell dashboard
4. Check n8n execution logs
5. Verify leads in Dolibarr

---

## Estimated Costs (Low Volume)

| Service | Monthly Cost |
|---------|-------------|
| Retell AI (voice) | ~$0.14/min → $5-15 |
| Retell AI (SMS) | ~$0.002/msg → $1-5 |
| Twilio (existing) | Already paying |
| n8n (self-hosted) | $0 |
| Dolibarr (self-hosted) | $0 |
| **Total** | **~$10-25/month** |

---

## Troubleshooting

### Call not reaching Retell
- Check Twilio webhook URL in phone number settings
- Verify Retell agent is active
- Check Retell dashboard for error logs

### n8n not receiving webhooks
- Verify webhook URL is publicly accessible
- Check n8n is running and workflow is active
- Test with curl to webhook endpoint

### Leads not appearing in Dolibarr
- Verify API key is correct
- Check n8n execution logs for API errors
- Test Dolibarr API directly with curl

### AI responses seem off
- Review and update system prompt
- Add more examples to knowledge base
- Check Retell dashboard for conversation logs
