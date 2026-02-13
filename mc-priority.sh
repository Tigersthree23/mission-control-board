#!/bin/bash
# Mission Control 优先级管理工具

WORKSPACE="/home/zf/.openclaw/workspace"
TASKS_FILE="$WORKSPACE/data/tasks.json"

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "用法: mc-priority.sh <task_id> <priority>"
    echo ""
    echo "优先级："
    echo "  high    - 高优先级（紧急重要）"
    echo "  medium  - 中优先级（默认）"
    echo "  low     - 低优先级（可以延后）"
    echo ""
    echo "示例："
    echo "  mc-priority.sh task_demo_001 high"
    exit 1
fi

TASK_ID="$1"
NEW_PRIORITY="$2"

# 验证优先级值
if [[ ! "$NEW_PRIORITY" =~ ^(high|medium|low)$ ]]; then
    echo "❌ 无效的优先级: $NEW_PRIORITY"
    echo "必须是：high, medium, 或 low"
    exit 1
fi

python3 << PYTHON
import json
import sys

tasks_file = '$TASKS_FILE'
task_id = '$TASK_ID'
new_priority = '$NEW_PRIORITY'

with open(tasks_file, 'r', encoding='utf-8') as f:
    data = json.load(f)

found = False
for t in data['tasks']:
    if t['id'] == task_id:
        old_priority = t.get('priority', 'medium')
        t['priority'] = new_priority
        found = True
        print(f"✓ {t['title']}: {old_priority} → {new_priority}")
        break

if not found:
    print(f"✗ 任务 '{task_id}' 不存在")
    sys.exit(1)

with open(tasks_file, 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

PYTHON

# 推送到GitHub
cd "$WORKSPACE"
git add data/tasks.json
git commit -m "chore: update priority of $TASK_ID to $NEW_PRIORITY"
git push origin master

echo ""
echo "✅ 优先级已更新并推送到GitHub"
