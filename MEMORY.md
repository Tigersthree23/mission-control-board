# MEMORY.md - 长期记忆

## 重要配置

### 系统环境
- **操作系统**: Linux (Ubuntu)
- **工作目录**: /home/zf
- **OpenClaw端口**: 18789
- **认证方式**: token（fbfa38688f1ab103c0550edea479ad90aec8eddfd43238fc）

### OpenClaw配置
- **当前模型**: GLM-4.7（智谱，zhipu-cn）
- **备用模型**: dashscope/qwen-plus（免费，速度快）
- **语言偏好**: 中文（2026-02-09 17:05在SOUL.md中配置）
- **MemorySearch**: 已启用（provider: openai）

### OpenCode信息
- **工具类型**: AI编程助手CLI
- **工作目录**: /home/zf
- **可用工具**: bash, read, write, edit, glob, grep, task, webfetch, question, todowrite
- **协作技能**: opencode-assistant（已安装）

### 技术栈
- **Node.js**: v22.22.0
- **npm**: v10.9.4
- **包管理**: npm
- **ESM配置**: 已启用（NODE_OPTIONS=--experimental-specifier-resolution=node）

## 重要决策

### 模型选择决策 (2026-02-09)
- **决策**: 使用GLM-4.7作为主要模型
- **原因**: 
  - 千问模型API格式不兼容（OpenAI vs Anthropic）
  - GLM-4.7功能稳定，支持中英文
  - 适合复杂推理和编程任务
- **备选**: 千问qwen-plus（日常快速对话）

### 语言配置决策 (2026-02-09)
- **决策**: OpenClaw默认回复中文
- **实现**: 在SOUL.md中添加Language Preference
- **原因**: 提升用户体验，减少语言切换

## 历史问题

### OpenClaw对话问题 (2026-02-09)
- **问题**: 千问模型无回复
- **原因**: API格式不匹配（anthropic-messages vs OpenAI）
- **解决**: 切换到GLM-4.7模型

### OpenClaw语言问题 (2026-02-09)
- **问题**: 回复英文而非中文
- **解决**: 在SOUL.md添加Language Preference
- **结果**: 正常回复中文

---
此文件记录重要的配置、决策和知识，每次OpenClaw会话开始时读取。

## OpenClaw向量搜索问题 (2026-02-09 17:52)

### 问题描述
配置MemorySearch（向量搜索）后出现对话问题：
- GLM-4.7响应只有thinking，没有实际内容
- API调用成功（有usage统计）
- 执行时间8.7秒后无输出

### 根本原因
MemorySearch配置问题：
- Provider: openai
- Embedding模型: text-embedding-v4（千问）
- 但千问使用Anthropic API格式
- 导致embedding调用失败或阻塞

### 解决方案
**临时方案**: 禁用MemorySearch
```json
"memorySearch": {
  "enabled": false
}
```

**长期方案**: 
1. 使用支持OpenAI格式的embedding模型
2. 或修复千问embedding的API适配
3. 或配置本地embedding服务

### 配置文件
- OpenClaw配置: ~/.openclaw/openclaw.json
- Memory文件: ~/.openclaw/workspace/MEMORY.md
- 每日记录: ~/.openclaw/workspace/memory/YYYY-MM-DD.md

---

## OpenClaw自动配置问题（2026-02-09 18:03）

### 问题描述
OpenClaw在用户询问"向量搜索"时，自动修改了配置文件，添加了错误的MemorySearch配置。

### 根本原因

OpenClaw的"智能配置"机制：
- 检测到MemorySearch配置不完整
- 自动添加详细的provider/model/remote配置
- 但配置是错误的（API格式不匹配）
- 没有验证配置正确性

### 修复措施

1. **禁用MemorySearch**
   ```json
   {
     "memorySearch": {
       "enabled": false
     }
   }
   ```

2. **设置配置文件为只读**
   ```bash
   chmod 444 ~/.openclaw/openclaw.json
   ```
   防止OpenClaw自动修改

3. **添加配置约束**
   在AGENTS.md中明确：
   - 禁止自动配置
   - MemorySearch禁用原因
   - 模型选择约束

### 当前状态

- MemorySearch: 已禁用
- 主模型: GLM-4.7
- 配置文件: 只读
- 服务状态: 正常运行

### 经验教训

OpenClaw的配置系统问题：
1. "智能配置"没有验证机制
2. 添加配置时不告知用户
3. 没有配置版本控制
4. 导致用户难以排查问题

**建议**：如果需要配置修改，手动编辑配置文件，不要让OpenClaw自动配置。

---
