# Airtable项目管理系统 - 设置指南

**版本**: 1.0  
**最后更新**: 2026-02-13

---

## 🚀 快速开始

### 步骤1：登录Airtable

1. 访问 https://airtable.com
2. 登录或创建账户

### 步骤2：创建新的Base

1. 点击"Create a base"
2. 选择"Start from scratch"
3. 命名为"Project Management"
4. 点击"Create"

### 步骤3：创建表结构

#### 表1：Projects（项目表）

创建字段：
1. **Name** - Single line text
2. **Description** - Long text
3. **Status** - Single select
   - 选项：Planning, In Progress, Completed, On Hold
4. **Priority** - Single select
   - 选项：High, Medium, Low
5. **StartDate** - Date
   - 包含时间：关
6. **EndDate** - Date
   - 包含时间：关
7. **Progress** - Formula
   - 公式：`IF({Tasks}=0, 0, (SUMIF({Tasks}, "Status", "Done")/{Tasks})*100 & "%")`
   - 格式：Percent
8. **Tasks** - Count
   - 统计：链接到Tasks表的记录数
   - 对Tasks表设置反向链接字段

#### 表2：Tasks（任务表）

创建字段：
1. **Name** - Single line text
2. **Description** - Long text
3. **Project** - Link to another record
   - 链接到：Projects表
   - 允许链接到多条记录：关
4. **Status** - Single select
   - 选项：Todo, In Progress, Done, Blocked
5. **Priority** - Single select
   - 选项：High, Medium, Low
6. **Assignee** - Single line text
7. **StartDate** - Date
   - 包含时间：关
8. **DueDate** - Date
   - 包含时间：关
9. **Progress** - Formula
   - 公式：`IF({Subtasks}=0, 0, (SUMIF({Subtasks}, "Status", "Done")/{Subtasks})*100 & "%")`
   - 格式：Percent
10. **Subtasks** - Count
    - 统计：链接到Subtasks表的记录数
    - 对Subtasks表设置反向链接字段

#### 表3：Subtasks（子任务表）

创建字段：
1. **Name** - Single line text
2. **Description** - Long text
3. **Task** - Link to another record
   - 链接到：Tasks表
   - 允许链接到多条记录：关
4. **Status** - Single select
   - 选项：Todo, In Progress, Done
5. **Completed** - Checkbox
6. **Order** - Number
   - 用于排序子任务

#### 表4：Conversations（对话记录表）

创建字段：
1. **Title** - Single line text
2. **Content** - Long text
3. **RelatedType** - Single select
   - 选项：Project, Task, Subtask
4. **RelatedID** - Single line text
5. **Speaker** - Single select
   - 选项：User, AI
6. **Created** - Created time

### 步骤4：设置表关联

#### Projects → Tasks

在Projects表中创建字段：
- **Tasks** - Link to Tasks表（多选）
- 允许链接到多条记录：是

在Tasks表中会自动创建：
- **Project** - Link to Projects表（单选）

#### Tasks → Subtasks

在Tasks表中创建字段：
- **Subtasks** - Link to Subtasks表（多选）
- 允许链接到多条记录：是

在Subtasks表中会自动创建：
- **Task** - Link to Tasks表（单选）

### 步骤5：配置视图

#### Projects表视图

创建视图：
1. **By Status** - Group by Status
2. **By Priority** - Group by Priority
3. **Timeline** - Timeline view（StartDate到EndDate）

#### Tasks表视图

创建视图：
1. **By Status** - Group by Status
2. **By Project** - Group by Project
3. **By Priority** - Group by Priority
4. **Calendar** - Calendar view（DueDate）

#### Subtasks表视图

创建视图：
1. **By Task** - Group by Task
2. **By Status** - Group by Status
3. **Kanban** - Kanban view（按Status）

---

## 🔧 配置API访问

### 步骤1：获取API Key

