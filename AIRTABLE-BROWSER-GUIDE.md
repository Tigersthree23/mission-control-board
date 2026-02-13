# Airtable浏览器管理指南

**版本**: 1.0  
**最后更新**: 2026-02-13  
**状态**: ✅ 推荐方式

---

## 🚀 快速开始

由于SSL握手问题，我们推荐**直接使用浏览器管理Airtable**。

---

## 🔗 访问Airtable

### 步骤1：登录Airtable

1. **访问Airtable**：
   ```
   https://airtable.com
   ```

2. **登录或创建账户**：
   - 使用你的邮箱和密码
   - 或创建新账户

### 步骤2：找到你的Base

**选项A：使用现有Base**
```
1. 在Airtable首页找到你的Base
2. 点击进入
3. 从浏览器URL中复制Base ID
```

**选项B：创建新Base**
```
1. 点击"Create a base"
2. 选择"Start from scratch"
3. 命名为"Project Management"
4. 点击"Create"
```

---

## 📊 创建表结构

### 表1：Projects（项目表）

**创建步骤**：
1. 在Base中点击"+ Add a table"
2. 选择"Start from scratch"
3. 命名为"Projects"
4. 点击"Create"

**添加字段**：
1. **Name** - Single line text
   - 项目名称

2. **Description** - Long text
   - 项目描述

3. **Status** - Single select
   - 选项：Planning, In Progress, Completed, On Hold

4. **Priority** - Single select
   - 选项：High, Medium, Low

5. **StartDate** - Date
   - 包含时间：关闭

6. **EndDate** - Date
   - 包含时间：关闭

7. **Progress** - Formula
   - 公式：
   ```
   IF({Tasks}=0, 0, (SUMIF({Tasks}, "Status", "Done")/{Tasks})*100 & "%")
   ```
   - 格式：Percent

8. **Created** - Created time
   - 自动

9. **Modified** - Modified time
   - 自动

### 表2：Tasks（任务表）

**创建步骤**：
1. 点击"+ Add a table"
2. 命名为"Tasks"
3. 点击"Create"

**添加字段**：
1. **Name** - Single line text
   - 任务名称

2. **Description** - Long text
   - 任务描述

3. **Project** - Link to another record
   - 链接到：Projects表
   - 允许链接到多条记录：否

4. **Status** - Single select
   - 选项：Todo, In Progress, Done, Blocked

5. **Priority** - Single select
   - 选项：High, Medium, Low

6. **Assignee** - Single line text
   - 负责人

7. **StartDate** - Date
   - 包含时间：关闭

8. **DueDate** - Date
   - 包含时间：关闭

9. **Progress** - Formula
   - 公式：
   ```
   IF({Subtasks}=0, 0, (SUMIF({Subtasks}, "Status", "Done")/{Subtasks})*100 & "%")
   ```
   - 格式：Percent

10. **Created** - Created time
    - 自动

11. **Modified** - Modified time
    - 自动

### 表3：Subtasks（子任务表）

**创建步骤**：
1. 点击"+ Add a table"
2. 命名为"Subtasks"
3. 点击"Create"

**添加字段**：
1. **Name** - Single line text
   - 子任务名称

2. **Description** - Long text
   - 子任务描述

3. **Task** - Link to another record
   - 链接到：Tasks表
   - 允许链接到多条记录：否

4. **Status** - Single select
   - 选项：Todo, In Progress, Done

5. **Completed** - Checkbox
   - 是否完成

6. **Order** - Number
   - 用于排序

7. **Created** - Created time
   - 自动

8. **Modified** - Modified time
   - 自动

### 表4：Conversations（对话记录表）

**创建步骤**：
1. 点击"+ Add a table"
2. 命名为"Conversations"
3. 点击"Create"

**添加字段**：
1. **Title** - Single line text
   - 对话标题

2. **Content** - Long text
   - 对话内容

3. **RelatedType** - Single select
   - 选项：Project, Task, Subtask

4. **RelatedID** - Single line text
   - 关联记录ID

5. **Speaker** - Single select
   - 选项：User, AI

6. **Created** - Created time
   - 自动

---

## 🔗 设置表关联

### Projects → Tasks

**在Projects表中创建字段**：
1. 添加新字段
2. 类型：**Link to another record**
3. 链接到：**Tasks表**
4. 允许链接到多条记录：**是**

**在Tasks表中会自动创建**：
- **Project** - Link to Projects表（单选）

### Tasks → Subtasks

**在Tasks表中创建字段**：
1. 添加新字段
2. 类型：**Link to another record**
3. 链接到：**Subtasks表**
4. 允许链接到多条记录：**是**

**在Subtasks表中会自动创建**：
- **Task** - Link to Tasks表（单选）

---

## 💡 使用示例

### 示例1：创建一个完整的项目层次

**步骤1：创建项目**
1. 在Projects表中创建新记录
2. Name: "开发用户登录功能"
3. Status: "Planning"
4. Priority: "High"
5. StartDate: 2026-02-13
6. EndDate: 2026-02-20

