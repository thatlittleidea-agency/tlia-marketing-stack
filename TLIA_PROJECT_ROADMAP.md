# TLIA Project Roadmap

## That Little Idea - Digital Marketing Agency Stack

Comprehensive documentation for the self-hosted, open-source marketing technology platform.

---

## 1. Project Vision

Build a low-cost, high-impact digital marketing platform using open-source tools to provide enterprise-level marketing capabilities without expensive SaaS subscriptions.

### Core Objectives

- **Cost Efficiency**: Eliminate recurring SaaS fees by self-hosting
- **Data Ownership**: Full control over customer and analytics data
- **Integration**: Seamless workflow between all marketing tools
- **Scalability**: Architecture that grows with business needs
- **Reliability**: Production-grade infrastructure with proper monitoring

### Target Savings (Monthly)

| SaaS Alternative | Typical Cost | Our Cost | Savings |
|------------------|--------------|----------|---------|
| HubSpot/Marketo | $800-2000 | $0 | 100% |
| Zapier Pro | $50-100 | $0 | 100% |
| Salesforce | $150-300 | $0 | 100% |
| Bitly Pro | $35-200 | $0 | 100% |
| Google Analytics 360 | $150k/yr | $0 | 100% |
| Tableau | $70-840 | $0 | 100% |
| **VPS Hosting** | - | ~$20 | - |

---

## 2. Current Status

### Completed Items

- [x] VPS provisioned (74.208.99.12)
- [x] Domain configured (thatlittleidea.com)
- [x] Cloudflare DNS/CDN setup
- [x] CyberPanel installed
- [x] Docker & Docker Compose installed
- [x] Repository structure created
- [x] Docker Compose configuration
- [x] Environment variables template
- [x] Documentation framework

### In Progress

- [ ] Local development testing
- [ ] Service configuration files
- [ ] Nginx reverse proxy setup

### Pending

- [ ] SSL certificate automation
- [ ] Production deployment
- [ ] Service integrations
- [ ] Backup automation
- [ ] Monitoring setup

---

## 3. Architecture Overview

```
                                    INTERNET
                                        │
                                        ▼
                              ┌─────────────────┐
                              │   CLOUDFLARE    │
                              │   (DNS + CDN)   │
                              └────────┬────────┘
                                       │
                                       ▼
                              ┌─────────────────┐
                              │   VPS SERVER    │
                              │  74.208.99.12   │
                              └────────┬────────┘
                                       │
                              ┌────────┴────────┐
                              │   CYBERPANEL    │
                              │  (Server Mgmt)  │
                              └────────┬────────┘
                                       │
                    ┌──────────────────┼──────────────────┐
                    │                  │                  │
                    ▼                  ▼                  ▼
            ┌───────────────┐  ┌───────────────┐  ┌───────────────┐
            │    DOCKER     │  │    DOCKER     │  │    DOCKER     │
            │   NETWORK     │  │   VOLUMES     │  │   COMPOSE     │
            └───────┬───────┘  └───────────────┘  └───────────────┘
                    │
    ┌───────┬───────┼───────┬───────┬───────┬───────┐
    │       │       │       │       │       │       │
    ▼       ▼       ▼       ▼       ▼       ▼       ▼
┌──────┐┌──────┐┌──────┐┌──────┐┌──────┐┌──────┐┌──────┐
│Mautic││ N8N  ││EspoCRM││YOURLS││Matomo││Metab.││phpMA│
└──────┘└──────┘└──────┘└──────┘└──────┘└──────┘└──────┘
    │       │       │       │       │
    └───────┴───────┴───────┴───────┘
                    │
            ┌───────┴───────┐
            │  MySQL DBs    │
            │  (Per Service)│
            └───────────────┘
```

---

## 4. Service Mapping

| Service | Subdomain | Local Port | Prod Port | Purpose | Priority |
|---------|-----------|------------|-----------|---------|----------|
| **Mautic** | mautic.thatlittleidea.com | 8080 | 443 | Marketing Automation | P0 |
| **N8N** | n8n.thatlittleidea.com | 5678 | 443 | Workflow Automation | P0 |
| **EspoCRM** | crm.thatlittleidea.com | 8888 | 443 | CRM | P1 |
| **YOURLS** | links.thatlittleidea.com | 8181 | 443 | URL Shortener | P1 |
| **Matomo** | analytics.thatlittleidea.com | 8282 | 443 | Web Analytics | P1 |
| **Metabase** | bi.thatlittleidea.com | 3000 | 443 | Business Intelligence | P2 |
| **phpMyAdmin** | - | 8090 | - | DB Management (Dev) | P3 |

