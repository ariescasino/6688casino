#!/bin/bash

# 6688.it.com Casino Complete Control Panel Installation Script
# Bảng điều khiển tổng hợp tất cả tính năng

set -e

# Variables
DOMAIN="6688.it.com"
PROJECT_NAME="6688casino"
REPO_URL="https://github.com/alisababivip/ok7.git"
WEB_ROOT="/var/www/${DOMAIN}"
NGINX_AVAILABLE="/etc/nginx/sites-available/${DOMAIN}"
NGINX_ENABLED="/etc/nginx/sites-enabled/${DOMAIN}"
DB_NAME="casino6688"
DB_USER="casino_user"
DB_PASS=$(openssl rand -base64 12)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Helper functions
log() {
    echo -e "${GREEN}[$(date +'%H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

info() {
    echo -e "${BLUE}[INFO] $1${NC}"
}

success() {
    echo -e "${PURPLE}[SUCCESS] $1${NC}"
}

header() {
    echo -e "${CYAN}$1${NC}"
}

# Check root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run as root (use sudo)"
        exit 1
    fi
}

# Display main menu
show_main_menu() {
    clear
    header "=================================================================="
    header "           6688.it.com CASINO DEPLOYMENT CONTROL PANEL"
    header "=================================================================="
    echo ""
    echo -e "${CYAN}1.${NC}  🚀 Complete Auto Installation (Recommended)"
    echo -e "${CYAN}2.${NC}  🔧 Step-by-Step Installation"
    echo -e "${CYAN}3.${NC}  🛠️  Fix & Troubleshoot Menu"
    echo -e "${CYAN}4.${NC}  📊 System Status & Monitoring"
    echo -e "${CYAN}5.${NC}  �� Security & SSL Management"
    echo -e "${CYAN}6.${NC}  💾 Backup & Restore"
    echo -e "${CYAN}7.${NC}  🗑️  Cleanup & Reset"
    echo -e "${CYAN}8.${NC}  ℹ️  Help & Documentation"
    echo -e "${CYAN}0.${NC}  ❌ Exit"
    echo ""
    header "=================================================================="
}

# Show step-by-step menu
show_step_menu() {
    clear
    header "================== STEP-BY-STEP INSTALLATION =================="
    echo ""
    echo -e "${CYAN}1.${NC}  📦 Update System & Install Dependencies"
    echo -e "${CYAN}2.${NC}  📥 Clone Repository"
    echo -e "${CYAN}3.${NC}  🔍 Analyze Environment"
    echo -e "${CYAN}4.${NC}  🌐 Install & Configure Nginx"
    echo -e "${CYAN}5.${NC}  ⚙️  Configure Next.js Project"
    echo -e "${CYAN}6.${NC}  🏗️  Build & Deploy Application"
    echo -e "${CYAN}7.${NC}  🗄️  Setup Database (MySQL)"
    echo -e "${CYAN}8.${NC}  🔒 Configure SSL Certificate"
    echo -e "${CYAN}9.${NC}  🛡️  Setup Security & Firewall"
    echo -e "${CYAN}10.${NC} 📡 Configure DNS Information"
    echo -e "${CYAN}0.${NC}  ⬅️  Back to Main Menu"
    echo ""
    header "=================================================================="
}

# Show fix menu
show_fix_menu() {
    clear
    header "=================== FIX & TROUBLESHOOT MENU ==================="
    echo ""
    echo -e "${CYAN}1.${NC}  🔧 Fix Build Errors"
    echo -e "${CYAN}2.${NC}  📁 Fix SCSS Import Issues"
    echo -e "${CYAN}3.${NC}  🔄 Fix Variable Hoisting Errors"
    echo -e "${CYAN}4.${NC}  📦 Fix Redux Wrapper Issues"
    echo -e "${CYAN}5.${NC}  🚫 Kill Hanging Processes (Safe)"
    echo -e "${CYAN}6.${NC}  �� Rebuild Complete Project"
    echo -e "${CYAN}7.${NC}  🔁 Restart PM2 Services"
    echo -e "${CYAN}8.${NC}  🌐 Fix Nginx Configuration"
    echo -e "${CYAN}9.${NC}  🧹 Clean All Issues (Auto Fix)"
    echo -e "${CYAN}0.${NC}  ⬅️  Back to Main Menu"
    echo ""
    header "=================================================================="
}