**步骤2：创建任务**
1. 在Tasks表中创建新记录
2. Name: "设计数据库"
3. Project: [选择上面创建的项目]
4. Status: "Todo"
5. Priority: "High"

**步骤3：创建子任务**
1. 在Subtasks表中创建新记录
2. Name: "设计用户表"
3. Task: [选择上面创建的任务]
4. Status: "Todo"
5. Order: 1

**步骤4：添加对话记录**
1. 在Conversations表中创建新记录
2. Title: "项目启动讨论"
3. Content: "确定需要实现用户登录和注册功能"
4. RelatedType: "Project"
5. RelatedID: [复制项目的Record ID]
6. Speaker: "User"

### 示例2：更新进度

**完成子任务**：
1. 在Subtasks表中找到"设计用户表"
2. 勾选"Completed"字段
3. Status: "Done"

**自动更新任务进度**：
- Tasks表的Progress字段会自动更新

**添加对话记录**：
1. 在Conversations表中创建新记录
2. Title: "字段设计完成"
3. Content: "用户表包含：id, username, email, password_hash"
4. RelatedType: "Subtask"
5. RelatedID: [复制子任务的Record ID]
6. Speaker: "User"

---

## 🎨 配置视图

### Projects表视图

**创建视图**：
1. 点击"Create view"
2. **By Status** - Group by Status
3. **By Priority** - Group by Priority
4. **Timeline** - Timeline view (StartDate到EndDate)

### Tasks表视图

**创建视图**：
1. **By Status** - Group by Status
2. **By Project** - Group by Project
3. **By Priority** - Group by Priority
4. **Calendar** - Calendar view (DueDate)

### Subtasks表视图

**创建视图**：
1. **By Task** - Group by Task
2. **By Status** - Group by Status
3. **Kanban** - Kanban view (按Status)

---

## 🔄 与Mission Control集成

### 双系统同步

**在Mission Control中创建主任务**：
```bash
~/mc-template.sh feature --title "Airtable项目：用户登录" --priority high
```

**在Airtable中创建详细结构**：
1. 创建Projects表记录
2. 创建Tasks表记录
3. 创建Subtasks表记录

**相互引用ID**：
- Mission Control任务中记录："Airtable项目ID: recXXXXX"
- Airtable项目的Conversations表中记录："Mission Control任务ID: mc_XXXXX"

---

## 💡 最佳实践

### 1. 命名规范

**好的命名**：
- ✅ "开发用户登录功能"
- ✅ "设计数据库表结构"
- ✅ "实现用户注册API"

**不好的命名**：
- ❌ "项目1"
- ❌ "任务A"
- ❌ "数据库"

### 2. 描述规范

**好的描述**：
```
项目描述：
实现用户登录和注册功能，包括：
- 用户注册
- 用户登录
- 密码重置
- JWT认证
```

**不好的描述**：
```
登录功能
```

### 3. 对话记录规范

**好的对话记录**：
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

**不好的对话记录**：
```
密码用bcrypt
```

---

## 🆘 故障排查

### 问题1：无法访问Airtable

**解决**：
1. 检查网络连接
2. 清除浏览器缓存
3. 尝试其他浏览器
4. 检查Airtable服务状态

### 问题2：Base ID不正确

**解决**：
1. 在Airtable中打开Base
2. 从浏览器URL中复制Base ID
3. 确保是完整的Base ID（app开头）

### 问题3：字段类型错误

**解决**：
1. 删除错误的字段
2. 重新创建正确类型的字段
3. 迁移数据（如果需要）

---

## 📚 相关资源

- **Airtable Web**: https://airtable.com
- **Airtable University**: https://airtable.com/university
- **Airtable API**: https://airtable.com/developers/web/api
- **项目管理系统文档**: ~/AIRTABLE-PROJECT-SYSTEM.md
- **本地管理指南**: ~/AIRTABLE-LOCAL-GUIDE.md

---

## 🎯 快速开始

### 1. 立即开始

**访问Airtable**：
```
https://airtable.com
```

**创建第一个Base**：
1. 点击"Create a base"
2. 命名为"Project Management"
3. 点击"Create"

**创建第一个项目**：
1. 在Projects表中创建新记录
2. Name: "开发新功能"
3. Status: "Planning"
4. Priority: "Medium"

**创建第一个任务**：
1. 在Tasks表中创建新记录
2. Name: "设计数据库"
3. Project: [选择上面创建的项目]
4. Status: "Todo"
5. Priority: "High"

**创建第一个子任务**：
1. 在Subtasks表中创建新记录
2. Name: "设计用户表"
3. Task: [选择上面创建的任务]
4. Status: "Todo"

**添加第一个对话记录**：
1. 在Conversations表中创建新记录
2. Title: "项目启动"
3. Content: "确定项目目标和技术栈"
4. RelatedType: "Project"
5. RelatedID: [复制项目的Record ID]
6. Speaker: "User"

---

**开始使用Airtable进行项目管理！** 🧠✨