1. 访问 https://airtable.com/create/tokens
2. 点击"Create token"
3. 命名token：`OpenClaw Project Manager`
4. 选择访问权限：
   - **Access**: All current and future bases in all current and future workspaces
   - **Access permissions**: Read and write
5. 点击"Create token"
6. 复制token（只会显示一次！）

### 步骤2：获取Base ID

1. 打开创建的"Project Management" base
2. 查看URL：`https://airtable.com/app<BASE_ID>/...`
3. 复制`<BASE_ID>`部分（以`app`开头）

### 步骤3：配置环境变量

```bash
# 添加到 ~/.bashrc
export AIRTABLE_API_KEY="your-api-key-here"
export AIRTABLE_BASE_ID="appXXXXX"

# 重新加载配置
source ~/.bashrc

# 验证配置
echo $AIRTABLE_API_KEY
echo $AIRTABLE_BASE_ID
```

---

## 🧪 测试连接

### 测试脚本

```bash
# 测试列出所有项目
python3 << 'PYTHON'
import urllib.request
import os
import json

req = urllib.request.Request(
    f'https://gateway.maton.ai/airtable/v0/{os.environ["AIRTABLE_BASE_ID"]}/Projects'
)
req.add_header('Authorization', f'Bearer {os.environ["AIRTABLE_API_KEY"]}')

try:
    response = urllib.request.urlopen(req)
    data = json.load(response)
    print("✅ 连接成功！")
    print(f"找到 {len(data.get('records', []))} 个项目")
except Exception as e:
    print(f"❌ 连接失败：{e}")
PYTHON
```

### 使用命令行工具测试

```bash
# 列出所有项目
~/airtable-project-manager.sh project list

# 生成报告
~/airtable-project-manager.sh report
```

---

## 📝 创建示例数据

### 示例1：创建一个完整的项目层次

```bash
# 1. 创建项目
~/airtable-project-manager.sh project create \
  "开发用户登录功能" "Planning"

# 假设返回的项目ID是 recProject123

# 2. 创建任务
~/airtable-project-manager.sh task create \
  "设计数据库" "recProject123" "Todo"

# 假设返回的任务ID是 recTask456

# 3. 创建子任务
~/airtable-project-manager.sh subtask create \
  "设计用户表" "recTask456" "Todo"

~/airtable-project-manager.sh subtask create \
  "设计权限表" "recTask456" "Todo"

# 4. 添加对话记录
~/airtable-project-manager.sh conversation add \
  Project "recProject123" \
  "【项目启动】确定需要实现用户登录和注册功能，包含用户注册、登录、密码重置等功能"

~/airtable-project-manager.sh conversation add \
  Task "recTask456" \
  "【数据库选择】使用PostgreSQL，原因：需要JSON字段支持"
```

### 示例2：更新进度

```bash
# 1. 完成第一个子任务
~/airtable-project-manager.sh subtask update recSubtask789 \
  '{"Status": "Done", "Completed": true}'

# 2. 记录完成时的对话
~/airtable-project-manager.sh conversation add \
  Subtask "recSubtask789" \
  "用户表结构已完成：id, username, email, password_hash, created_at"

# 3. 更新任务状态
~/airtable-project-manager.sh task update recTask456 \
  '{"Status": "In Progress"}'
```

---

## 🔗 与Mission Control集成

### 双系统集成

```bash
# 1. 在Mission Control中创建主任务
~/mc-template.sh feature --title "Airtable项目：用户登录" --priority high

# 2. 在Airtable中创建项目
~/airtable-project-manager.sh project create \
  "开发用户登录功能" "Planning"

# 3. 在两个系统中相互引用

# 在Mission Control任务中添加评论
~/.openclaw/workspace/skills/mission-control/scripts/mc-update.sh \
  comment <mc_task_id> \
  "Airtable项目ID: recProject123"

# 在Airtable项目中添加对话记录
~/airtable-project-manager.sh conversation add \
  Project recProject123 \
  "Mission Control任务ID: <mc_task_id>"
```

### 同步工作流程