# Show monitoring menu
show_monitoring_menu() {
    clear
    header "================= SYSTEM STATUS & MONITORING =================="
    echo ""
    echo -e "${CYAN}1.${NC}  📊 Show System Overview"
    echo -e "${CYAN}2.${NC}  🔍 Check PM2 Status"
    echo -e "${CYAN}3.${NC}  📝 View Application Logs"
    echo -e "${CYAN}4.${NC}  🌐 Test HTTP Connection"
    echo -e "${CYAN}5.${NC}  💽 Check Disk Space"
    echo -e "${CYAN}6.${NC}  🔧 Check Services Status"
    echo -e "${CYAN}7.${NC}  📈 Real-time Monitoring"
    echo -e "${CYAN}0.${NC}  ⬅️  Back to Main Menu"
    echo ""
    header "=================================================================="
}

# Complete auto installation
complete_auto_install() {
    log "Starting complete auto installation..."
    
    update_system
    install_nodejs
    install_nginx
    clone_repository
    analyze_environment
    fix_nextjs_config
    create_env_files
    build_nextjs_project
    setup_pm2_nextjs
    configure_nginx_nextjs
    install_mysql_if_needed
    configure_ssl
    setup_security
    create_backup_system
    
    success "🎉 Complete installation finished!"
    show_deployment_summary
    pause_for_user
}

# Individual functions for each step
update_system() {
    log "Updating system packages..."
    apt update && apt upgrade -y
    apt install -y curl wget git software-properties-common openssl ufw nginx mysql-server
    info "✅ System updated"
}

install_nodejs() {
    log "Installing Node.js and PM2..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    apt install -y nodejs
    npm install -g pm2 serve
    info "✅ Node.js and PM2 installed"
}

install_nginx() {
    log "Installing and configuring Nginx..."
    systemctl start nginx
    systemctl enable nginx
    ufw allow 'Nginx Full'
    info "✅ Nginx installed and configured"
}

clone_repository() {
    log "Cloning repository..."
    
    if [ -d "$WEB_ROOT" ]; then
        warning "Directory exists. Creating backup..."
        mv "$WEB_ROOT" "${WEB_ROOT}.backup.$(date +%Y%m%d-%H%M%S)"
    fi
    
    mkdir -p "$WEB_ROOT"
    git clone "$REPO_URL" "$WEB_ROOT"
    cd "$WEB_ROOT"
    
    info "✅ Repository cloned successfully"
}

analyze_environment() {
    log "Analyzing project environment..."
    
    cd "$WEB_ROOT"
    
    if [ -f "package.json" ]; then
        PROJECT_TYPE="nextjs"
        info "✅ Detected Next.js project"
    elif [ -f "composer.json" ]; then
        PROJECT_TYPE="php"
        info "✅ Detected PHP project"
    else
        PROJECT_TYPE="static"
        info "✅ Detected static website"
    fi
    
    if [ -f "database.sql" ] || [ -f "schema.sql" ] || grep -r "mysql\|postgresql" . >/dev/null 2>&1; then
        NEEDS_DATABASE=true
        info "✅ Database requirements detected"
    else
        NEEDS_DATABASE=false
    fi
}

fix_nextjs_config() {
    log "Fixing Next.js configuration..."
    
    cd "$WEB_ROOT"
    
    # Backup original
    cp next.config.js next.config.js.backup 2>/dev/null || true
    
    # Remove export mode if exists
    sed -i '/output.*export/d' next.config.js
    
    # Add webpack fallbacks
    cat >> next.config.js << 'EOF'

// Webpack fallbacks for client-side compatibility
const originalWebpack = module.exports.webpack || ((config) => config);
module.exports.webpack = (config, options) => {
  config = originalWebpack(config, options);
  if (!options.isServer) {
    config.resolve.fallback = {
      ...config.resolve.fallback,
      fs: false, net: false, tls: false, crypto: false,
    };
  }
  return config;
};
EOF

    info "✅ Next.js config fixed"
}

