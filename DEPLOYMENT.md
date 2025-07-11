# KBF Data Management System - Deployment Configuration

## Local Development
- **Local Path**: `/Users/R/ColdFusion/cfusion/wwwroot/KBFData`
- **Local URL**: `http://localhost:8500/KBFData/`

## Git Repository
- **GitHub URL**: `https://github.com/PerfectStormsRich/kbf-data-management.git`
- **Main Branch**: `main`

## Remote Server Deployment
To deploy to your remote server, you'll need to configure:

### FTP/SFTP Deployment
1. **Server**: [Your server hostname/IP]
2. **Username**: [Your FTP username]
3. **Path**: [Remote directory path]
4. **Port**: 21 (FTP) or 22 (SFTP)

### SSH Deployment (Recommended)
1. **Server**: [Your server hostname/IP]
2. **Username**: [Your SSH username]
3. **Key**: [Path to your SSH key]
4. **Remote Path**: [Remote directory path]

### Example Deployment Commands

#### Using rsync (SSH):
```bash
rsync -avz --exclude-from='.gitignore' \
  --exclude '.git/' \
  --exclude 'deploy/' \
  ./ username@yourserver.com:/path/to/webroot/KBFData/
```

#### Using Git on Remote Server:
```bash
# On remote server
git clone https://github.com/PerfectStormsRich/kbf-data-management.git KBFData
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
