# TLIA Marketing Stack

A production-ready, self-hosted digital marketing agency stack using Docker containers. This repository contains the complete infrastructure configuration for **That Little Idea** (thatlittleidea.com).

## Overview

This stack provides a comprehensive suite of open-source marketing and business tools, enabling cost-effective digital marketing operations without expensive SaaS subscriptions.

| Service | Purpose | Local URL | Production Subdomain |
|---------|---------|-----------|---------------------|
| **Mautic** | Marketing Automation | http://localhost:8080 | mautic.thatlittleidea.com |
| **N8N** | Workflow Automation | http://localhost:5678 | n8n.thatlittleidea.com |
| **Dolibarr** | ERP/CRM Platform | http://localhost:8888 | crm.thatlittleidea.com |
| **YOURLS** | URL Shortener & Analytics | http://localhost:8181 | links.thatlittleidea.com |
| **Metabase** | Business Intelligence & Reporting | http://localhost:3000 | bi.thatlittleidea.com |
| **Retell AI** | Voice/SMS AI Receptionist | External Service | via Twilio |
| **phpMyAdmin** | Database Management (Dev Only) | http://localhost:8090 | - |

## Infrastructure

- **VPS**: 74.208.99.12
- **Domain**: thatlittleidea.com
- **DNS/CDN**: Cloudflare
- **Server Panel**: CyberPanel
- **Container Runtime**: Docker + Docker Compose

## Quick Start

### Prerequisites

- Docker Desktop installed and running
- Git
- PowerShell (Windows) or Bash (Linux/Mac)

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/tlia-marketing-stack.git
   cd tlia-marketing-stack
   ```

2. **Create environment file**
   ```bash
   cp .env.example .env
   ```

3. **Edit .env with your passwords**
   Open `.env` and replace all `CHANGE_ME` values with strong passwords.

4. **Start all services**
   ```bash
   docker-compose up -d
   ```

5. **Verify services are running**
   ```bash
   docker-compose ps
   ```

### Docker Commands

```bash
# Start all services in background
docker-compose up -d

# Stop all services
docker-compose down

# View logs for all services
docker-compose logs -f

# View logs for specific service
docker-compose logs -f mautic

# Restart a specific service
docker-compose restart n8n

# Rebuild containers after config changes
docker-compose up -d --build

# Stop and remove all data (DESTRUCTIVE)
docker-compose down -v
```

## Service Access (Local Development)

After running `docker-compose up -d`, access services at:

| Service | URL | Default Credentials |
|---------|-----|---------------------|
| Mautic | http://localhost:8080 | Setup wizard on first run |
| N8N | http://localhost:5678 | From .env (N8N_USER/N8N_PASSWORD) |
| Dolibarr | http://localhost:8888 | From .env (DOLIBARR_ADMIN_*) |
| YOURLS | http://localhost:8181 | From .env (YOURLS_USER/YOURLS_PASSWORD) |
| Metabase | http://localhost:3000 | Setup wizard on first run |
| phpMyAdmin | http://localhost:8090 | root / DB root passwords |

## Project Structure

```
tlia-marketing-stack/
├── docker-compose.yml      # Main Docker configuration
├── .env                    # Environment variables (git-ignored)
├── .env.example            # Template for environment variables
├── .gitignore              # Git ignore rules
├── README.md               # This file
├── TLIA_PROJECT_ROADMAP.md # Detailed project documentation
├── docs/                   # Additional documentation
├── services/               # Service-specific configurations
│   ├── asterisk/           # Asterisk voice agent configs
│   ├── retell/             # Retell AI agent configuration
│   ├── mautic/
│   ├── n8n/
│   ├── yourls/
│   └── metabase/
├── n8n/                    # N8N workflow definitions
│   └── workflows/          # Retell voice/SMS webhook workflows
├── nginx/                  # Nginx reverse proxy configs
│   ├── conf.d/
│   └── ssl/
├── scripts/                # Helper scripts
│   ├── start-all.ps1
│   ├── stop-all.ps1
│   ├── view-logs.ps1
│   ├── backup-databases.ps1
│   └── generate-password.ps1
└── backups/                # Database backups (git-ignored)
```

## Security Notes

- **Never commit `.env`** - It contains sensitive passwords
- All services run on a private Docker network
- Only exposed ports are accessible from host
- Use strong, unique passwords for each service
- Regularly backup databases using provided scripts

## Documentation

For complete project documentation, implementation phases, and deployment guides, see:

**[TLIA_PROJECT_ROADMAP.md](./TLIA_PROJECT_ROADMAP.md)**

## Support

For issues and questions:
- Check the [Troubleshooting Guide](./TLIA_PROJECT_ROADMAP.md#troubleshooting-guide)
- Review service-specific documentation in `docs/`

---

**That Little Idea** - Low-cost, high-impact digital marketing infrastructure
