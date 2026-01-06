#!/bin/bash

# Validate Retell + n8n + Dolibarr setup
# Usage: ./validate-setup.sh

echo "========================================"
echo "  Setup Validation Script"
echo "========================================"
echo ""

# Load .env if exists
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | xargs)
  echo "✓ Loaded .env file"
else
  echo "⚠ No .env file found - using environment variables"
fi

ERRORS=0

# Check required env vars
echo ""
echo "=== Checking Environment Variables ==="

check_var() {
  if [ -z "${!1}" ]; then
    echo "✗ $1 is not set"
    ERRORS=$((ERRORS + 1))
  else
    echo "✓ $1 is set"
  fi
}

check_var "RETELL_API_KEY"
check_var "TWILIO_ACCOUNT_SID"
check_var "TWILIO_AUTH_TOKEN"
check_var "N8N_WEBHOOK_BASE_URL"
check_var "DOLIBARR_URL"
check_var "DOLIBARR_API_KEY"

# Test Dolibarr API
echo ""
echo "=== Testing Dolibarr API ==="

if [ -n "$DOLIBARR_URL" ] && [ -n "$DOLIBARR_API_KEY" ]; then
  RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "DOLAPIKEY: $DOLIBARR_API_KEY" \
    "$DOLIBARR_URL/api/index.php/status")
  
  if [ "$RESPONSE" = "200" ]; then
    echo "✓ Dolibarr API is accessible"
  else
    echo "✗ Dolibarr API returned status $RESPONSE"
    ERRORS=$((ERRORS + 1))
  fi
else
  echo "⚠ Skipping Dolibarr test (missing credentials)"
fi

# Test n8n webhook endpoint
echo ""
echo "=== Testing n8n Webhooks ==="

if [ -n "$N8N_WEBHOOK_BASE_URL" ]; then
  # Test voice webhook (expect 200 or 404 if not activated)
  VOICE_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
    -X POST "$N8N_WEBHOOK_BASE_URL/retell-call" \
    -H "Content-Type: application/json" \
    -d '{"test": true}')
  
  if [ "$VOICE_RESPONSE" = "200" ]; then
    echo "✓ Voice webhook is accessible"
  elif [ "$VOICE_RESPONSE" = "404" ]; then
    echo "⚠ Voice webhook returned 404 (workflow may not be active)"
  else
    echo "✗ Voice webhook returned $VOICE_RESPONSE"
    ERRORS=$((ERRORS + 1))
  fi
  
  # Test SMS webhook
  SMS_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
    -X POST "$N8N_WEBHOOK_BASE_URL/retell-sms" \
    -H "Content-Type: application/json" \
    -d '{"test": true}')
  
  if [ "$SMS_RESPONSE" = "200" ]; then
    echo "✓ SMS webhook is accessible"
  elif [ "$SMS_RESPONSE" = "404" ]; then
    echo "⚠ SMS webhook returned 404 (workflow may not be active)"
  else
    echo "✗ SMS webhook returned $SMS_RESPONSE"
    ERRORS=$((ERRORS + 1))
  fi
else
  echo "⚠ Skipping n8n test (N8N_WEBHOOK_BASE_URL not set)"
fi

# Check files exist
echo ""
echo "=== Checking Project Files ==="

check_file() {
  if [ -f "$1" ]; then
    echo "✓ $1 exists"
  else
    echo "✗ $1 missing"
    ERRORS=$((ERRORS + 1))
  fi
}

check_file "retell/system-prompt.md"
check_file "retell/knowledge-base.md"
check_file "retell/agent-config.json"
check_file "n8n/workflows/retell-voice-webhook.json"
check_file "n8n/workflows/retell-sms-webhook.json"

# Summary
echo ""
echo "========================================"
if [ $ERRORS -eq 0 ]; then
  echo "  ✓ All checks passed!"
else
  echo "  ✗ $ERRORS issue(s) found"
fi
echo "========================================"

exit $ERRORS
