# Airtable项目管理系统

**版本**: 1.0  
**最后更新**: 2026-02-13  
**状态**: ✅ 完全就绪

---

## 📋 目录

1. [系统概览](#系统概览)
2. [表结构设计](#表结构设计)
3. [工具使用](#工具使用)
4. [工作流程](#工作流程)
5. [对话记录](#对话记录)
6. [最佳实践](#最佳实践)

---

## 🎯 系统概览

### 什么是Airtable项目管理系统？

这是一个**层次化的项目任务管理系统**，支持：
- **项目**（Projects）→ **任务**（Tasks）→ **子任务**（Subtasks）
- **对话记录**（Conversations）- 记录所有讨论和决策

### 系统架构

```
Projects（项目）
    │
    ├── Task 1（任务1）
    │   │
    │   ├── Subtask 1.1（子任务1.1）
    │   ├── Subtask 1.2（子任务1.2）
    │   └── Conversation（对话记录）
    │
    ├── Task 2（任务2）
    │   │
    │   ├── Subtask 2.1（子任务2.1）
    │   └── Subtask 2.2（子任务2.2）
    │
    └── Task 3（任务3）
        │
        ├── Subtask 3.1（子任务3.1）
        └── Subtask 3.2（子任务3.2）
```

---

## 📊 表结构设计

### 1. Projects表（项目表）

| 字段名 | 类型 | 说明 | 示例 |
|--------|------|------|------|
| **Name** | Single Line Text | 项目名称 | "开发新功能" |
| **Description** | Long Text | 项目描述 | "实现用户登录和注册功能" |
| **Status** | Single Select | 项目状态 | Planning, In Progress, Completed, On Hold |
| **Priority** | Single Select | 优先级 | High, Medium, Low |
| **StartDate** | Date | 开始日期 | 2026-02-13 |
| **EndDate** | Date | 结束日期 | 2026-02-20 |
| **Progress** | Formula | 进度百分比 | 完成任务的百分比 |
| **Created** | Created Time | 创建时间 | 自动 |
| **Modified** | Modified Time | 修改时间 | 自动 |

### 2. Tasks表（任务表）

| 字段名 | 类型 | 说明 | 示例 |
|--------|------|------|------|
| **Name** | Single Line Text | 任务名称 | "设计数据库" |
| **Description** | Long Text | 任务描述 | "设计用户表和权限表" |
| **Project** | Link to Projects | 所属项目 | 链接到Projects表 |
| **Status** | Single Select | 任务状态 | Todo, In Progress, Done, Blocked |
| **Priority** | Single Select | 优先级 | High, Medium, Low |
| **Assignee** | Single Line Text | 负责人 | "张三" |
| **StartDate** | Date | 开始日期 | 2026-02-13 |
| **DueDate** | Date | 截止日期 | 2026-02-15 |
| **Progress** | Formula | 进度百分比 | 完成子任务的百分比 |
| **Created** | Created Time | 创建时间 | 自动 |
| **Modified** | Modified Time | 修改时间 | 自动 |

### 3. Subtasks表（子任务表）

| 字段名 | 类型 | 说明 | 示例 |
|--------|------|------|------|
| **Name** | Single Line Text | 子任务名称 | "设计用户表结构" |
| **Description** | Long Text | 子任务描述 | "包含用户ID、用户名、密码等字段" |
| **Task** | Link to Tasks | 所属任务 | 链接到Tasks表 |
| **Status** | Single Select | 子任务状态 | Todo, In Progress, Done |
| **Completed** | Checkbox | 是否完成 | 勾选框 |
| **Created** | Created Time | 创建时间 | 自动 |
| **Modified** | Modified Time | 修改时间 | 自动 |

### 4. Conversations表（对话记录表）

| 字段名 | 类型 | 说明 | 示例 |
|--------|------|------|------|
| **Title** | Single Line Text | 对话标题 | "关于数据库设计的讨论" |
| **Content** | Long Text | 对话内容 | "我觉得应该增加一个last_login字段..." |
| **RelatedType** | Single Select | 关联类型 | Project, Task, Subtask |
| **RelatedID** | Single Line Text | 关联记录ID | "recXXXXX" |
| **Speaker** | Single Line Text | 发言者 | "User"或"AI" |
| **Created** | Created Time | 创建时间 | 自动 |

---

## 🛠️ 工具使用

### 命令行工具

```bash
# 使用完整路径
/home/zf/airtable-project-manager.sh <command> [args]

# 或使用软链接
~/airtable-project-manager.sh <command> [args]
```

### 命令参考

#### 1. 初始化

```bash
# 显示表结构建议
~/airtable-project-manager.sh init
```

**输出**：
- 建议的表结构
- 字段说明
- 关联关系

**注意**：实际创建需要在Airtable界面手动完成

#### 2. 项目管理

```bash
# 列出所有项目
~/airtable-project-manager.sh project list

# 显示项目详情
~/airtable-project-manager.sh project show <project_id>

# 创建项目
~/airtable-project-manager.sh project create "项目名称" <状态>

# 更新项目
~/airtable-project-manager.sh project update <project_id> "更新字段"
```

**示例**：
```bash
# 创建一个新项目
~/airtable-project-manager.sh project create "开发新功能" "Planning"

# 查看项目详情
~/airtable-project-manager.sh project show recXXXXX

# 更新项目状态
~/airtable-project-manager.sh project update recXXXXX '{"Status": "In Progress"}'
```

#### 3. 任务管理

```bash
# 列出所有任务
~/airtable-project-manager.sh task list

# 列出项目的所有任务
~/airtable-project-manager.sh task list-by-project <project_id>

# 创建任务
~/airtable-project-manager.sh task create "任务标题" <project_id> <状态>

# 更新任务
~/airtable-project-manager.sh task update <task_id> "更新字段"
```

**示例**：
```bash
# 创建一个新任务
~/airtable-project-manager.sh task create "设计数据库" recXXXXX "Todo"

# 查看项目的所有任务
~/airtable-project-manager.sh task list-by-project recXXXXX

# 更新任务状态
~/airtable-project-manager.sh task update recXXXXX '{"Status": "In Progress"}'
```

#### 4. 子任务管理

```bash
# 列出所有子任务
~/airtable-project-manager.sh subtask list

# 列出任务的所有子任务
~/airtable-project-manager.sh subtask list-by-task <task_id>

# 创建子任务
~/airtable-project-manager.sh subtask create "子任务标题" <task_id> <状态>

# 更新子任务
~/airtable-project-manager.sh subtask update <subtask_id> "更新字段"
```

**示例**：
```bash
# 创建一个新子任务
~/airtable-project-manager.sh subtask create "设计用户表" recXXXXX "Todo"

# 查看任务的所有子任务
~/airtable-project-manager.sh subtask list-by-task recXXXXX

# 更新子任务状态
~/airtable-project-manager.sh subtask update recXXXXX '{"Status": "Done", "Completed": true}'
```

#### 5. 对话记录管理

```bash
# 添加对话记录
~/airtable-project-manager.sh conversation add <类型> <记录ID> "对话内容"

# 列出对话记录
~/airtable-project-manager.sh conversation list <类型> <记录ID>
```

**示例**：
```bash
# 为项目添加对话记录
~/airtable-project-manager.sh conversation add Project recXXXXX "我觉得应该先完成需求分析"

# 为任务添加对话记录
~/airtable-project-manager.sh conversation add Task recXXXXX "数据库设计已完成，准备开始编码"

# 为子任务添加对话记录
~/airtable-project-manager.sh conversation add Subtask recXXXXX "用户表结构已确定"

# 查看项目的所有对话
~/airtable-project-manager.sh conversation list Project recXXXXX

# 查看任务的所有对话
~/airtable-project-manager.sh conversation list Task recXXXXX
```

#### 6. 报告生成

```bash
# 生成项目报告
~/airtable-project-manager.sh report
```

**输出**：
- 项目总数
- 任务总数
- 子任务总数
- 对话记录总数

---

## 🔄 工作流程

### 典型使用流程

#### 1. 创建新项目

```bash
# 步骤1：创建项目
~/airtable-project-manager.sh project create "开发新功能" "Planning"

# 步骤2：记录初始对话
~/airtable-project-manager.sh conversation add Project <project_id> \
  "项目启动：确定需要实现用户登录和注册功能"
```

#### 2. 分解任务

```bash
# 步骤3：创建任务
~/airtable-project-manager.sh task create "设计数据库" <project_id> "Todo"
~/airtable-project-manager.sh task create "实现API" <project_id> "Todo"
~/airtable-project-manager.sh task create "前端开发" <project_id> "Todo"

# 步骤4：为每个任务创建子任务
~/airtable-project-manager.sh subtask create "设计用户表" <task_id> "Todo"
~/airtable-project-manager.sh subtask create "设计权限表" <task_id> "Todo"
```

#### 3. 记录对话

```bash
# 步骤5：在执行过程中记录讨论
~/airtable-project-manager.sh conversation add Task <task_id> \
  "讨论了用户表应该包含哪些字段"

~/airtable-project-manager.sh conversation add Subtask <subtask_id> \
  "确定了字段：id, username, email, password_hash"
```

#### 4. 更新进度

```bash
# 步骤6：完成后更新状态
~/airtable-project-manager.sh subtask update <subtask_id> \
  '{"Status": "Done", "Completed": true}'

~/airtable-project-manager.sh task update <task_id> \
  '{"Status": "Done"}'
```

### 与Mission Control集成

```bash
# 1. 在Mission Control中创建项目任务
~/mc-template.sh feature --title "Airtable项目：开发新功能" --priority high

# 2. 在Airtable中创建项目
~/airtable-project-manager.sh project create "开发新功能" "Planning"

# 3. 在Mission Control的任务中记录Airtable项目ID
~/mc-task.sh show <task_id>

# 4. 在对话中提及两个系统的关联
~/airtable-project-manager.sh conversation add Project <project_id> \
  "Mission Control任务ID: <mc_task_id>"
```

---

## 💬 对话记录

### 对话记录的重要性

对话记录系统帮助你：
- **追溯决策过程** - 为什么做某个决定
- **记录讨论内容** - 讨论了什么方案
- **保存重要信息** - 关键的技术决策
- **协作沟通** - 团队成员的交流

### 对话记录最佳实践

#### 1. 结构化记录

**好的记录**：
```
【方案讨论】
问题：如何存储用户密码？
方案A：明文存储（❌ 不安全）
方案B：MD5哈希（⚠️ 已被破解）
方案C：bcrypt哈希（✅ 推荐）

【决策】
采用方案C：bcrypt哈希，带salt

【理由】
1. 安全性高
2. 自动处理salt
3. 计算成本可调整
```

**不好的记录**：
```
密码用bcrypt
```

#### 2. 包含上下文

**好的记录**：
```
在讨论用户表设计时，@张三建议增加last_login字段。
原因是需要追踪用户活跃度。
我同意这个建议，并补充说明也应该考虑增加failed_login_attempts字段用于安全审计。
```

**不好的记录**：
```
增加last_login字段
```

#### 3. 记录决策理由

**好的记录**：
```
选择了PostgreSQL而不是MySQL，理由：
1. 需要JSON字段支持
2. 未来可能需要全文搜索
3. 团队对PostgreSQL更熟悉
```

**不好的记录**：
```
用PostgreSQL
```

### 对话记录示例

#### 项目级别对话

```bash
~/airtable-project-manager.sh conversation add Project <project_id> \
  "【项目启动】
  目标：开发用户登录和注册功能
  时间框架：2周
  团队：前端1人，后端1人"
```

#### 任务级别对话

```bash
~/airtable-project-manager.sh conversation add Task <task_id> \
  "【技术选型】
  前端框架：React
  后端框架：Express.js
  数据库：PostgreSQL
  认证：JWT"
```

#### 子任务级别对话

```bash
~/airtable-project-manager.sh conversation add Subtask <subtask_id> \
  "【字段设计】
  用户表（users）：
  - id: UUID PRIMARY KEY
  - username: VARCHAR(50) UNIQUE NOT NULL
  - email: VARCHAR(100) UNIQUE NOT NULL
  - password_hash: VARCHAR(255) NOT NULL
  - created_at: TIMESTAMP DEFAULT NOW()
  - updated_at: TIMESTAMP DEFAULT NOW()"
```

---

## 💡 最佳实践

### 1. 层次化分解

**原则**：从大到小，逐层分解

```
项目
  └─ 任务（1-2周）
      └─ 子任务（1-3天）
```

**示例**：
- 项目：开发新功能（2周）
  - 任务1：设计数据库（3天）
    - 子任务1.1：设计用户表（1天）
    - 子任务1.2：设计权限表（1天）
    - 子任务1.3：设计关联表（1天）
  - 任务2：实现API（5天）
    - 子任务2.1：实现注册API（2天）
    - 子任务2.2：实现登录API（2天）
    - 子任务2.3：实现密码重置（1天）

### 2. 对话记录策略

**记录时机**：
- ✅ 重要决策
- ✅ 技术选型
- ✅ 方案讨论
- ✅ 问题解决
- ✅ 经验总结

**不记录时机**：
- ❌ 日常闲聊
- ❌ 显而易见的小事
- ❌ 重复信息

### 3. 状态管理

**项目状态**：
- **Planning** - 规划阶段
- **In Progress** - 进行中
- **Completed** - 已完成
- **On Hold** - 暂停

**任务状态**：
- **Todo** - 待办
- **In Progress** - 进行中
- **Done** - 完成
- **Blocked** - 阻塞

**子任务状态**：
- **Todo** - 待办
- **In Progress** - 进行中
- **Done** - 完成

### 4. 优先级管理

**High** - 紧急重要：
- 阻塞其他任务的关键问题
- 安全漏洞
- 紧急bug修复

**Medium** - 正常优先级：
- 正常开发任务
- 功能增强
- 性能优化

**Low** - 可以延后：
- 文档改进
- 代码重构
- 错别字修正

---

## 🔧 故障排查

### 常见问题

#### 1. API Key错误

**错误**：`Invalid API key`

**解决**：
```bash
# 检查环境变量
echo $AIRTABLE_API_KEY

# 设置正确的API Key
export AIRTABLE_API_KEY="your-api-key"
```

#### 2. Base ID错误

**错误**：`NOT_FOUND: Base not found`

**解决**：
```bash
# 检查环境变量
echo $AIRTABLE_BASE_ID

# 设置正确的Base ID
export AIRTABLE_BASE_ID="appXXXXX"
```

#### 3. 表不存在

**错误**：`NOT_FOUND: Table not found`

**解决**：
- 确认表名拼写正确
- 在Airtable界面检查表是否存在
- 表名区分大小写

#### 4. 字段不存在

**错误**：`INVALID_REQUEST_FAILURE: Could not find field`

**解决**：
- 检查字段名拼写
- 确认字段类型正确
- 在Airtable界面检查字段是否存在

---

## 📚 相关资源

- **Airtable API文档**: https://airtable.com/developers/web/api
- **Airtable项目**: https://airtable.com/
- **工具使用**: `~/airtable-project-manager.sh help`

---

**享受层次化的项目管理！** 🧠✨

