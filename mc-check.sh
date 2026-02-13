#!/bin/bash
# Mission Control 系统检查脚本

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  🎛️ Mission Control 系统检查                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

check_pass() {
    echo -e "${GREEN}✓${NC} $1"
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

check_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# 检查Dashboard服务
echo "1️⃣  Dashboard服务"
if systemctl --user is-active --quiet mission-control-dashboard.service; then
    check_pass "Dashboard服务运行中"
    PORT_STATUS=$(curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8080/)
    if [ "$PORT_STATUS" = "200" ]; then
        check_pass "本地服务器可访问 (http://127.0.0.1:8080/)"
    else
        check_fail "本地服务器不可访问 (HTTP $PORT_STATUS)"
    fi
else
    check_fail "Dashboard服务未运行"
fi
echo ""

# 检查文件
echo "2️⃣  文件检查"
FILES=(
    "$HOME/.openclaw/workspace/index.html"
    "$HOME/.openclaw/workspace/data/tasks.json"
    "$HOME/.openclaw/workspace/mission-control.sh"
    "$HOME/.openclaw/workspace/mc-task.sh"
    "$HOME/.clawdbot/mission-control.json"
    "$HOME/.openclaw/hooks-transforms/github-mission-control.mjs"
)

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        check_pass "$(basename $file)"
    else
        check_fail "$(basename $file) 不存在"
    fi
done
echo ""

# 检查任务数据
echo "3️⃣  任务数据"
if python3 -c "import json; json.load(open('$HOME/.openclaw/workspace/data/tasks.json'))" 2>/dev/null; then
    check_pass "tasks.json 格式正确"
    
    # 统计任务
    STATS=$(python3 << PYTHON
import json
with open('$HOME/.openclaw/workspace/data/tasks.json', 'r') as f:
    data = json.load(f)
tasks = data.get('tasks', [])
status_count = {}
for t in tasks:
    status = t.get('status', 'backlog')
    status_count[status] = status_count.get(status, 0) + 1
for status in ['permanent', 'backlog', 'in_progress', 'review', 'done']:
    count = status_count.get(status, 0)
    if count > 0:
        print(f"{status}:{count}")
PYTHON
)
    echo "   $STATS"
else
    check_fail "tasks.json 格式错误"
fi
echo ""

# 检查GitHub连接
echo "4️⃣  GitHub连接"
if git -C "$HOME/.openclaw/workspace" remote get-url origin &>/dev/null; then
    check_pass "Git远程仓库已配置"
    REPO_URL=$(git -C "$HOME/.openclaw/workspace" remote get-url origin | sed 's/.*github.com[:/]\(.*\)\.git/\1/')
    echo "   仓库: $REPO_URL"
else
    check_fail "Git远程仓库未配置"
fi
echo ""

# 检查GitHub CLI
echo "5️⃣  GitHub CLI"
if command -v gh &>/dev/null; then
    check_pass "GitHub CLI已安装"
    if gh auth status &>/dev/null; then
        check_pass "GitHub CLI已登录"
    else
        check_fail "GitHub CLI未登录"
    fi
else
    check_warn "GitHub CLI未安装"
fi
echo ""

# 检查工具脚本
echo "6️⃣  工具脚本"
TOOLS=(
    "mission-control.sh"
    "mc-task.sh"
    "mc-init.sh"
)

for tool in "${TOOLS[@]}"; do
    if [ -x "$HOME/.openclaw/workspace/$tool" ]; then
        check_pass "$tool 可执行"
    else
        check_fail "$tool 不可执行或不存在"
    fi
done
echo ""

# 总结
echo "══════════════════════════════════════════════════════════════"
echo ""
echo "📊 快速命令："
echo "  查看Dashboard状态:"
echo "    ~/mission-control.sh status"
echo ""
echo "  查看任务统计:"
echo "    ~/mc-task.sh stats"
echo ""
echo "  列出待办任务:"
echo "    ~/mc-task.sh list backlog"
echo ""
echo "  打开Dashboard（在浏览器中）:"
echo "    ~/mission-control.sh open"
echo ""
echo "📚 文档："
echo "  • MISSION-CONTROL-GUIDE.md - 使用指南"
echo "  • MISSION-CONTROL-CHEATSHEET.md - 快速参考"
echo "  • MISSION-CONTROL-SETUP.md - 部署文档"
echo ""
echo "══════════════════════════════════════════════════════════════"