### Priority Legend

- **P0**: Critical - Deploy first
- **P1**: Important - Deploy after P0 stable
- **P2**: Enhancement - Deploy when resources allow
- **P3**: Development only - Not for production

---

## 5. Implementation Phases

### Phase 1: Foundation ✅ COMPLETE

**Objective**: Establish infrastructure base

- [x] Provision VPS with adequate resources
- [x] Configure domain DNS with Cloudflare
- [x] Install CyberPanel for server management
- [x] Install Docker and Docker Compose
- [x] Configure firewall rules
- [x] Set up SSH key authentication

### Phase 2: Local Development 🔄 IN PROGRESS

**Objective**: Test stack locally before production deployment

- [x] Create repository structure
- [x] Write Docker Compose configuration
- [x] Create environment variables
- [ ] Test `docker-compose up` locally
- [ ] Verify all services start correctly
- [ ] Test inter-service communication
- [ ] Document any issues/fixes

**Verification Commands**:
```bash
# Start all services
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f

# Test connectivity
curl http://localhost:8080  # Mautic
curl http://localhost:5678  # N8N
curl http://localhost:8888  # EspoCRM
```

### Phase 3: Core Services Deployment ⏳ PENDING

**Objective**: Deploy P0 and P1 services to production

#### 3.1 Mautic Deployment
- [ ] Create Cloudflare subdomain (mautic.thatlittleidea.com)
- [ ] Configure CyberPanel reverse proxy
- [ ] Deploy Mautic container
- [ ] Complete setup wizard
- [ ] Configure SMTP for email sending
- [ ] Test email campaigns

#### 3.2 N8N Deployment
- [ ] Create Cloudflare subdomain (n8n.thatlittleidea.com)
- [ ] Configure CyberPanel reverse proxy
- [ ] Deploy N8N container
- [ ] Set up basic auth
- [ ] Create first automation workflow
- [ ] Connect to other services

#### 3.3 EspoCRM Deployment
- [ ] Create Cloudflare subdomain (crm.thatlittleidea.com)
- [ ] Configure CyberPanel reverse proxy
- [ ] Deploy EspoCRM container
- [ ] Configure admin account
- [ ] Set up lead/contact entities
- [ ] Configure email integration

#### 3.4 Supporting Services
- [ ] Deploy YOURLS (links.thatlittleidea.com)
- [ ] Deploy Matomo (analytics.thatlittleidea.com)

### Phase 4: Advanced Services ⏳ PENDING

**Objective**: Deploy P2 services and enhanced features

- [ ] Deploy Metabase for BI dashboards
- [ ] Connect Metabase to all databases
- [ ] Create initial dashboards
- [ ] Set up scheduled reports

### Phase 5: Integration & Automation ⏳ PENDING

**Objective**: Create seamless workflows between services

#### Key Integrations

1. **Lead Capture Flow**
   ```
   Website Form → Mautic → N8N → EspoCRM
   ```

2. **Email Campaign Tracking**
   ```
   Mautic Campaign → YOURLS Links → Matomo Analytics
   ```

3. **CRM Automation**
   ```
   EspoCRM Trigger → N8N Workflow → Mautic/Email/Slack
   ```

4. **Reporting Pipeline**
   ```
   All Databases → Metabase → Scheduled Reports
   ```

#### N8N Workflow Templates to Create

- [ ] New lead notification (Email/Slack)
- [ ] Lead scoring automation
- [ ] Email campaign trigger
- [ ] Weekly analytics digest
- [ ] CRM activity sync
- [ ] Social media post scheduler

### Phase 6: Monitoring & Optimization ⏳ PENDING

**Objective**: Ensure reliability and performance

- [ ] Set up container health checks
- [ ] Configure resource limits
- [ ] Implement log rotation
- [ ] Create backup automation
- [ ] Set up uptime monitoring
- [ ] Configure alerting (email/Slack)
- [ ] Performance tuning
- [ ] Security hardening

