#!/bin/bash
# ============================================================
# 🦞 ClawPM — 阿里云 ECS 部署全流程脚本
# 目标: Ubuntu 22.04 LTS / Alibaba Cloud Linux 3
# 日期: 2026-04-27
# ============================================================
set -euo pipefail

# ---- 颜色输出 ----
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
info()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
err()   { echo -e "${RED}[✗]${NC} $1"; exit 1; }
step()  { echo -e "\n${BLUE}━━━ $1 ━━━${NC}"; }

# ============================================================
# 配置区（按需修改 ↓）
# ============================================================
DOMAIN="${DOMAIN:-clawpm.yourdomain.com}"       # Telegram Webhook 域名
EMAIL="${EMAIL:-admin@yourdomain.com}"           # SSL 证书邮箱
PORT="${PORT:-18789}"                            # OpenClaw Gateway 端口
LOCAL_USER="${LOCAL_USER:-linda}"                # 本地 Mac 用户名
LOCAL_HOST="${LOCAL_HOST:-192.168.1.100}"        # 本地 Mac IP（首次同步后注销）
TELEGRAM_BOT_TOKEN="${TELEGRAM_BOT_TOKEN:-}"     # Telegram Bot Token（可选，部署后配也行）
OPENCLAW_DIR="${OPENCLAW_DIR:-$HOME/.openclaw}"  # 服务端 OpenClaw 目录
WORKSPACE_DIR="${WORKSPACE_DIR:-$HOME/clawpm}"   # 服务端 Workspace 目录
OPENCLAW_VERSION="${OPENCLAW_VERSION:-latest}"   # OpenClaw 版本

# ============================================================
# 1. 系统初始化
# ============================================================
step "1/9 系统初始化"

# 确认系统
if [ ! -f /etc/os-release ]; then
    err "仅支持 Linux (Ubuntu / Alibaba Cloud Linux)"
fi
. /etc/os-release
info "系统: $PRETTY_NAME"
info "架构: $(uname -m)"

# 基础包
sudo apt-get update -qq
sudo apt-get install -y -qq \
    curl wget git unzip \
    nginx cron rsync \
    ufw fail2ban \
    certbot python3-certbot-nginx \
    jq netcat-openbsd 2>/dev/null || true

info "基础依赖安装完成"

# ============================================================
# 2. 安装 Node.js + OpenClaw
# ============================================================
step "2/9 安装 Node.js + OpenClaw"

if ! command -v node &>/dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo bash -
    sudo apt-get install -y -qq nodejs
fi
info "Node.js: $(node -v)"
info "npm: $(npm -v)"

# 安装/更新 OpenClaw
if ! command -v openclaw &>/dev/null; then
    npm install -g openclaw@${OPENCLAW_VERSION}
fi
info "OpenClaw: $(openclaw -V 2>/dev/null || echo '已安装')"

# ============================================================
# 3. 创建用户 & 目录结构
# ============================================================
step "3/9 创建用户 & 目录"

# 用当前用户，确保目录存在
mkdir -p "$OPENCLAW_DIR"
mkdir -p "$WORKSPACE_DIR/memory"
mkdir -p "$WORKSPACE_DIR/docs"
mkdir -p "$WORKSPACE_DIR/backups"

chmod 700 "$OPENCLAW_DIR" "$WORKSPACE_DIR"
info "目录创建完成"

# ============================================================
# 4. 防火墙 & 安全
# ============================================================
step "4/9 防火墙 & 安全组"

# ufw
sudo ufw --force reset >/dev/null 2>&1
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 80/tcp    # HTTP (certbot)
sudo ufw allow 443/tcp   # HTTPS
sudo ufw --force enable >/dev/null 2>&1
info "UFW 已配置: 放行 SSH / HTTP / HTTPS"

# fail2ban (SSH 防护)
sudo tee /etc/fail2ban/jail.local >/dev/null <<FAIL2BAN
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5

[sshd]
enabled = true
FAIL2BAN
sudo systemctl restart fail2ban 2>/dev/null || true
info "Fail2ban 已配置"

# ============================================================
# 5. 配置 Nginx 反向代理 + SSL
# ============================================================
step "5/9 Nginx 反代 + SSL"

