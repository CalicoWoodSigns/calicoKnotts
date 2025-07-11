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