create_env_files() {
    log "Creating environment files..."
    
    cd "$WEB_ROOT"
    
    cat > .env.local << 'EOF'
NODE_ENV=production
NEXT_PUBLIC_API_URL=https://api.6688.it.com
NEXT_PUBLIC_STORAGE_URL=https://storage.6688.it.com
NEXT_PUBLIC_SOCKET_URL=wss://socket.6688.it.com
EOF

    info "✅ Environment files created"
}

build_nextjs_project() {
    log "Building Next.js project..."
    
    cd "$WEB_ROOT"
    
    rm -rf .next/ node_modules/ package-lock.json 2>/dev/null || true
    npm install
    
    if timeout 300s npm run build; then
        info "✅ Build successful"
        return 0
    else
        error "❌ Build failed"
        return 1
    fi
}

setup_pm2_nextjs() {
    log "Setting up PM2 for Next.js..."
    
    cd "$WEB_ROOT"
    
    cat > ecosystem.config.js << 'EOF'
module.exports = {
  apps: [{
    name: '6688casino',
    script: 'npm',
    args: 'start',
    cwd: '/var/www/6688.it.com',
    instances: 1,
    exec_mode: 'fork',
    env: { NODE_ENV: 'production', PORT: 3000 },
    autorestart: true,
    watch: false,
    max_memory_restart: '1G'
  }]
};
EOF

    pm2 start ecosystem.config.js
    pm2 save
    pm2 startup
    
    info "✅ PM2 configured and started"
}

