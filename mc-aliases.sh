# Mission Control 别名配置
# 添加到 ~/.bashrc 或 source此文件

# 基础别名
alias mc='/home/zf/mission-control.sh'
alias mc-status='/home/zf/mission-control.sh status'
alias mc-open='/home/zf/mission-control.sh open'
alias mc-restart='/home/zf/mission-control.sh restart'
alias mc-logs='/home/zf/mission-control.sh logs'
alias mc-update='/home/zf/mission-control.sh update'

# 任务管理别名
alias mct='/home/zf/mc-task.sh'
alias mct-list='/home/zf/mc-task.sh list'
alias mct-show='/home/zf/mc-task.sh show'
alias mct-stats='/home/zf/mc-task.sh stats'

# 常用组合别名
alias mct-todo='/home/zf/mc-task.sh list backlog'        # 待办任务
alias mct-active='/home/zf/mc-task.sh list active'       # 活跃任务
alias mct-review='/home/zf/mc-task.sh list review'       # 审核中任务

echo "✅ Mission Control 别名已加载"
echo ""
echo "快速命令:"
echo "  mc          - Dashboard管理"
echo "  mct         - 任务管理"
echo "  mct-todo    - 查看待办任务"
echo "  mct-active  - 查看活跃任务"
echo "  mct-stats   - 查看统计信息"