```
1. 在Mission Control中创建任务
   ↓
2. 在Airtable中创建详细的项目结构
   ↓
3. 在两个系统中相互引用ID
   ↓
4. 在Mission Control中管理任务状态
   ↓
5. 在Airtable中记录详细对话和决策
   ↓
6. 定期同步两个系统的进度
```

---

## 💡 高级功能

### 1. 使用公式字段

#### Projects表：Progress公式

```javascript
// 计算项目完成度
IF(
  {Tasks}=0,
  "0%",
  SUMIF({Tasks}, "Status", "Done")/{Tasks}*100 & "%"
)
```

#### Tasks表：Progress公式

```javascript
// 计算任务完成度
IF(
  {Subtasks}=0,
  "0%",
  SUMIF({Subtasks}, "Status", "Done")/{Subtasks}*100 & "%"
)
```

#### 自动状态更新

```javascript
// 根据子任务完成情况自动更新任务状态
IF(
  SUMIF({Subtasks}, "Status", "Done")={Subtasks},
  "Done",
  IF(
    SUMIF({Subtasks}, "Status", "In Progress")>0,
    "In Progress",
    "Todo"
  )
)
```

### 2. 使用视图过滤

#### 只看进行中的任务

1. 创建新视图："Active Tasks"
2. 过滤器：Status is not Done
3. 排序：Priority (High→Low), DueDate (Ascending)

#### 只看我的任务

1. 创建新视图："My Tasks"
2. 过滤器：Assignee is "Your Name"
3. 排序：DueDate (Ascending)

#### 只看本周到期的任务

1. 创建新视图:"This Week"
2. 过滤器：DueDate is within next 7 days
3. 排序：Priority (High→Low)

### 3. 使用自动化

#### 自动发送通知

当任务状态变为"Done"时：
- 发送通知到Slack
- 更新项目进度
- 通知项目经理

#### 自动分配任务

当新任务创建时：
- 根据任务类型自动分配给合适的人
- 发送通知给负责人
- 设置截止日期

---

## 🎓 最佳实践

### 1. 命名规范

**项目命名**：
- ✅ 好的命名："开发用户登录功能"
- ❌ 不好的命名："项目1"、"新项目"

**任务命名**：
- ✅ 好的命名："设计数据库表结构"
- ❌ 不好的命名："数据库"、"设计"

**子任务命名**：
- ✅ 好的命名："设计用户表字段"
- ❌ 不好的命名："用户表"、"字段"

### 2. 描述规范

**好的描述**：
```
用户登录功能需求：
1. 用户可以使用邮箱和密码登录
2. 支持密码重置
3. 登录后返回JWT token
4. Token有效期7天
```

**不好的描述**：
```
登录功能
```

### 3. 对话记录规范

**结构化记录**：
```
【标题】简短的讨论主题

【背景】为什么讨论这个

【方案】
方案A：...
方案B：...
方案C：...

【决策】采用方案X

【理由】
1. 理由1
2. 理由2
```

---

## 🆘 故障排查

### 问题1：无法连接到Airtable

**错误**：`Connection refused`

**解决**：
1. 检查网络连接
2. 验证API Key是否正确
3. 检查Base ID是否正确

### 问题2：表不存在

**错误**：`NOT_FOUND: Table not found`

**解决**：
1. 确认表名拼写正确
2. 在Airtable界面检查表是否存在
3. 区分大小写

### 问题3：字段不存在

**错误**：`INVALID_REQUEST_FAILURE: Could not find field`

**解决**：
1. 检查字段名拼写
2. 在Airtable界面检查字段是否存在
3. 确认字段类型正确

---

## 📚 相关资源

- **Airtable API文档**: https://airtable.com/developers/web/api
- **Airtable University**: https://airtable.com/university
- **Airtable Community**: https://community.airtable.com
- **使用手册**: `AIRTABLE-PROJECT-SYSTEM.md`

---

**开始使用Airtable项目管理系统！** 🧠✨