# 生成 Nginx 配置
sudo tee /etc/nginx/sites-available/clawpm >/dev/null <<NGINX
server {
    listen 80;
    server_name $DOMAIN;

    # Certbot 验证用
    location /.well-known/acme-challenge/ {
        root /var/www/html;
    }

    location / {
        proxy_pass http://127.0.0.1:$PORT;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

        # WebSocket 超时（保持长连）
        proxy_read_timeout 86400s;
        proxy_send_timeout 86400s;
    }
}
NGINX

sudo ln -sf /etc/nginx/sites-available/clawpm /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t && sudo systemctl reload nginx
info "Nginx 配置完成"

# SSL 证书（如果域名已解析）
if host "$DOMAIN" >/dev/null 2>&1; then
    sudo certbot --nginx -d "$DOMAIN" --non-interactive --agree-tos -m "$EMAIL" || {
        warn "SSL 证书申请失败，请确认域名 $DOMAIN 已解析到本机 IP"
        warn "稍后可手动执行: sudo certbot --nginx -d $DOMAIN"
    }
    info "SSL 证书配置完成"
else
    warn "域名 $DOMAIN 未解析到本机，跳过 SSL 配置"
    warn "DNS 解析生效后执行: sudo certbot --nginx -d $DOMAIN"
fi

# ============================================================
# 6. OpenClaw 配置文件模板
# ============================================================
step "6/9 写入 OpenClaw 配置"

# 如果已有配置则跳过
if [ -f "$OPENCLAW_DIR/openclaw.json" ]; then
    warn "openclaw.json 已存在，跳过模板写入"
    warn "如需覆盖请手动编辑: $OPENCLAW_DIR/openclaw.json"
else
    cat > "$OPENCLAW_DIR/openclaw.json" <<JSON
{
  "gateway": {
    "auth": {
      "mode": "token",
      "token": ""
    },
    "mode": "local",
    "port": $PORT,
    "bind": "loopback",
    "tailscale": {
      "mode": "off",
      "resetOnExit": false
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "deepseek/deepseek-v4-flash"
      },
      "workspace": "$WORKSPACE_DIR"
    }
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "$TELEGRAM_BOT_TOKEN",
      "groupPolicy": "open"
    }
  },
  "tools": {
    "profile": "coding",
    "web": {
      "search": {
        "provider": "tavily",
        "enabled": true
      }
    }
  }
}
JSON
    chmod 600 "$OPENCLAW_DIR/openclaw.json"
    info "配置模板已生成 -> $OPENCLAW_DIR/openclaw.json"
    warn "!!! 请编辑该文件填入: gateway.auth.token, channels.telegram.botToken, tavily.apiKey"
fi

# 写入 workspace 基础标识文件
cat > "$WORKSPACE_DIR/IDENTITY.md" <<EOF
# IDENTITY.md - ClawPM 🦞

部署模式: Aliyun ECS
部署时间: $(date '+%Y-%m-%d %H:%M')
域名: $DOMAIN

参考本地 IDENTITY.md 中的完整身份定义。
EOF

info "基础文件写入完成"

# ============================================================
# 7. systemd 服务 — Gateway 保活
# ============================================================
step "7/9 systemd 服务配置"

sudo tee /etc/systemd/system/openclaw-gateway.service >/dev/null <<SYSTEMD
[Unit]
Description=OpenClaw Gateway Service (ClawPM 🦞)
After=network.target nginx.service
Wants=network.target

[Service]
Type=simple
User=$(whoami)
WorkingDirectory=$OPENCLAW_DIR
ExecStart=$(which openclaw) gateway --port $PORT
Restart=always
RestartSec=10
StartLimitInterval=300
StartLimitBurst=3

# 安全限制
NoNewPrivileges=true
ProtectHome=false
ProtectSystem=full
PrivateTmp=true

[Install]
WantedBy=multi-user.target
SYSTEMD

sudo systemctl daemon-reload
sudo systemctl enable openclaw-gateway
sudo systemctl start openclaw-gateway
info "systemd 服务已启动并启用开机自启"

# 等待 Gateway 就绪
sleep 3
if nc -z 127.0.0.1 $PORT; then
    info "Gateway 正在监听 127.0.0.1:$PORT"