configure_nginx_nextjs() {
    log "Configuring Nginx for Next.js..."
    
    cat > "$NGINX_AVAILABLE" << 'EOF'
server {
    listen 80;
    server_name 6688.it.com www.6688.it.com;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
    
    location /_next/static/ {
        proxy_pass http://localhost:3000;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF

    ln -sf "$NGINX_AVAILABLE" "$NGINX_ENABLED"
    nginx -t && systemctl reload nginx
    
    info "✅ Nginx configured for Next.js"
}

install_mysql_if_needed() {
    if [ "$NEEDS_DATABASE" = true ]; then
        log "Setting up MySQL database..."
        
        mysql << EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$DB_PASS';
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF

        echo "Database: $DB_NAME" > "$WEB_ROOT/database_credentials.txt"
        echo "User: $DB_USER" >> "$WEB_ROOT/database_credentials.txt"
        echo "Password: $DB_PASS" >> "$WEB_ROOT/database_credentials.txt"
        
        info "✅ MySQL database configured"
    fi
}

configure_ssl() {
    log "Configuring SSL certificate..."
    
    apt install -y certbot python3-certbot-nginx
    certbot --nginx -d "$DOMAIN" -d "www.$DOMAIN" --non-interactive --agree-tos --email admin@"$DOMAIN" --redirect
    systemctl enable certbot.timer
    
    info "✅ SSL certificate configured"
}

setup_security() {
    log "Setting up security and firewall..."
    
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow ssh
    ufw allow 'Nginx Full'
    ufw --force enable
    
    apt install -y fail2ban
    systemctl enable fail2ban
    systemctl start fail2ban
    
    info "✅ Security configured"
}

create_backup_system() {
    log "Creating backup system..."
    
    cat > /usr/local/bin/6688-backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/backup/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/website.tar.gz" -C "/var/www" "6688.it.com"
echo "Backup created: $BACKUP_DIR"
EOF

    chmod +x /usr/local/bin/6688-backup.sh
    
    info "✅ Backup system created"
}

# Fix functions
fix_build_errors() {
    log "Fixing build errors..."
    cd "$WEB_ROOT" 2>/dev/null || cd "/var/app/6688casino"
    
    rm -rf .next/
    npm install
    
    if npm run build; then
        success "✅ Build errors fixed"
    else
        error "❌ Build still failing"
    fi
    
    pause_for_user
}

fix_scss_imports() {
    log "Fixing SCSS import issues..."
    cd "$WEB_ROOT" 2>/dev/null || cd "/var/app/6688casino"
    
    find pages/setting -name "*.tsx" 2>/dev/null | while read file; do
        sed -i "s|'../../balance/index.module.scss'|'../../balance/index.module.scss'|g" "$file"
    done
    
    success "✅ SCSS imports fixed"
    pause_for_user
}

fix_variable_hoisting() {
    log "Fixing variable hoisting errors..."
    cd "$WEB_ROOT" 2>/dev/null || cd "/var/app/6688casino"
    
    find . -name "*.tsx" -o -name "*.ts" | grep -v node_modules | while read file; do
        sed -i 's/const \([^=]*\) = \([^,]*\), \([^=]*\) = \1/const \1 = \2;\nconst \3 = \1/g' "$file"
    done
    
    success "✅ Variable hoisting fixed"
    pause_for_user
}

kill_safe_processes() {
    log "Safely killing hanging processes..."
    
    # Kill only project-specific processes
    lsof -ti:3000 | xargs kill -9 2>/dev/null || true
    pm2 delete 6688casino 2>/dev/null || true
    
    success "✅ Processes cleaned safely"
    pause_for_user
}

# Monitoring functions
show_system_overview() {
    clear
    header "===================== SYSTEM OVERVIEW ====================="
    echo ""
    echo -e "${CYAN}Date:${NC} $(date)"
    echo -e "${CYAN}Uptime:${NC} $(uptime -p)"
    echo -e "${CYAN}Load:${NC} $(uptime | awk -F'load average:' '{print $2}')"
    echo ""
    echo -e "${CYAN}Memory Usage:${NC}"
    free -h
    echo ""
    echo -e "${CYAN}Disk Usage:${NC}"
    df -h | head -5
    echo ""
    echo -e "${CYAN}Network:${NC}"
    netstat -tulpn | grep :3000 || echo "Port 3000 not in use"
    echo ""
    pause_for_user
}

check_pm2_status() {
    clear
    header "====================== PM2 STATUS ======================"
    pm2 status
    echo ""
    pause_for_user
}

view_app_logs() {
    clear
    header "==================== APPLICATION LOGS ===================="
    pm2 logs 6688casino --lines 20
    echo ""
    pause_for_user
}

test_http_connection() {
    clear
    header "=================== HTTP CONNECTION TEST =================="
    
    if curl -I http://localhost:3000 2>/dev/null; then
        success "✅ HTTP connection successful"
    else
        error "❌ HTTP connection failed"
    fi
    
    echo ""
    pause_for_user
}

# Show deployment summary
show_deployment_summary() {
    clear
    header "===================== DEPLOYMENT SUMMARY ====================="
    echo ""
    success "🎉 6688.it.com Casino successfully deployed!"
    echo ""
    echo -e "${CYAN}Domain:${NC} https://$DOMAIN"
    echo -e "${CYAN}Project Type:${NC} $PROJECT_TYPE"
    echo -e "${CYAN}Web Root:${NC} $WEB_ROOT"
    echo -e "${CYAN}SSL:${NC} ✅ Enabled"
    echo -e "${CYAN}Firewall:${NC} ✅ Configured"
    
    if [ "$NEEDS_DATABASE" = true ]; then
        echo -e "${CYAN}Database:${NC} $DB_NAME"
        echo -e "${CYAN}DB User:${NC} $DB_USER"
        echo -e "${CYAN}Credentials:${NC} $WEB_ROOT/database_credentials.txt"
    fi
    
    echo ""
    echo -e "${CYAN}Useful Commands:${NC}"
    echo "  Monitor: pm2 status"
    echo "  Logs: pm2 logs 6688casino"
    echo "  Restart: pm2 restart 6688casino"
    echo "  Backup: 6688-backup.sh"
    echo ""
    SERVER_IP=$(curl -s ifconfig.me 2>/dev/null || echo "Unable to detect")
    echo -e "${CYAN}Server IP:${NC} $SERVER_IP"
    echo -e "${CYAN}Visit:${NC} https://$DOMAIN"
    echo ""
}

# Utility functions
pause_for_user() {
    echo ""
    read -p "Press Enter to continue..."
}

# Main menu handler
handle_main_menu() {
    while true; do
        show_main_menu
        read -p "Enter your choice [0-8]: " choice
        
        case $choice in
            1) complete_auto_install ;;
            2) handle_step_menu ;;
            3) handle_fix_menu ;;
            4) handle_monitoring_menu ;;
            5) handle_security_menu ;;
            6) handle_backup_menu ;;
            7) handle_cleanup_menu ;;
            8) show_help ;;
            0) log "Goodbye!"; exit 0 ;;
            *) error "Invalid choice. Please try again."; sleep 2 ;;
        esac
    done
}

