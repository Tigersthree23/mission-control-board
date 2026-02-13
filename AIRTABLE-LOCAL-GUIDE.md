# Airtable本地管理指南

**由于SSL握手问题，我们采用本地管理方式**

---

## 🔧 当前配置

```bash
# API配置
export AIRTABLE_API_KEY="pat8qKKvbkPwT20l.8b98f28e72ea6545346b69977d9035e2b5ba07ac31e3e81d40f2f9d7fb42a76373e84b"
export AIRTABLE_BASE_ID="app4YQJd7k0GMqmzE"
```

---

## 🌐 直接访问Airtable

### 方式1：使用Airtable Web界面

1. **访问你的Base**：
   ```
   https://airtable.com/app4YQJd7k0GMqmzE
   ```

2. **创建表结构**：
   - Projects（项目表）
   - Tasks（任务表）
   - Subtasks（子任务表）
   - Conversations（对话记录表）

3. **手动添加数据**：
   - 直接在Airtable界面中创建项目、任务、子任务
   - 在Conversations表中记录对话

### 方式2：使用Airtable API + curl

由于Python SSL问题，我们使用curl：

```bash
# 列出所有项目
curl -v "https://api.airtable.com/v0/app4YQJd7k0GMqmzE/Projects" \
  -H "Authorization: Bearer pat8qKKvbkPwT20l.8b98f28e72ea6545346b69977d9035e2b5ba07ac31e3e81d40f2f9d7fb42a76373e84b"
```

---

## 📝 手动管理流程

### 1. 在Airtable中创建项目

**步骤**：
1. 访问 https://airtable.com/app4YQJd7k0GMqmzE
2. 创建Projects表
3. 添加字段：
   - Name (Single Line Text)
   - Description (Long Text)
   - Status (Single Select)
   - Priority (Single Select)
4. 创建第一条记录：
   - Name: "开发新功能"
   - Status: "Planning"
   - Priority: "Medium"

### 2. 在Airtable中创建任务

**步骤**：
1. 创建Tasks表
2. 添加字段：
   - Name (Single Line Text)
   - Description (Long Text)
   - Project (Link to Projects)
   - Status (Single Select)
   - Priority (Single Select)
3. 创建第一条记录：
   - Name: "设计数据库"
   - Project: [链接到上面创建的项目]
   - Status: "Todo"
   - Priority: "High"

### 3. 在Airtable中创建子任务

**步骤**：
1. 创建Subtasks表
2. 添加字段：
   - Name (Single Line Text)
   - Description (Long Text)
   - Task (Link to Tasks)
   - Status (Single Select)
   - Completed (Checkbox)
3. 创建第一条记录：
   - Name: "设计用户表"
   - Task: [链接到上面创建的任务]
   - Status: "Todo"
   - Completed: [不勾选]

### 4. 在Airtable中记录对话

**步骤**：
1. 创建Conversations表
2. 添加字段：
   - Title (Single Line Text)
   - Content (Long Text)
   - RelatedType (Single Select)
   - RelatedID (Single Line Text)
   - Speaker (Single Select)
3. 创建对话记录：
   - Title: "关于项目的讨论"
   - Content: "讨论了项目的技术方案，决定使用PostgreSQL"
   - RelatedType: "Project"
   - RelatedID: [复制项目的Record ID]
   - Speaker: "User"

---

## 🔄 与Mission Control集成

### 同步工作流程

**步骤1：在Mission Control中创建主任务**
```bash
~/mc-template.sh feature --title "Airtable项目：开发新功能" --priority high
```

**步骤2：在Airtable中创建详细的项目结构**
- 访问Airtable
- 创建项目、任务、子任务
- 记录项目ID（recXXXXX格式）

**步骤3：相互引用**
- 在Mission Control任务中添加评论："Airtable项目ID: recXXXXX"
- 在Airtable项目的Conversations表中添加记录："Mission Control任务ID: mc_XXXXX"

**步骤4：双向更新**
- Mission Control：管理任务状态、进度
- Airtable：记录详细对话、决策

---

## 💡 使用技巧

### 1. 使用Airtable的链接字段

- Projects表中的Tasks字段 → 链接到Tasks表
- Tasks表中的Subtasks字段 → 链接到Subtasks表
- 这样可以在一个地方看到所有相关的任务和子任务

### 2. 使用Airtable的公式字段

**Projects表中的进度公式**：
```javascript
IF(Tasks=0, "0%", (SUMIF(Tasks, "Status", "Done")/Tasks)*100 & "%")
```

**Tasks表中的进度公式**：
```javascript
IF(Subtasks=0, "0%", (SUMIF(Subtasks, "Status", "Done")/Subtasks)*100 & "%")
```

### 3. 使用Airtable的视图

**Projects表**：
- Group by Status
- Timeline view (StartDate到EndDate)

**Tasks表**：
- Group by Status
- Group by Project
- Calendar view (DueDate)

**Subtasks表**：
- Group by Task
- Kanban view (按Status)

**Conversations表**：
- Group by RelatedType
- Sort by Created (descending)

### 4. 使用Airtable的自动化

**自动化1：任务状态更新**
- 当所有子任务完成时，自动将任务状态设为"Done"

**自动化2：发送通知**
- 当任务状态变为"High Priority"时，发送通知

**自动化3：记录时间戳**
- 当记录创建时，自动添加Created时间

---

## 🛠️ 故障排查

### 问题1：SSL握手失败

**解决方案**：使用Airtable Web界面直接管理

### 问题2：API调用失败

**解决方案**：
1. 检查API Key是否正确
2. 检查Base ID是否正确
3. 检查网络连接
4. 使用Airtable Web界面

### 问题3：表不存在

**解决方案**：在Airtable Web界面手动创建表

---

## 📚 相关资源

- **Airtable Web界面**: https://airtable.com/app4YQJd7k0GMqmzE
- **Airtable API文档**: https://airtable.com/developers/web/api
- **项目管理文档**: AIRTABLE-PROJECT-SYSTEM.md
- **设置指南**: AIRTABLE-SETUP-GUIDE.md

---

## 🎯 快速开始

### 立即开始

1. **访问Airtable**：
   ```
   https://airtable.com/app4YQJd7k0GMqmzE
   ```

2. **创建第一个项目**：
   - 表名：Projects
   - 字段：Name, Description, Status, Priority
   - 第一条记录："开发新功能"

3. **创建第一个任务**：
   - 表名：Tasks
   - 字段：Name, Description, Project, Status, Priority
   - 第一条记录："设计数据库"

4. **在Mission Control中同步**：
   ```bash
   ~/mc-template.sh feature --title "Airtable项目：开发新功能" --priority high
   ```

---

**开始使用Airtable进行项目管理！** 🧠✨

