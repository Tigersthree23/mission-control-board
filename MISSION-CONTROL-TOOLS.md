# Mission Control 工具使用指南

## 📦 完整工具列表

### 1. 核心管理工具

#### mission-control.sh - Dashboard管理

```bash
# 查看Dashboard状态
~/mission-control.sh status

# 打开Dashboard（在浏览器中）
~/mission-control.sh open

# 重启Dashboard服务
~/mission-control.sh restart

# 查看Dashboard日志
~/mission-control.sh logs

# 更新Dashboard到GitHub
~/mission-control.sh update
```

---

### 2. 任务管理工具

#### mc-task.sh - 任务查询和管理

```bash
# 显示任务统计
~/mc-task.sh stats

# 列出所有任务
~/mc-task.sh list

# 列出特定状态的任务
~/mc-task.sh list backlog      # 待办任务
~/mc-task.sh list in_progress  # 进行中
~/mc-task.sh list review       # 审核中
~/mc-task.sh list done         # 已完成
~/mc-task.sh list permanent    # 永久任务

# 列出活跃任务（backlog + in_progress + review）
~/mc-task.sh list active

# 显示任务详情
~/mc-task.sh show <task_id>
```

**示例**：
```bash
# 查看待办任务
~/mc-task.sh list backlog

# 显示任务详情
~/mc-task.sh show task_demo_001
```

---

#### mc-priority.sh - 优先级管理

```bash
# 更改任务优先级
~/mc-priority.sh <task_id> <priority>

# 优先级选项：
#   high    - 高优先级（紧急重要）
#   medium  - 中优先级（默认）
#   low     - 低优先级（可以延后）
```

**示例**：
```bash
# 将任务设为高优先级
~/mc-priority.sh task_demo_001 high

# 将任务设为低优先级
~/mc-priority.sh task_demo_001 low
```

---

#### mc-search.sh - 任务搜索

```bash
# 搜索任务
~/mc-search.sh <search-term>

# 搜索范围：
#   • 任务标题
#   • 任务描述
#   • Subtask标题
#   • 评论内容
```

**示例**：
```bash
# 搜索包含"bug"的任务
~/mc-search.sh "bug"

# 搜索包含"Mission Control"的任务
~/mc-search.sh "Mission Control"
```

---

### 3. 系统工具

#### mc-check.sh - 系统健康检查

```bash
# 运行系统检查
~/mc-check.sh

# 检查内容：
#   1. Dashboard服务状态
#   2. 文件完整性
#   3. 任务数据格式
#   4. GitHub连接
#   5. GitHub CLI状态
#   6. 工具脚本可执行性
```

---

#### mc-backup.sh - 备份工具

```bash
# 创建备份
~/mc-backup.sh

# 备份内容：
#   • data/tasks.json（任务数据）
#   • index.html（Dashboard）
#   • mission-control-*.md（文档）
#   • *.sh（工具脚本）

# 备份位置：~/mission-control-backups/
# 自动清理：删除30天前的备份
```

---

#### mc-restore.sh - 恢复工具

```bash
# 列出可用备份
~/mc-restore.sh

# 从备份恢复
~/mc-restore.sh <backup-file>

# 示例：
~/mc-restore.sh mc-backup-20260213_130100.tar.gz
```

---

#### mc-init.sh - 初始化别名

```bash
# 加载所有别名（无需重新加载bashrc）
source ~/mc-init.sh

# 加载的别名：
#   mc, mc-status, mc-open, mc-restart, mc-logs, mc-update
#   mct, mct-list, mct-show, mct-stats
```

---

### 4. 任务更新工具

#### mc-update.sh（来自Mission Control技能）

```bash
# 更改任务状态
~/.openclaw/workspace/skills/mission-control/scripts/mc-update.sh \
  status <task_id> <new_status>

# 标记subtask完成
~/.openclaw/workspace/skills/mission-control/scripts/mc-update.sh \
  subtask <task_id> <subtask_id> done

# 添加评论
~/.openclaw/workspace/skills/mission-control/scripts/mc-update.sh \
  comment <task_id> "评论内容"

# 完成任务（移动到review）
~/.openclaw/workspace/skills/mission-control/scripts/mc-update.sh \
  complete <task_id> "完成总结"

# 标记任务开始
~/.openclaw/workspace/skills/mission-control/scripts/mc-update.sh \
  start <task_id>
```

---

## 🚀 常用操作流程

### 查看任务状态

```bash
# 1. 查看统计
~/mc-task.sh stats

# 2. 查看待办任务
~/mc-task.sh list backlog

# 3. 查看高优先级任务
~/mc-task.sh list active | grep "🔴"
```

### 搜索任务

```bash
# 1. 搜索关键词
~/mc-search.sh "关键词"

# 2. 查看搜索结果中的任务详情
~/mc-task.sh show <task_id>
```

### 更改任务优先级

```bash
# 1. 查看任务详情
~/mc-task.sh show <task_id>

# 2. 更改优先级
~/mc-priority.sh <task_id> high

# 3. 验证更改
~/mc-task.sh show <task_id>
```

### 备份和恢复

```bash
# 创建备份
~/mc-backup.sh

# 列出备份
ls -lht ~/mission-control-backups/

# 恢复（如果需要）
~/mc-restore.sh mc-backup-<timestamp>.tar.gz
```

### 系统检查

```bash
# 运行完整检查
~/mc-check.sh

# 检查Dashboard状态
~/mission-control.sh status

# 查看Dashboard日志
~/mission-control.sh logs
```

---

## 💡 使用技巧

### 1. 快速查看待办任务

```bash
# 方式1：使用mc-task.sh
~/mc-task.sh list backlog

# 方式2：使用搜索
~/mc-search.sh "待办"
```

### 2. 查找高优先级任务

```bash
# 列出所有活跃任务，筛选高优先级
~/mc-task.sh list active | grep "🔴"
```

### 3. 批量更新任务

```bash
# 使用mc-update.sh脚本
for task in task_001 task_002 task_003; do
    ~/.openclaw/workspace/skills/mission-control/scripts/mc-update.sh \
        status $task review
done
```

### 4. 定期备份

```bash
# 手动备份
~/mc-backup.sh

# 或者添加到crontab（每天自动备份）
# 0 2 * * * ~/mc-backup.sh
```

---

## 🔧 故障排查

### Dashboard无法访问

```bash
# 检查服务状态
~/mission-control.sh status

# 重启服务
~/mission-control.sh restart

# 查看日志
~/mission-control.sh logs
```

### 任务数据损坏

```bash
# 恢复最近的备份
~/mc-restore.sh ~/mission-control-backups/$(ls -t ~/mission-control-backups/ | head -1)
```

### 工具脚本不可执行

```bash
# 重新设置权限
chmod +x ~/.openclaw/workspace/*.sh
```

---

## 📚 相关文档

- **MISSION-CONTROL-GUIDE.md** - 完整使用指南
- **MISSION-CONTROL-CHEATSHEET.md** - 快速参考
- **MISSION-CONTROL-SETUP.md** - 部署文档
- **skills/mission-control/SKILL.md** - 技能文档

---

**工具版本**: 1.0  
**最后更新**: 2026-02-13

