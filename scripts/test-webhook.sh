#!/bin/bash

# Test script for Retell → n8n webhooks
# Usage: ./test-webhook.sh <n8n-base-url>

N8N_URL="${1:-http://localhost:5678}"

echo "Testing Retell → n8n → Dolibarr integration"
echo "n8n URL: $N8N_URL"
echo ""

# Test voice webhook
echo "=== Testing Voice Webhook ==="
curl -s -X POST "$N8N_URL/webhook/retell-call" \
  -H "Content-Type: application/json" \
  -d '{
    "call_id": "test-voice-'$(date +%s)'",
    "from_number": "+15551234567",
    "call_duration_seconds": 185,
    "transcript": "AI: Hello, thanks for calling! How can I help you today?\nCustomer: Hi, I am looking for help with a new website for my business.\nAI: Great! I would be happy to help. What kind of business do you have?\nCustomer: I run a small restaurant called Joes Diner.\nAI: Nice! And do you have a timeline in mind for when you would like the website ready?\nCustomer: Ideally in the next month or so.\nAI: Got it. And do you have a budget range you are working with?\nCustomer: Probably around 2 to 3 thousand dollars.\nAI: Perfect. Can I get your email so someone can follow up with a quote?\nCustomer: Sure, its joe@joesdiner.com\nAI: Great, joe@joesdiner.com. Someone will be in touch within 24 hours. Anything else I can help with?\nCustomer: No that is it, thanks!\nAI: Thanks for calling, have a great day!",
    "call_analysis": {
      "extracted_fields": {
        "caller_name": "Joe",
        "company_name": "Joes Diner",
        "email": "joe@joesdiner.com",
        "service_interest": "restaurant website",
        "budget_range": "$2,000-3,000",
        "timeline": "1 month",
        "pain_points": "needs new website for business",
        "decision_maker": true,
        "lead_quality": "hot",
        "summary": "Joe from Joes Diner needs a restaurant website within a month, budget $2-3k. Email provided for follow-up."
      }
    }
  }' | jq . 2>/dev/null || cat

echo ""
echo ""

# Test SMS webhook
echo "=== Testing SMS Webhook ==="
curl -s -X POST "$N8N_URL/webhook/retell-sms" \
  -H "Content-Type: application/json" \
  -d '{
    "conversation_id": "test-sms-'$(date +%s)'",
    "from_number": "+15559876543",
    "messages": [
      {"role": "user", "content": "Hi do you do web design?"},
      {"role": "assistant", "content": "Hi! Yes we do. What kind of project are you thinking about?"},
      {"role": "user", "content": "I need a site for my photography business"},
      {"role": "assistant", "content": "Nice! Do you have a timeline in mind?"},
      {"role": "user", "content": "Next couple months ideally"},
      {"role": "assistant", "content": "Got it. Whats the best email to send some info to?"},
      {"role": "user", "content": "sarah@sarahphotos.com"}
    ],
    "extracted_fields": {
      "caller_name": "Sarah",
      "company_name": "Sarah Photos",
      "email": "sarah@sarahphotos.com",
      "service_interest": "photography website",
      "timeline": "2 months",
      "lead_quality": "warm"
    }
  }' | jq . 2>/dev/null || cat

echo ""
echo ""
echo "=== Done ==="
echo "Check your n8n executions and Dolibarr for new leads."
