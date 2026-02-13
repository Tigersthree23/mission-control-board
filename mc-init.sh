#!/bin/bash
# Mission Control 初始化脚本 - 立即加载别名和函数

echo "🚀 初始化 Mission Control..."

# 加载别名
alias mc='/home/zf/mission-control.sh'
alias mc-status='/home/zf/mission-control.sh status'
alias mc-open='/home/zf/mission-control.sh open'
alias mc-restart='/home/zf/mission-control.sh restart'
alias mc-logs='/home/zf/mission-control.sh logs'
alias mc-update='/home/zf/mission-control.sh update'

alias mct='/home/zf/mc-task.sh'
alias mct-list='/home/zf/mc-task.sh list'
alias mct-show='/home/zf/mc-task.sh show'
alias mct-stats='/home/zf/mc-task.sh stats'
alias mct-todo='/home/zf/mc-task.sh list backlog'
alias mct-active='/home/zf/mc-task.sh list active'
alias mct-review='/home/zf/mc-task.sh list review'

echo "✅ 别名已加载"
echo ""
echo "可用命令："
echo "  mc       - Dashboard管理"
echo "  mct      - 任务管理"
echo ""
echo "试试："
echo "  mc-status    - 查看Dashboard状态"
echo "  mct-stats    - 查看任务统计"
echo "  mct-todo     - 查看待办任务"
echo ""
echo "💡 提示：在 ~/.bashrc 中添加 'source ~/mc-init.sh' 以永久加载别名"

