# DSH Harness - Quick Reference

## 🎯 Current Project State
- **Workspace:** `/workspace/bold-kalam`
- **Git Repo:** Initialized, synced with `https://github.com/soy66957-boop/Asd.git`
- **Branch:** `master` (1 commit: `cc3a1bd`)

## 🛠️ Installed Tools (This Session)
| Tool | Version | Command |
|------|---------|---------|
| Git | 2.25.1 | `git` |
| cloudflared | 2026.10.1 | `cloudflared` |
| GitHub CLI | 2.102.0 | `gh` |
| Node.js | 24.19.0 | `node` |
| npm | 11.3.0 | `npm` |
| VS Code CLI | Stable | `./VSCode-linux-arm64/bin/code` |

## 🚀 Quick Start for New Sessions

### Option 1: Run the setup script (recommended)
```bash
cd /workspace/bold-kalam
export GITHUB_PAT='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'
./setup-harness.sh
```

### Option 2: Manual commands
```bash
# Install cloudflared
wget --no-check-certificate -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64 -O /usr/local/bin/cloudflared
chmod +x /usr/local/bin/cloudflared

# Install GitHub CLI
wget --no-check-certificate -q "https://github.com/cli/cli/releases/download/v2.102.0/gh_2.102.0_linux_arm64.tar.gz" -O /tmp/gh.tar.gz
tar -xzf /tmp/gh.tar.gz -C /tmp && mv /tmp/gh_2.102.0_linux_arm64/bin/gh /usr/local/bin/

# Configure Git auth
echo "https://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@github.com" > ~/.git-credentials
git config --global credential.helper store
```

## 🔗 IDE Connection Options

### 1. VS Code Dev Tunnel (Best for Desktop)
```bash
./VSCode-linux-arm64/bin/code tunnel --accept-server-license-terms
# Opens https://vscode.dev/tunnel/xxx → use in VS Code Desktop
```

### 2. code-server + Cloudflare Tunnel (Best for Phone/Acode)
```bash
# Terminal 1: Start code-server (if fixed)
code-server --bind-addr 0.0.0.0:8080 --auth none /workspace/bold-kalam

# Terminal 2: Start tunnel
cloudflared tunnel --url http://localhost:8080
# Gives: https://random.trycloudflare.com → use in Acode (code-server mode)
```

### 3. Git + Acode (Simplest, Works Always)
```bash
# In Acode: Clone → https://github.com/soy66957-boop/Asd.git → PAT auth
# Daily: Edit → Commit → Push (phone) ↔ git pull (harness)
```

## 📱 Acode Setup (Phone)
1. **Install Acode** (Play Store / F-Droid)
2. **Clone:** ☰ → Git → Clone Repository
   - URL: `https://github.com/soy66957-boop/Asd.git`
   - Auth: Personal Access Token
   - Token: `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`
3. **Workflow:**
   - Phone: Edit → Commit → Push
   - Harness: `git pull origin master`
   - Harness: Edit → `git add . && git commit -m "msg" && git push`

## 🤖 AI Agent Capabilities (Me)
I can do **all of this** in any session:
- Read/write/edit files in `/workspace/bold-kalam`
- Run bash commands (build, test, deploy)
- Git operations (clone, commit, push, pull, branch)
- GitHub API via `gh` (create PRs, issues, actions)
- Start tunnels for IDE access
- Analyze codebases, refactor, write tests

## ⚠️ What Doesn't Persist
| Lost on New Session | Persists |
|---------------------|----------|
| Installed packages | Files in `/workspace/bold-kalam` |
| Running processes | Git history & remotes |
| Environment variables | GitHub repo (external) |
| SSH keys (if not in workspace) | Your PAT (if re-entered) |

## 📋 Common Commands

### Sync with GitHub
```bash
git pull origin master          # Get latest from phone/GitHub
git add . && git commit -m "msg" && git push origin master  # Push changes
```

### Start Tunnels
```bash
# VS Code Dev Tunnel (for desktop)
./VSCode-linux-arm64/bin/code tunnel --accept-server-license-terms

# Cloudflare tunnel (for any local port)
cloudflared tunnel --url http://localhost:PORT
```

### Build Android (if project added)
```bash
./gradlew assembleDebug         # Debug APK
./gradlew assembleRelease       # Release APK
```

## 🔑 Your Credentials (Save Securely)
- **GitHub Repo:** `https://github.com/soy66957-boop/Asd.git`
- **PAT:** `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`
- **Username:** `soy66957-boop`

---

**Run `./setup-harness.sh` at the start of each new session to restore tools.**