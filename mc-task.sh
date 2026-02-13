#!/bin/bash
# Mission Control 高级任务管理工具

set -e

# 固定路径
WORKSPACE="/home/zf/.openclaw/workspace"
TASKS_FILE="$WORKSPACE/data/tasks.json"
MC_UPDATE="$WORKSPACE/skills/mission-control/scripts/mc-update.sh"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() { echo -e "${BLUE}ℹ${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }

# 显示任务列表
list_tasks() {
    local filter="$1"
    
    python3 << PYTHON
import json
import sys

with open('$TASKS_FILE', 'r', encoding='utf-8') as f:
    data = json.load(f)

tasks = data.get('tasks', [])

# 过滤任务
if '$filter':
    filter_type = '$filter'
    if filter_type in ['backlog', 'in_progress', 'review', 'done', 'permanent']:
        tasks = [t for t in tasks if t.get('status') == filter_type]
    elif filter_type == 'active':
        tasks = [t for t in tasks if t.get('status') in ['backlog', 'in_progress', 'review']]
    elif filter_type == 'pending':
        tasks = [t for t in tasks if t.get('status') in ['backlog', 'review']]

if not tasks:
    print("没有找到任务")
    sys.exit(0)

# 按优先级排序
priority_order = {'high': 0, 'medium': 1, 'low': 2}
tasks.sort(key=lambda t: (priority_order.get(t.get('priority', 'low'), 3), t.get('id', '')))

for t in tasks:
    status = t.get('status', 'backlog')
    priority = t.get('priority', 'medium')
    
    status_icons = {
        'permanent': '🔄',
        'backlog': '📋',
        'in_progress': '🚀',
        'review': '👀',
        'done': '✅'
    }
    icon = status_icons.get(status, '📋')
    
    priority_icons = {
        'high': '🔴',
        'medium': '🟡',
        'low': '🟢'
    }
    priority_icon = priority_icons.get(priority, '⚪')
    
    print(f"{icon} {priority_icon} {t['id']}: {t['title']}")
    
    subtasks = t.get('subtasks', [])
    if subtasks:
        done_count = sum(1 for s in subtasks if s.get('done', False))
        print(f"   └─ Subtasks: {done_count}/{len(subtasks)} 完成")

PYTHON
}

# 显示任务详情
show_task() {
    local task_id="$1"
    
    if [[ -z "$task_id" ]]; then
        print_error "请指定任务ID"
        exit 1
    fi
    
    python3 << PYTHON
import json
import sys

with open('$TASKS_FILE', 'r', encoding='utf-8') as f:
    data = json.load(f)

task = None
for t in data.get('tasks', []):
    if t['id'] == '$task_id':
        task = t
        break

if not task:
    print(f"✗ 任务 '{task_id}' 不存在")
    sys.exit(1)

print(f"📌 任务: {task['id']}")
print(f"标题: {task['title']}")
print(f"状态: {task.get('status', 'backlog')}")
print(f"优先级: {task.get('priority', 'medium')}")

if task.get('description'):
    print(f"\n描述:")
    print(task['description'])

if task.get('dod'):
    print(f"\n完成标准:")
    print(task['dod'])

subtasks = task.get('subtasks', [])
if subtasks:
    print(f"\n子任务:")
    for s in subtasks:
        status = "✅" if s.get('done', False) else "⬜"
        print(f"  {status} {s['id']}: {s['title']}")

comments = task.get('comments', [])
if comments:
    print(f"\n评论:")
    for c in comments:
        author = c.get('author', 'Unknown')
        text = c.get('text', '')
        time = c.get('createdAt', '')[:19]
        print(f"  [{time}] {author}: {text}")

PYTHON
}

# 统计信息
show_stats() {
    python3 << PYTHON
import json

with open('$TASKS_FILE', 'r', encoding='utf-8') as f:
    data = json.load(f)

tasks = data.get('tasks', [])

# 统计各状态任务数
status_count = {}
for t in tasks:
    status = t.get('status', 'backlog')
    status_count[status] = status_count.get(status, 0) + 1

# 统计优先级
priority_count = {}
for t in tasks:
    priority = t.get('priority', 'medium')
    priority_count[priority] = priority_count.get(priority, 0) + 1

print("📊 Mission Control 统计")
print()

print("按状态:")
for status in ['permanent', 'backlog', 'in_progress', 'review', 'done']:
    count = status_count.get(status, 0)
    if count > 0:
        status_names = {
            'permanent': '🔄 永久',
            'backlog': '📋 待办',
            'in_progress': '🚀 进行中',
            'review': '👀 审核中',
            'done': '✅ 已完成'
        }
        print(f"  {status_names.get(status, status)}: {count}")

print()
print("按优先级:")
for priority in ['high', 'medium', 'low']:
    count = priority_count.get(priority, 0)
    if count > 0:
        priority_names = {
            'high': '🔴 高',
            'medium': '🟡 中',
            'low': '🟢 低'
        }
        print(f"  {priority_names.get(priority, priority)}: {count}")

print()
print(f"总计: {len(tasks)} 个任务")

PYTHON
}

# 显示帮助
show_help() {
    cat << HELP
🎛️ Mission Control 高级任务管理工具

用法: mc-task.sh <command> [args...]

命令:
  list [filter]          列出任务
                        过滤器: backlog, in_progress, review, done, permanent, active, pending
  
  show <task_id>         显示任务详情
  
  stats                 显示统计信息
  
  help                  显示此帮助信息

示例:
  mc-task.sh list backlog              # 列出待办任务
  mc-task.sh list active               # 列出活跃任务
  mc-task.sh show guide_onboarding     # 显示任务详情
  mc-task.sh stats                     # 显示统计信息

HELP
}

# 主程序
case "$1" in
    list|ls)
        list_tasks "$2"
        ;;
    
    show|info)
        show_task "$2"
        ;;
    
    stats|stat)
        show_stats
        ;;
    
    help|--help|-h|"")
        show_help
        ;;
    
    *)
        print_error "未知命令: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
