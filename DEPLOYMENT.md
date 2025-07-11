# KBF Data Management System - Deployment Configuration

## Local Development
- **Local Path**: `/Users/R/ColdFusion/cfusion/wwwroot/KBFData`
- **Local URL**: `http://localhost:8500/KBFData/`

## Git Repository
- **GitHub URL**: `https://github.com/CalicoWoodSigns/calicoKnotts.git`
- **Main Branch**: `main`

## Remote Server Deployment - CFDynamics Hosting

### Production Server Details
- **Server**: `car-cfs05.cfdynamics.com`
- **Website URL**: `http://calicowoodsigns.com`
- **Subdomain URL**: `http://emp77.calicowoodsigns.com`
- **Server IP**: `216.117.4.34`
- **Remote Path**: `C:\HostingSpaces\calicowo\emp77.calicowoodsigns.com\wwwroot`

### FTPS Deployment (Recommended)
- **Server**: `ftps://car-cfs05.cfdynamics.com` or `ftps://calicowoodsigns.com`
- **Username**: `calicowo` 
- **Password**: `1Aaaa`
- **Port**: 21 (FTPS - Passive mode required)
- **Path**: `\emp77.calicowoodsigns.com\wwwroot`

### Database Configuration
- **SQL Server 2019**: Available via control panel (up to 10 databases)
- **MariaDB**: Available at `mysql02` (up to 10 databases)
- **External connections**: Require VPN access (submit support ticket)

### Email Configuration
- **SMTP/POP3 Server**: `mail.calicowoodsigns.com`
- **Server IP**: `216.117.4.25`
- **WebMail**: Available during DNS propagation

### Example Deployment Commands

#### Using FTPS (Recommended for Windows hosting):
```bash
# Use an FTP client like FileZilla with these settings:
# Protocol: FTPS (Explicit FTP over TLS)
# Host: car-cfs05.cfdynamics.com
# Port: 21
# Username: calicowo
# Password: 1Aaaa
# Remote path: \emp77.calicowoodsigns.com\wwwroot
```

#### Using Git on Remote Server:
```bash
# On remote server (if Git is available)
git clone https://github.com/CalicoWoodSigns/calicoKnotts.git KBFData
cd KBFData
git pull origin main
```

### Automated Deployment Script
See `deploy/deploy.sh` for automated deployment options.

## Git-based Sync Workflow (Recommended)

### Development Workflow
1. **Make changes** to your local files
2. **Test locally** at `http://localhost:8500/KBFData/`
3. **Commit and sync** using the sync script:
   ```bash
   ./deploy/sync.sh
   ```
4. **Deploy to production** using one of the methods below

### Sync Script Features
- ✅ Commits your changes with version control
- ✅ Pushes to GitHub automatically
- ✅ Maintains complete version history
- ✅ Provides deployment instructions
- ✅ Shows current version info

### Production Deployment Options

#### Option 1: Git Pull on Remote Server (Best if available)
```bash
# SSH to remote server (if SSH access available)
ssh calicowo@car-cfs05.cfdynamics.com
cd C:\HostingSpaces\calicowo\emp77.calicowoodsigns.com\wwwroot
git pull origin main
```

#### Option 2: Automated FTPS Deployment
```bash
./deploy/ftps-deploy.sh
```

#### Option 3: Manual FTPS Upload
Use FileZilla with the settings provided above.

## Environment Configuration
- Copy `config/config.properties.example` to `config/config.properties`
- Update database connection strings
- Configure email settings
- Set up security parameters

## Database Setup
- Create database tables using scripts in `sql/` directory
- Update datasource configuration in ColdFusion Administrator
- Test database connectivity

## Security Checklist
- [ ] Update default admin passwords
- [ ] Configure SSL certificates
- [ ] Set up proper file permissions
- [ ] Configure firewall rules
- [ ] Enable security headers
- [ ] Set up backup procedures