---

## 6. Resource Allocation

### VPS Specifications

- **RAM**: 8 GB
- **CPU**: 4 vCPU
- **Storage**: 160 GB SSD
- **Bandwidth**: Unmetered

### Service Resource Estimates

| Service | RAM (MB) | CPU | Storage |
|---------|----------|-----|---------|
| Mautic + DB | 1024 | 0.5 | 10 GB |
| N8N | 512 | 0.25 | 2 GB |
| EspoCRM + DB | 768 | 0.5 | 5 GB |
| YOURLS + DB | 256 | 0.1 | 1 GB |
| Matomo + DB | 768 | 0.5 | 10 GB |
| Metabase | 1024 | 0.5 | 5 GB |
| CyberPanel | 512 | 0.25 | 5 GB |
| System/Buffer | 1024 | 0.5 | 50 GB |
| **Total** | **~6 GB** | **~3 cores** | **~88 GB** |

### Resource Headroom

- **RAM**: ~2 GB buffer for spikes
- **CPU**: 1 core buffer
- **Storage**: ~72 GB available for growth

---

## 7. Security Checklist

### Server Security

- [x] SSH key authentication enabled
- [x] Root login disabled
- [x] Firewall configured (UFW)
- [ ] Fail2ban installed
- [ ] Automatic security updates
- [ ] Regular vulnerability scans

### Application Security

- [x] Strong passwords generated
- [x] Secrets in .env (not in code)
- [x] .env excluded from git
- [ ] SSL/TLS on all services
- [ ] HTTP to HTTPS redirect
- [ ] Security headers configured
- [ ] Rate limiting enabled
- [ ] Regular backup verification

### Network Security

- [x] Cloudflare proxy enabled
- [x] DDoS protection active
- [ ] WAF rules configured
- [ ] Bot protection enabled

### Email Security

- [ ] SPF record configured
- [ ] DKIM signing enabled
- [ ] DMARC policy set
- [ ] Dedicated sending IP (future)

---

## 8. Repository Structure

```
tlia-marketing-stack/
├── README.md                    # Quick start guide
├── TLIA_PROJECT_ROADMAP.md     # This document
├── docker-compose.yml          # Main Docker configuration
├── .env                        # Environment variables (git-ignored)
├── .env.example                # Template for environment variables
├── .gitignore                  # Git ignore rules
│
├── docs/                       # Additional documentation
│   └── .gitkeep
│
├── services/                   # Service-specific configs
│   ├── mautic/
│   │   └── .gitkeep
│   ├── n8n/
│   │   └── .gitkeep
│   ├── espocrm/
│   │   └── .gitkeep
│   ├── yourls/
│   │   └── .gitkeep
│   ├── matomo/
│   │   └── .gitkeep
│   └── metabase/
│       └── .gitkeep
│
├── nginx/                      # Nginx reverse proxy
│   ├── conf.d/
│   │   └── .gitkeep
│   └── ssl/
│       └── .gitkeep
│
├── scripts/                    # Helper scripts
│   ├── start-all.ps1
│   ├── stop-all.ps1
│   ├── view-logs.ps1
│   ├── backup-databases.ps1
│   └── generate-password.ps1
│
└── backups/                    # Database backups (git-ignored)
    └── .gitkeep
```

---

## 9. Development Workflow

### Local → GitHub → VPS Flow

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  LOCAL MACHINE  │────▶│     GITHUB      │────▶│   VPS SERVER    │
│                 │     │                 │     │                 │
│ - Edit configs  │     │ - Version ctrl  │     │ - Pull changes  │
│ - Test locally  │     │ - Code review   │     │ - Restart svcs  │
│ - Commit/push   │     │ - Backup        │     │ - Verify        │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

### Git Workflow Commands

```bash
# Daily development
git status
git add .
git commit -m "Description of changes"
git push origin main

# On VPS for deployment
cd /path/to/tlia-marketing-stack
git pull origin main
docker-compose up -d --build
docker-compose logs -f
```

### Branch Strategy (Future)

- `main` - Production-ready code
- `develop` - Integration branch
- `feature/*` - New features
- `hotfix/*` - Emergency fixes

---

## 10. Pre-Deployment Checklist