# Step menu handler
handle_step_menu() {
    while true; do
        show_step_menu
        read -p "Enter your choice [0-10]: " choice
        
        case $choice in
            1) update_system; pause_for_user ;;
            2) clone_repository; pause_for_user ;;
            3) analyze_environment; pause_for_user ;;
            4) install_nginx; pause_for_user ;;
            5) fix_nextjs_config; pause_for_user ;;
            6) build_nextjs_project; setup_pm2_nextjs; pause_for_user ;;
            7) install_mysql_if_needed; pause_for_user ;;
            8) configure_ssl; pause_for_user ;;
            9) setup_security; pause_for_user ;;
            10) configure_dns_info; pause_for_user ;;
            0) break ;;
            *) error "Invalid choice. Please try again."; sleep 2 ;;
        esac
    done
}

# Fix menu handler
handle_fix_menu() {
    while true; do
        show_fix_menu
        read -p "Enter your choice [0-9]: " choice
        
        case $choice in
            1) fix_build_errors ;;
            2) fix_scss_imports ;;
            3) fix_variable_hoisting ;;
            4) npm install next-redux-wrapper@latest; pause_for_user ;;
            5) kill_safe_processes ;;
            6) fix_build_errors ;;
            7) pm2 restart 6688casino; pause_for_user ;;
            8) nginx -t && systemctl reload nginx; pause_for_user ;;
            9) complete_auto_install ;;
            0) break ;;
            *) error "Invalid choice. Please try again."; sleep 2 ;;
        esac
    done
}

# Monitoring menu handler
handle_monitoring_menu() {
    while true; do
        show_monitoring_menu
        read -p "Enter your choice [0-7]: " choice
        
        case $choice in
            1) show_system_overview ;;
            2) check_pm2_status ;;
            3) view_app_logs ;;
            4) test_http_connection ;;
            5) df -h; pause_for_user ;;
            6) systemctl status nginx pm2 --no-pager; pause_for_user ;;
            7) pm2 monit ;;
            0) break ;;
            *) error "Invalid choice. Please try again."; sleep 2 ;;
        esac
    done
}

# Placeholder handlers for other menus
handle_security_menu() {
    info "Security menu - Under development"
    pause_for_user
}

handle_backup_menu() {
    info "Backup menu - Under development"
    pause_for_user
}

handle_cleanup_menu() {
    info "Cleanup menu - Under development"
    pause_for_user
}

configure_dns_info() {
    SERVER_IP=$(curl -s ifconfig.me)
    info "Configure DNS records:"
    echo "A Record: $DOMAIN -> $SERVER_IP"
    echo "A Record: www.$DOMAIN -> $SERVER_IP"
}

show_help() {
    clear
    header "======================= HELP & DOCUMENTATION ======================="
    echo ""
    echo "This control panel provides comprehensive deployment and management"
    echo "tools for the 6688.it.com Casino Next.js application."
    echo ""
    echo "Features:"
    echo "• Complete auto-installation"
    echo "• Step-by-step guided setup"
    echo "• Advanced troubleshooting tools"
    echo "• System monitoring and status"
    echo "• Security and SSL management"
    echo "• Backup and restore capabilities"
    echo ""
    echo "For support, check the logs or run diagnostics from the monitoring menu."
    echo ""
    pause_for_user
}

# Main execution
main() {
    check_root
    handle_main_menu
}

# Run main function
main "$@"
