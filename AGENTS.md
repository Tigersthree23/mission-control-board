# AGENTS.md - OpenCode与OpenClaw协作

## OpenCode能力

### 基本信息
OpenCode是一个AI编程助手，作为独立的CLI工具运行。

**主要功能**：
- 文件操作（读取、写入、编辑、搜索）
- Bash命令执行
- Git工作流管理
- 代码分析和生成
- 调试和错误诊断
- 项目配置和管理

### 工作目录
OpenCode的工作目录：$(pwd)

**可用工具**：
- bash命令
- 文件读写
- Git操作
- 日志分析

### 协作机制

#### 1. Workspace文件共享
OpenCode会将操作记录到：
- `memory/YYYY-MM-DD.md` - 每日操作记录
- `MEMORY.md` - 长期配置和状态信息

OpenClaw会在每次会话开始时读取这些文件。

#### 2. Memory系统
OpenCode通过以下方式让OpenClaw知道操作：
- 直接写入 `memory/YYYY-MM-DD.md`
- 更新 `MEMORY.md` 的长期记忆

OpenClaw可以通过 `memory_search` 工具检索这些信息。

#### 3. Skill桥梁
已安装 `opencode-assistant` 技能，提供OpenCode与OpenClaw的通信能力。

**功能**：
- 记录OpenCode操作
- 请求OpenClaw执行任务
- 查询OpenClaw状态
- 协同处理问题

#### 4. 通信协议

**OpenCode记录操作格式**：
```markdown
## [2026-02-09 13:50:00] OpenCode操作

- **类型**: [配置变更/文件操作/任务执行]
- **操作**: [具体描述]
- **结果**: [成功/失败/详情]
- **操作者**: OpenCode
```

**OpenClaw读取操作格式**：
```
请使用opencode-assistant技能读取今天的操作记录：memory/2026-02-09.md
```

### 使用场景

#### 场景1：配置变更
```
OpenCode:
1. 修改OpenClaw配置文件
2. 记录到 memory/YYYY-MM-DD.md
3. 使用skill通知OpenClaw

OpenClaw:
1. 读取 memory/YYYY-MM-DD.md
2. 执行配置更新
3. 记录结果
```

#### 场景2：错误处理
```
OpenCode:
1. 检测到OpenClaw错误
2. 记录错误详情
3. 使用skill通知OpenClaw

OpenClaw:
1. 读取memory文件
2. 使用opencode-assistant技能分析错误
3. 查看日志
4. 提供修复建议
```

#### 场景3：任务协作
```
OpenCode:
1. 需要OpenClaw执行某项操作
2. 记录任务
3. 等待OpenClaw完成

OpenClaw:
1. 读取memory文件
2. 执行任务
3. 记录结果
4. 通知OpenCode
```

### 重要提醒

**OpenCode用户注意**：
- OpenClaw会话是独立的，不跨会话记忆信息
- 每次会话开始时会读取最新的memory文件
- 重要配置请写入MEMORY.md以便持久化

**OpenClaw用户注意**：
- 查看memory/今日.md了解OpenCode的最近操作
- 使用memory_search工具可以搜索历史操作
- 如果需要OpenCode协助，使用opencode-assistant技能

## 配置约束（2026-02-09 添加）

### 自动配置限制

**禁止以下自动行为**：
1. ❌ 未经用户确认修改openclaw.json
2. ❌ 自动添加MemorySearch配置
3. ❌ 自动切换主模型
4. ❌ 自动启用任何新功能

### MemorySearch配置约束

**当前状态**：禁用（enabled: false）

**原因**：
- 千问embedding的API格式问题
- OpenAI provider期望的格式 ≠ 千问实际的格式
- 导致对话阻塞和失败

**正确的配置**：
```json
{
  "memorySearch": {
    "enabled": false
  }
}
```

**如果需要启用MemorySearch**：
1. 等待OpenClaw官方对千问的支持
2. 或使用OpenAI官方embedding（需要API密钥）
3. 或使用本地embedding（Ollama，免费）

**重要**：
- OpenClaw配置文件已设置为只读（chmod 444）
- 任何配置变更需要先改变权限
- 这防止OpenClaw自动修改配置

### 模型选择约束

**当前主模型**：zhipu-cn/glm-4.7

**约束**：
- 不要自动切换到千问
- 不要自动修改千问的API配置
- 除非用户明确要求

**原因**：
- 千问API格式兼容性问题
- 多次尝试配置失败
- GLM-4.7稳定可靠

---

## 紧急修复（2026-02-09 18:09）

### 对话问题持续

**症状**：
- GLM-4.7运行正常（有usage统计）
- 但只返回thinking，没有实际内容
- 执行时间短（4.3秒），似乎没有完成

**尝试过的修复**：
1. 禁用MemorySearch → 问题仍在
2. 设置配置文件为只读 → 问题仍在
3. 重启服务 → 问题仍在

### 紧急措施

**当前假设**：
可能是OpenClaw的某个内部状态问题，与配置无关。

**建议**：
1. 清除session缓存
2. 重启整个OpenClaw
3. 或者等待OpenClaw官方支持

---