else
    warn "Gateway 可能未成功启动，查看日志: sudo journalctl -u openclaw-gateway -n 50 --no-pager"
fi

# ============================================================
# 8. 数据导入（从本地 Mac）
# ============================================================
step "8/9 本地数据导入"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  从本地 Mac 同步配置"
echo ""
echo "  在本地 Mac 上执行:"
echo ""
echo "  rsync -avz --progress \\"
echo "    ~/.openclaw/openclaw.json \\"
echo "    ~/.openclaw/workspace/{MEMORY.md,IDENTITY.md,USER.md,SOUL.md,TOOLS.md} \\"
echo "    ~/.openclaw/workspace/memory/ \\"
echo "    ~/.openclaw/workspace/docs/ \\"
echo "    $(whoami)@$(curl -s ifconfig.me):$OPENCLAW_DIR/"
echo ""
echo "  或者直接复制 openclaw.json 到云端手动编辑"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 下载 workspace 文件（如果本地 Host 可达）
if ping -c1 -W2 "$LOCAL_HOST" >/dev/null 2>&1; then
    info "本地 Mac 可达，尝试同步..."
    rsync -avz --progress \
        "$LOCAL_USER@$LOCAL_HOST:.openclaw/openclaw.json" \
        "$OPENCLAW_DIR/openclaw.json" 2>/dev/null || \
        warn "SSH 同步失败，请手动复制配置"
else
    warn "本地 Mac ($LOCAL_HOST) 不可达，跳过自动同步"
fi

# ============================================================
# 9. 配置 Telegram Webhook（如提供了 Token）
# ============================================================
step "9/9 Telegram Webhook 配置"

if [ -n "$TELEGRAM_BOT_TOKEN" ] && [ -n "$DOMAIN" ]; then
    WEBHOOK_URL="https://$DOMAIN/webhook/telegram"
    RESP=$(curl -sf "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/setWebhook?url=$WEBHOOK_URL" 2>/dev/null || echo '{"ok":false}')
    
    if echo "$RESP" | jq -e '.ok' >/dev/null 2>&1; then
        info "Telegram Webhook 已设置: $WEBHOOK_URL"
    else
        warn "Webhook 设置失败，稍后手动执行:"
        warn "curl 'https://api.telegram.org/bot<TOKEN>/setWebhook?url=$WEBHOOK_URL'"
    fi
else
    warn "未提供 BOT_TOKEN，跳过 Telegram Webhook 配置"
    warn "部署后可手动配置:"
    warn "curl 'https://api.telegram.org/bot<TOKEN>/setWebhook?url=https://$DOMAIN/webhook/telegram'"
fi

# ============================================================
# 完成
# ============================================================
step "✅ 部署完成"

PUBLIC_IP=$(curl -s ifconfig.me 2>/dev/null || echo "未知")
echo ""
echo "┌─────────────────────────────────────────────────┐"
echo "│  🦞 ClawPM 部署摘要                              │"
echo "├─────────────────────────────────────────────────┤"
printf "│  公网 IP:      %-30s │\n" "$PUBLIC_IP"
printf "│  域名:         %-30s │\n" "$DOMAIN"
printf "│  Gateway:      ws://127.0.0.1:%d            │\n" "$PORT"
printf "│  HTTPS:        https://%s                 │\n" "$DOMAIN"
printf "│  Config:       %-30s │\n" "$OPENCLAW_DIR/openclaw.json"
printf "│  Workspace:    %-30s │\n" "$WORKSPACE_DIR"
printf "│  Logs:         %-30s │\n" "sudo journalctl -u openclaw-gateway -f"
echo "└─────────────────────────────────────────────────┘"
echo ""
echo "下一步:"
echo "  1. 编辑 $OPENCLAW_DIR/openclaw.json 填入密钥"
echo "  2. sudo systemctl restart openclaw-gateway"
echo "  3. 从本地同步 workspace 文件 (见上方 rsync 命令)"
echo "  4. 备份: crontab -e 添加定时备份:"
echo '     0 3 * * *  tar czf ~/backups/clawpm-$(date +\%F).tar.gz ~/.openclaw'
echo ""
