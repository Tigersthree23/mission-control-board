# Mission Control 快速参考

## 📱 Dashboard访问

- **GitHub Pages**: https://tigersthree23.github.io/mission-control-board/
- **本地服务器**: http://127.0.0.1:8080/
- **本地文件**: `~/.openclaw/workspace/mission-control-local.html`

---

## 🚀 快速命令

### Dashboard管理

```bash
mc-status       # 查看Dashboard状态
mc-open         # 打开Dashboard（浏览器）
mc-restart      # 重启Dashboard服务
mc-logs         # 查看Dashboard日志
mc-update       # 更新Dashboard到GitHub
```

### 任务查询

```bash
mct-stats       # 任务统计
mct-list        # 列出所有任务
mct-todo        # 列出待办任务（backlog）
mct-active      # 列出活跃任务（backlog+in_progress+review）
mct-review      # 列出审核中任务
mct-show <id>   # 显示任务详情
```

### 任务更新

```bash
# 更改状态
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
```

---

## 📋 任务状态

| 状态 | 图标 | 说明 | 自动化 |
|------|------|------|--------|
| **Permanent** | 🔄 | 永久任务（每日检查等） | 定期执行 |
| **Backlog** | 📋 | 待办任务 | - |
| **In Progress** | 🚀 | 进行中 | ✅ AI自动执行 |
| **Review** | 👀 | 审核中 | - |
| **Done** | ✅ | 已完成 | - |

---

## 🎯 优先级

- 🔴 **High** - 紧急重要
- 🟡 **Medium** - 正常优先级
- 🟢 **Low** - 可以延后

---

## 💡 工作流程

```
创建任务 → Backlog
    ↓
移动到 In Progress
    ↓
GitHub Push → Webhook → OpenClaw检测
    ↓
AI自动执行任务
    ↓
完成Subtasks → 更新进度
    ↓
移动到 Review
    ↓
人工审核 → 移动到 Done
```

---

## 🔧 常用操作

### 查看任务统计
```bash
mct-stats
```

### 查看待办任务
```bash
mct-todo
# 或
mct-list backlog
```

### 查看活跃任务
```bash
mct-active
# 或
mct-list active
```

### 显示任务详情
```bash
mct-show task_demo_001
```

### 完成任务
```bash
~/.openclaw/workspace/skills/mission-control/scripts/mc-update.sh \
  complete task_demo_001 "已完成所有subtasks，学习了Mission Control的基本功能"
```

---

## 📚 文档

- **使用指南**: `MISSION-CONTROL-GUIDE.md`
- **部署文档**: `MISSION-CONTROL-SETUP.md`
- **SKILL文档**: `skills/mission-control/SKILL.md`

---

## 🆘 故障排查

### Dashboard无法访问
```bash
mc-restart
```

### GitHub Pages 404
- 等待1-2分钟让GitHub部署完成

### 任务未自动执行
1. 检查OpenClaw Gateway状态
2. 检查任务是否在In Progress状态
3. 查看OpenClaw日志

---

## 🎓 示例任务

系统已创建一个示例任务：`task_demo_001`

```bash
mct-show task_demo_001
```

这个任务帮助你学习Mission Control的功能。

---

**快速参考** | 最后更新：2026-02-13