### Before Deploying Each Service

- [ ] Environment variables configured
- [ ] Cloudflare subdomain created
- [ ] DNS propagated (check with `nslookup`)
- [ ] CyberPanel virtual host created
- [ ] SSL certificate issued
- [ ] Reverse proxy configured
- [ ] Firewall allows required ports
- [ ] Health check endpoint identified
- [ ] Backup strategy documented
- [ ] Rollback plan prepared

### Post-Deployment Verification

- [ ] Service accessible via HTTPS
- [ ] No SSL warnings in browser
- [ ] Login functionality works
- [ ] Database connection verified
- [ ] Email sending works (if applicable)
- [ ] Logs show no errors
- [ ] Performance acceptable
- [ ] Monitoring configured

---

## 11. Troubleshooting Guide

### Common Issues

#### Containers Won't Start

```bash
# Check logs
docker-compose logs [service-name]

# Check if ports are in use
netstat -tulpn | grep [port]

# Restart Docker
sudo systemctl restart docker

# Rebuild containers
docker-compose up -d --build --force-recreate
```

#### Database Connection Errors

```bash
# Check database container
docker-compose logs [service]-db

# Verify environment variables
docker-compose exec [service] env | grep DB

# Access database directly
docker-compose exec [service]-db mysql -u root -p
```

#### Service Not Accessible

```bash
# Check container status
docker-compose ps

# Check port mapping
docker port [container-name]

# Test internal connectivity
docker-compose exec [service] curl http://localhost:[port]

# Check firewall
sudo ufw status
```

#### Memory Issues

```bash
# Check container resource usage
docker stats

# Set memory limits in docker-compose.yml
deploy:
  resources:
    limits:
      memory: 1G
```

#### SSL Certificate Issues

```bash
# Check certificate status in CyberPanel
# Or use certbot directly
certbot certificates

# Renew certificate
certbot renew

# Force renewal
certbot renew --force-renewal
```

### Useful Debug Commands

```bash
# Enter container shell
docker-compose exec [service] /bin/bash

# View real-time logs
docker-compose logs -f --tail=100 [service]

# Check network connectivity
docker network inspect tlia-network

# View all containers (including stopped)
docker ps -a

# Clean up unused resources
docker system prune -a
```

---

## 12. Success Metrics

### Technical KPIs

| Metric | Target | Measurement |
|--------|--------|-------------|
| Uptime | 99.5% | Monitoring tool |
| Page Load Time | < 3s | Matomo/PageSpeed |
| API Response Time | < 500ms | N8N logs |
| Error Rate | < 1% | Application logs |
| Backup Success | 100% | Backup scripts |

### Business KPIs (Track in Metabase)

| Metric | Source |
|--------|--------|
| Email Open Rate | Mautic |
| Click-Through Rate | YOURLS/Mautic |
| Lead Conversion Rate | EspoCRM |
| Website Traffic | Matomo |
| Automation Executions | N8N |
| Active Contacts | EspoCRM |

---

## 13. Future Enhancements

### Phase 7+ Roadmap Ideas

#### Additional Services (Evaluate)

- [ ] Listmonk (Newsletter alternative to Mautic)
- [ ] Grafana (Advanced monitoring dashboards)
- [ ] Plausible (Lightweight analytics alternative)
- [ ] Chatwoot (Customer support chat)
- [ ] Docuseal (Document signing)
- [ ] Cal.com (Scheduling)

#### Infrastructure Improvements

- [ ] Kubernetes migration (if scaling needed)
- [ ] Multi-region deployment
- [ ] Load balancer setup
- [ ] CDN for static assets
- [ ] Redis caching layer
- [ ] Elasticsearch for search

#### Automation Expansions

- [ ] AI-powered lead scoring
- [ ] Automated A/B testing
- [ ] Predictive analytics
- [ ] Chatbot integration
- [ ] Social media automation
- [ ] Content calendar

#### Security Enhancements

- [ ] SSO/SAML integration
- [ ] 2FA for all services
- [ ] VPN access for admin
- [ ] Audit logging
- [ ] Compliance reporting (GDPR)
- [ ] Penetration testing

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2024-01 | Claude | Initial documentation |

---

*Last Updated: January 2025*

*That Little Idea - Building the future of accessible marketing technology*
