# Mission Control 完整使用手册

**版本**: 2.0  
**最后更新**: 2026-02-13  
**状态**: ✅ 完全就绪

---

## 📋 目录

1. [系统概览](#系统概览)
2. [Dashboard使用](#dashboard使用)
3. [命令行工具](#命令行工具)
4. [任务工作流](#任务工作流)
5. [高级功能](#高级功能)
6. [最佳实践](#最佳实践)
7. [故障排查](#故障排查)
8. [快速参考](#快速参考)

---

## 🎯 系统概览

### 什么是Mission Control？

Mission Control是一个**AI驱动的看板式任务管理系统**，专为OpenClaw设计。

### 核心特性

- **📊 看板式管理** - 可视化任务流程
- **🤖 AI自动化** - 任务自动执行
- **🔗 GitHub集成** - 版本控制和同步
- **🖥️ Web UI** - 现代化的Dashboard界面
- **⌨️ CLI工具** - 12个命令行工具
- **📱 多设备访问** - GitHub Pages云端访问
- **🔄 自动备份** - 数据安全保障

### 系统架构

```
┌─────────────────────────────────────────────────────────┐
│                   GitHub Pages                          │
│          (https://tigersthree23.github.io/...)        │
└───────────────────┬─────────────────────────────────┘
                    │
┌───────────────────┴─────────────────────────────────┐
│              Dashboard (Web UI)                        │
│         ┌──────────────────────────────┐              │
│         │  Backlog │ In Progress │ Review │ Done │    │
│         └──────────────────────────────┘              │
└───────────────────┬─────────────────────────────────┘
                    │
┌───────────────────┴─────────────────────────────────┐
│              GitHub Repository                         │
│         Tigersthree23/mission-control-board           │
└───────────────────┬─────────────────────────────────┘
                    │
                    ├── Webhook → OpenClaw
                    │
┌───────────────────┴─────────────────────────────────┐
│              Local Workspace                           │
│         ~/.openclaw/workspace/                         │
│                                                         │
│         • data/tasks.json (任务数据）                    │
│         • index.html (Dashboard）                       │
│         • *.sh (CLI工具）                               │
│         • *.md (文档）                                  │
└─────────────────────────────────────────────────────────┘
```

---

## 🖥️ Dashboard使用

### 访问方式

1. **GitHub Pages**（推荐）
   ```
   https://tigersthree23.github.io/mission-control-board/
   ```
   - ✅ 公开访问
   - ✅ 永久在线
   - ✅ 支持多设备

2. **本地服务器**
   ```
   http://127.0.0.1:8080/
   ```
   - ✅ 快速预览
   - ✅ 实时更新
   - ✅ 开机自启

3. **本地文件**
   ```
   file:///home/zf/.openclaw/workspace/mission-control-local.html
   ```
   - ✅ 完全离线
   - ✅ 无需服务器

### Dashboard界面

```
┌─────────────────────────────────────────────────────────┐
│  Mission Control - Tigersthree23      [Connect GitHub] │
├──────────────┬──────────────┬──────────────┬────────┤
│  Backlog     │ In Progress  │   Review     │  Done   │
│  (待办)      │  (进行中)    │   (审核中)   │ (完成)  │
│              │              │              │         │
│  [New Task] │              │              │         │
└──────────────┴──────────────┴──────────────┴────────┘
```

### 任务卡片

每个任务卡片显示：
- **标题** - 任务名称
- **优先级** - 🔴高 / 🟡中 / 🟢低
- **Subtasks** - 进度（如 3/5）
- **Comments** - 评论数量

### 基本操作

**查看任务详情**：
1. 点击任务卡片
2. 查看完整信息

**移动任务**：
- 拖拽任务到不同列
- 状态自动更新

**编辑任务**：
- 点击任务详情中的"Edit"
- 修改标题、描述、优先级等

**添加评论**：
- 在任务详情中输入评论
- 点击"Add Comment"

**完成Subtask**：
- 在任务详情中勾选subtask
- 进度自动更新

---

## ⌨️ 命令行工具

### 工具总览（12个）

#### Dashboard管理
```bash
mission-control.sh     # Dashboard管理
```

#### 任务管理
```bash
mc-task.sh            # 任务查询和管理
mc-priority.sh        # 优先级管理
mc-search.sh          # 任务搜索
mc-template.sh        # 任务模板生成
```

#### 任务更新
```bash
mc-update.sh          # 任务更新（技能提供）
```

#### 系统工具
```bash
mc-check.sh           # 系统健康检查
mc-backup.sh          # 备份工具
mc-restore.sh         # 恢复工具
mc-report.sh          # 报告生成器
```

#### 配置
```bash
mc-init.sh            # 初始化别名
mc-aliases.sh         # 别名配置
```

### 详细使用

#### 1. mission-control.sh - Dashboard管理

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

#### 2. mc-task.sh - 任务查询和管理

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

# 列出活跃任务
~/mc-task.sh list active

# 显示任务详情
~/mc-task.sh show <task_id>
```

#### 3. mc-priority.sh - 优先级管理

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
```

#### 4. mc-search.sh - 任务搜索

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
```

#### 5. mc-template.sh - 任务模板生成

```bash
# 使用模板创建任务
~/mc-template.sh <template-name> [options]
```

**可用模板**：
- `feature` - 新功能开发
- `bugfix` - Bug修复
- `learning` - 学习任务
- `review` - 代码审查
- `maintenance` - 维护任务
- `custom` - 自定义任务

**示例**：
```bash
# 创建新功能任务
~/mc-template.sh feature --title "实现用户登录" --priority high

# 创建学习任务
~/mc-template.sh learning --title "学习Docker"

# 创建自定义任务
~/mc-template.sh custom --title "自定义任务" --desc "详细描述"
```

#### 6. mc-backup.sh - 备份工具

```bash
# 创建备份
~/mc-backup.sh
```

**备份内容**：
- data/tasks.json（任务数据）
- index.html（Dashboard）
- mission-control-*.md（文档）
- *.sh（工具脚本）

**备份位置**：`~/mission-control-backups/`  
**自动清理**：删除30天前的备份

#### 7. mc-restore.sh - 恢复工具

```bash
# 列出可用备份
~/mc-restore.sh

# 从备份恢复
~/mc-restore.sh <backup-file>
```

#### 8. mc-report.sh - 报告生成器

```bash
# 生成任务报告
~/mc-report.sh
```

**报告内容**：
- 任务概览和统计
- 按状态分组
- 按优先级分组
- 高优先级任务详情
- 进行中任务详情
- 最近活动

**报告位置**：`~/.openclaw/workspace/reports/`

#### 9. mc-check.sh - 系统健康检查

```bash
# 运行系统检查
~/mc-check.sh
```

**检查内容**：
1. Dashboard服务状态
2. 文件完整性
3. 任务数据格式
4. GitHub连接
5. GitHub CLI状态
6. 工具脚本可执行性

---

## 🔄 任务工作流

### 任务状态流程

```
┌──────────┐
│ Permanent │ ← 永久任务（每日检查等）
└─────┬────┘
      │
      ↓ (移动到Backlog)
┌──────────┐
│ Backlog  │ ← 待办任务
└─────┬────┘
      │
      ↓ (移动到In Progress)
┌──────────┐
│  In      │ ← 🤖 AI自动执行
│ Progress │
└─────┬────┘
      │
      ↓ (完成Subtasks)
┌──────────┐
│  Review  │ ← 等待审核
└─────┬────┘
      │
      ↓ (审核通过)
┌──────────┐
│   Done   │ ← 已完成
└──────────┘
```

### 自动化工作流

```
人类创建任务
    ↓
任务在Backlog中
    ↓
移动到In Progress
    ↓
GitHub Push → Webhook → OpenClaw检测
    ↓
AI开始执行任务
    ↓
完成Subtasks → 更新Comments
    ↓
移动到Review
    ↓
人类审核 → 移动到Done
```

### 实际使用场景

#### 场景1：开发新功能

```bash
# 1. 使用模板创建任务
~/mc-template.sh feature --title "实现用户登录" --priority high

# 2. 查看任务详情
~/mc-task.sh show <task_id>

# 3. 在Dashboard中将任务移到In Progress
#    AI会自动开始执行

# 4. 查看进度
~/mc-task.sh show <task_id>

# 5. 完成后在Dashboard中移到Review
#    人类审核通过后移到Done
```

#### 场景2：修复Bug

```bash
# 1. 使用模板创建Bug修复任务
~/mc-template.sh bugfix --title "修复导航栏错误"

# 2. 设置高优先级（自动）
~/mc-priority.sh <task_id> high

# 3. 在Dashboard中查看并移到In Progress
#    AI会自动开始修复

# 4. 完成后移动到Review
```

#### 场景3：学习新技术

```bash
# 1. 创建学习任务
~/mc-template.sh learning --title "学习Docker"

# 2. 查看任务详情
~/mc-task.sh show <task_id>

# 3. 按照Subtasks逐步完成
#    AI可以提供帮助和指导

# 4. 完成后移动到Done
```

---

## 🚀 高级功能

### 1. 任务搜索

**多字段搜索**：
```bash
~/mc-search.sh "关键词"
```

搜索范围：
- 任务标题
- 任务描述
- Subtask标题
- 评论内容

**结果排序**：
- 按优先级排序
- 高优先级任务优先显示
- 显示匹配位置

### 2. 批量更新

**使用mc-update.sh脚本**：
```bash
# 批量更改状态
for task in task_001 task_002 task_003; do
    ~/.openclaw/workspace/skills/mission-control/scripts/mc-update.sh \
        status $task review
done
```

### 3. 定期备份

**手动备份**：
```bash
~/mc-backup.sh
```

**自动备份**（添加到crontab）：
```bash
# 编辑crontab
crontab -e

# 添加每天凌晨2点自动备份
0 2 * * * ~/mc-backup.sh
```

### 4. 任务报告

**生成报告**：
```bash
~/mc-report.sh
```

**报告内容**：
- 任务概览和统计
- 按状态和优先级分组
- 高优先级任务详情
- 进行中任务详情
- 最近活动

**报告位置**：`~/.openclaw/workspace/reports/`

### 5. Heartbeat集成

OpenClaw会定期检查：
- **In Progress任务**：是否有长时间无活动的任务
- **Review任务**：是否有新评论需要关注
- **Backlog任务**：是否有高优先级任务需要处理
- **Permanent任务**：是否需要执行

**配置Heartbeat**：编辑`HEARTBEAT.md`

---

## 💡 最佳实践

### 1. 任务创建

**使用模板**：
- 标准化的任务结构
- 预定义的Subtasks
- 明确的完成标准

**明确的目标**：
- 清晰的任务标题
- 详细的任务描述
- 明确的完成标准（DoD）

### 2. 优先级管理

**优先级规则**：
- **High**：紧急bug、关键功能、截止日期
- **Medium**：正常开发任务、学习任务
- **Low**：优化、重构、文档改进

### 3. Subtask分解

**分解原则**：
- 每个subtask应该可以在30分钟内完成
- 明确的完成标准
- 可独立验证

**示例**：
```
❌ 不好的分解：
- sub_001: 实现整个功能

✅ 好的分解：
- sub_001: 设计数据结构
- sub_002: 实现核心逻辑
- sub_003: 添加错误处理
- sub_004: 编写测试
- sub_005: 更新文档
```

### 4. 评论使用

**记录重要信息**：
- 为什么做这个决策
- 如何解决问题
- 遇到什么挑战
- 学到什么

**提供上下文**：
- 问题背景
- 尝试的方案
- 最终的解决方案
- 后续的行动项

### 5. 定期维护

**每周任务**：
- 审查Review任务
- 清理Done任务
- 更新Backlog任务
- 生成任务报告

**每月任务**：
- 备份任务数据
- 审查永久任务
- 优化工作流程
- 更新文档

---

## 🔧 故障排查

### Dashboard无法访问

**问题**：本地服务器显示404  
**解决**：
```bash
~/mission-control.sh restart
```

**问题**：GitHub Pages显示404  
**解决**：等待1-2分钟让GitHub部署完成

### 任务无法自动执行

**问题**：任务移到in_progress但没有反应  
**解决**：
1. 检查OpenClaw Gateway状态
2. 检查webhook transform是否安装
3. 查看OpenClaw日志

### 连接GitHub失败

**问题**：无法连接到GitHub  
**解决**：
1. 检查网络连接
2. 验证token权限（需要repo scope）
3. 确认仓库是公开的

### 任务数据损坏

**问题**：tasks.json格式错误  
**解决**：
```bash
# 恢复最近的备份
~/mc-restore.sh ~/mission-control-backups/$(ls -t ~/mission-control-backups/ | head -1)
```

### 工具脚本不可执行

**问题**：脚本无法执行  
**解决**：
```bash
# 重新设置权限
chmod +x ~/.openclaw/workspace/*.sh
```

---

## 📚 快速参考

### Dashboard访问

- **GitHub Pages**: https://tigersthree23.github.io/mission-control-board/
- **本地服务器**: http://127.0.0.1:8080/
- **本地文件**: ~/.openclaw/workspace/mission-control-local.html

### 常用命令

```bash
# 查看任务统计
~/mc-task.sh stats

# 搜索任务
~/mc-search.sh "关键词"

# 更改优先级
~/mc-priority.sh <task_id> high

# 创建任务
~/mc-template.sh feature --title "新功能"

# 生成报告
~/mc-report.sh

# 创建备份
~/mc-backup.sh
```

### 任务状态

| 状态 | 图标 | 说明 |
|------|------|------|
| **Permanent** | 🔄 | 永久任务 |
| **Backlog** | 📋 | 待办任务 |
| **In Progress** | 🚀 | 进行中（AI自动执行） |
| **Review** | 👀 | 审核中 |
| **Done** | ✅ | 已完成 |

### 优先级

- 🔴 **High** - 高优先级
- 🟡 **Medium** - 中优先级
- 🟢 **Low** - 低优先级

---

## 🎓 学习资源

- **MISSION-CONTROL-SETUP.md** - 部署文档
- **MISSION-CONTROL-GUIDE.md** - 使用指南
- **MISSION-CONTROL-CHEATSHEET.md** - 快速参考
- **MISSION-CONTROL-TOOLS.md** - 工具使用指南

---

**享受高效的任务管理！** 🎛️✨

