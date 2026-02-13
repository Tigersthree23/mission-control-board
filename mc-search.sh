#!/bin/bash
# Mission Control 任务搜索工具

WORKSPACE="/home/zf/.openclaw/workspace"
TASKS_FILE="$WORKSPACE/data/tasks.json"

if [ -z "$1" ]; then
    echo "用法: mc-search.sh <search-term>"
    echo ""
    echo "搜索范围："
    echo "  • 任务标题"
    echo "  • 任务描述"
    echo "  • Subtask标题"
    echo "  • 评论内容"
    echo ""
    echo "示例："
    echo "  mc-search.sh 'bug'"
    echo "  mc-search.sh 'Mission Control'"
    exit 1
fi

SEARCH_TERM="$1"

python3 << PYTHON
import json

tasks_file = '$TASKS_FILE'
search_term = '$SEARCH_TERM'.lower()

with open(tasks_file, 'r', encoding='utf-8') as f:
    data = json.load(f)

tasks = data.get('tasks', [])
matching_tasks = []

for t in tasks:
    # 搜索标题、描述
    title_match = search_term in t.get('title', '').lower()
    desc_match = search_term in t.get('description', '').lower()
    
    # 搜索subtasks
    subtask_matches = []
    for s in t.get('subtasks', []):
        if search_term in s.get('title', '').lower():
            subtask_matches.append(s['title'])
    
    # 搜索评论
    comment_matches = []
    for c in t.get('comments', []):
        if search_term in c.get('text', '').lower():
            comment_matches.append(c['text'][:50] + '...')
    
    if title_match or desc_match or subtask_matches or comment_matches:
        matching_tasks.append({
            'task': t,
            'title_match': title_match,
            'desc_match': desc_match,
            'subtask_matches': subtask_matches,
            'comment_matches': comment_matches
        })

if not matching_tasks:
    print(f"❌ 没有找到匹配 '{SEARCH_TERM}' 的任务")
    exit(0)

print(f"🔍 找到 {len(matching_tasks)} 个匹配任务：\n")

# 优先级排序
priority_order = {'high': 0, 'medium': 1, 'low': 2}
matching_tasks.sort(key=lambda x: (
    priority_order.get(x['task'].get('priority', 'low'), 3),
    x['task'].get('id', '')
))

for item in matching_tasks:
    t = item['task']
    status = t.get('status', 'backlog')
    priority = t.get('priority', 'medium')
    
    # 状态图标
    status_icons = {
        'permanent': '🔄',
        'backlog': '📋',
        'in_progress': '🚀',
        'review': '👀',
        'done': '✅'
    }
    icon = status_icons.get(status, '📋')
    
    # 优先级图标
    priority_icons = {
        'high': '🔴',
        'medium': '🟡',
        'low': '🟢'
    }
    priority_icon = priority_icons.get(priority, '⚪')
    
    print(f"{icon} {priority_icon} {t['id']}: {t['title']} [{status}]")
    
    # 显示匹配位置
    if item['subtask_matches']:
        print(f"   └─ Subtasks: {', '.join(item['subtask_matches'])}")
    if item['comment_matches']:
        print(f"   └─ Comments: {', '.join(item['comment_matches'])}")
    print()

PYTHON
