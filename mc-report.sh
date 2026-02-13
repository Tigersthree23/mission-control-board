#!/bin/bash
# Mission Control 报告生成器

WORKSPACE="/home/zf/.openclaw/workspace"
TASKS_FILE="$WORKSPACE/data/tasks.json"
REPORT_DIR="$WORKSPACE/reports"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# 创建报告目录
mkdir -p "$REPORT_DIR"

REPORT_FILE="$REPORT_DIR/mc-report-$TIMESTAMP.txt"

echo "📊 生成 Mission Control 报告..."

python3 << PYTHON
import json
from datetime import datetime

tasks_file = '$TASKS_FILE'
report_file = '$REPORT_FILE'

with open(tasks_file, 'r', encoding='utf-8') as f:
    data = json.load(f)

tasks = data.get('tasks', [])

# 统计数据
status_count = {}
priority_count = {}
total_subtasks = 0
completed_subtasks = 0

for t in tasks:
    status = t.get('status', 'backlog')
    priority = t.get('priority', 'medium')
    
    status_count[status] = status_count.get(status, 0) + 1
    priority_count[priority] = priority_count.get(priority, 0) + 1
    
    subtasks = t.get('subtasks', [])
    total_subtasks += len(subtasks)
    completed_subtasks += sum(1 for s in subtasks if s.get('done', False))

# 生成报告
with open(report_file, 'w', encoding='utf-8') as f:
    f.write("=" * 70 + "\n")
    f.write("Mission Control 任务报告\n")
    f.write("=" * 70 + "\n")
    f.write(f"生成时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
    f.write("\n")
    
    # 概览
    f.write("📊 概览\n")
    f.write("-" * 70 + "\n")
    f.write(f"总任务数: {len(tasks)}\n")
    f.write(f"总Subtasks: {total_subtasks}\n")
    f.write(f"已完成Subtasks: {completed_subtasks}\n")
    f.write(f"完成率: {completed_subtasks/total_subtasks*100:.1f}%\n" if total_subtasks > 0 else "完成率: N/A\n")
    f.write("\n")
    
    # 按状态统计
    f.write("📋 按状态统计\n")
    f.write("-" * 70 + "\n")
    status_names = {
        'permanent': '🔄 永久任务',
        'backlog': '📋 待办任务',
        'in_progress': '🚀 进行中',
        'review': '👀 审核中',
        'done': '✅ 已完成'
    }
    for status in ['permanent', 'backlog', 'in_progress', 'review', 'done']:
        count = status_count.get(status, 0)
        if count > 0:
            f.write(f"{status_names.get(status, status)}: {count}\n")
    f.write("\n")
    
    # 按优先级统计
    f.write("🎯 按优先级统计\n")
    f.write("-" * 70 + "\n")
    priority_names = {
        'high': '🔴 高优先级',
        'medium': '🟡 中优先级',
        'low': '🟢 低优先级'
    }
    for priority in ['high', 'medium', 'low']:
        count = priority_count.get(priority, 0)
        if count > 0:
            f.write(f"{priority_names.get(priority, priority)}: {count}\n")
    f.write("\n")
    
    # 高优先级任务详情
    f.write("⚠️  高优先级任务\n")
    f.write("-" * 70 + "\n")
    high_priority_tasks = [t for t in tasks if t.get('priority') == 'high']
    if high_priority_tasks:
        for t in high_priority_tasks:
            status = t.get('status', 'backlog')
            subtasks = t.get('subtasks', [])
            done_count = sum(1 for s in subtasks if s.get('done', False))
            f.write(f"• {t['id']}: {t['title']}\n")
            f.write(f"  状态: {status} | Subtasks: {done_count}/{len(subtasks)}\n")
    else:
        f.write("（无）\n")
    f.write("\n")
    
    # 进行中任务
    f.write("🚀 进行中任务\n")
    f.write("-" * 70 + "\n")
    in_progress_tasks = [t for t in tasks if t.get('status') == 'in_progress']
    if in_progress_tasks:
        for t in in_progress_tasks:
            started = t.get('processingStartedAt', '未知')
            subtasks = t.get('subtasks', [])
            done_count = sum(1 for s in subtasks if s.get('done', False))
            f.write(f"• {t['id']}: {t['title']}\n")
            f.write(f"  开始时间: {started}\n")
            f.write(f"  Subtasks: {done_count}/{len(subtasks)}\n")
    else:
        f.write("（无）\n")
    f.write("\n")
    
    # 待审核任务
    f.write("👀 待审核任务\n")
    f.write("-" * 70 + "\n")
    review_tasks = [t for t in tasks if t.get('status') == 'review']
    if review_tasks:
        for t in review_tasks:
            comments = t.get('comments', [])
            f.write(f"• {t['id']}: {t['title']}\n")
            f.write(f"  评论数: {len(comments)}\n")
    else:
        f.write("（无）\n")
    f.write("\n")
    
    # 最近活动
    f.write("📝 最近活动（最新5条评论）\n")
    f.write("-" * 70 + "\n")
    all_comments = []
    for t in tasks:
        comments = t.get('comments', [])
        for c in comments:
            all_comments.append({
                'task_id': t['id'],
                'task_title': t['title'],
                'comment': c
            })
    
    # 按时间排序
    all_comments.sort(key=lambda x: x['comment'].get('createdAt', ''), reverse=True)
    
    for i, item in enumerate(all_comments[:5]):
        c = item['comment']
        author = c.get('author', 'Unknown')
        text = c.get('text', '')
        time = c.get('createdAt', '')[:19]
        f.write(f"{i+1}. [{time}] {item['task_id']} - {author}\n")
        f.write(f"   {text[:100]}{'...' if len(text) > 100 else ''}\n")
    
    if not all_comments:
        f.write("（无最近活动）\n")
    f.write("\n")
    
    f.write("=" * 70 + "\n")
    f.write("报告结束\n")
    f.write("=" * 70 + "\n")

print(f"✅ 报告已生成: {report_file}")

# 显示报告内容
print("\n📄 报告内容：")
print("-" * 70)
with open(report_file, 'r', encoding='utf-8') as f:
    print(f.read())

PYTHON
