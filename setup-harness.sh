#!/bin/bash
# ============================================
# DSH Harness Quick Setup Script
# Run this at the start of each new session
# ============================================

set -e

echo "🚀 Setting up DSH harness environment..."

# 1. Install cloudflared (for tunnels)
if ! command -v cloudflared &> /dev/null; then
    echo "📦 Installing cloudflared..."
    wget --no-check-certificate -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64 -O /usr/local/bin/cloudflared
    chmod +x /usr/local/bin/cloudflared
fi

# 2. Install GitHub CLI
if ! command -v gh &> /dev/null; then
    echo "📦 Installing GitHub CLI..."
    wget --no-check-certificate -q "https://github.com/cli/cli/releases/download/v2.102.0/gh_2.102.0_linux_arm64.tar.gz" -O /tmp/gh.tar.gz
    tar -xzf /tmp/gh.tar.gz -C /tmp
    mv /tmp/gh_2.102.0_linux_arm64/bin/gh /usr/local/bin/
fi

# 3. Install VS Code CLI (for Dev Tunnels)
if [ ! -f "./VSCode-linux-arm64/bin/code" ]; then
    echo "📦 Installing VS Code CLI..."
    curl -fsSL https://code.visualstudio.com/sha/download?build=stable&os=linux-arm64 -o /tmp/vscode.tar.gz
    tar -xzf /tmp/vscode.tar.gz -C /workspace/bold-kalam
fi

# 4. Configure Git credentials (if PAT provided)
if [ -n "$GITHUB_PAT" ] && [ ! -f ~/.git-credentials ]; then
    echo "🔐 Configuring Git credentials..."
    echo "https://$GITHUB_PAT@github.com" > ~/.git-credentials
    git config --global credential.helper store
fi

# 5. Verify tools
echo ""
echo "✅ Setup complete! Available tools:"
command -v git && echo "   Git: $(git --version)"
command -v cloudflared && echo "   cloudflared: $(cloudflared --version)"
command -v gh && echo "   GitHub CLI: $(gh --version | head -1)"
command -v node && echo "   Node.js: $(node --version)"
command -v npm && echo "   npm: $(npm --version)"
[ -f "./VSCode-linux-arm64/bin/code" ] && echo "   VS Code CLI: installed"

echo ""
echo "📋 Next steps:"
echo "   1. Start VS Code Dev Tunnel: ./VSCode-linux-arm64/bin/code tunnel --accept-server-license-terms"
echo "   2. Start cloudflared tunnel: cloudflared tunnel --url http://localhost:8080"
echo "   3. Clone/sync your repo: git pull origin master"
echo ""
echo "💡 Tip: Export your PAT first: export GITHUB_PAT='ghp_xxxxxxxxxxxx'"