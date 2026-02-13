#!/bin/bash
# Mission Control 任务模板生成器

WORKSPACE="/home/zf/.openclaw/workspace"
TASKS_FILE="$WORKSPACE/data/tasks.json"

show_help() {
    cat << 'HELP'
📝 Mission Control 任务模板生成器

用法: mc-template.sh <template-name> [options]

可用模板：

1. feature - 新功能开发
   用途: 开发新功能或特性
   选项: --title "功能名称" --priority high|medium|low

2. bugfix - Bug修复
   用途: 修复已知的bug或问题
   选项: --title "Bug描述" --priority high|medium|low

3. learning - 学习任务
   用途: 学习新技术或工具
   选项: --title "学习主题"

4. review - 代码审查
   用途: 审查代码或文档
   选项: --title "审查主题"

5. maintenance - 维护任务
   用途: 系统维护或优化
   选项: --title "维护内容"

6. custom - 自定义任务
   用途: 创建自定义任务
   选项: --title "任务标题" --desc "任务描述"

通用选项:
  --title "标题"     任务标题（必需）
  --desc "描述"      任务描述（可选）
  --priority p       优先级: high, medium, low (默认: medium)
  --project p        项目名称 (默认: default)
  --tags t1,t2       标签列表（逗号分隔）

示例:
  mc-template.sh feature --title "实现用户登录" --priority high
  mc-template.sh bugfix --title "修复导航栏错误"
  mc-template.sh learning --title "学习Docker"
  mc-template.sh custom --title "自定义任务" --desc "详细描述"

HELP
}

# 解析参数
TEMPLATE="$1"
shift

TITLE=""
DESCRIPTION=""
PRIORITY="medium"
PROJECT="default"
TAGS=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --title)
            TITLE="$2"
            shift 2
            ;;
        --desc)
            DESCRIPTION="$2"
            shift 2
            ;;
        --priority)
            PRIORITY="$2"
            shift 2
            ;;
        --project)
            PROJECT="$2"
            shift 2
            ;;
        --tags)
            TAGS="$2"
            shift 2
            ;;
        *)
            echo "❌ 未知选项: $1"
            show_help
            exit 1
            ;;
    esac
done

if [[ -z "$TEMPLATE" ]] || [[ "$TEMPLATE" == "help" ]] || [[ "$TEMPLATE" == "--help" ]] || [[ "$TEMPLATE" == "-h" ]]; then
    show_help
    exit 0
fi

# 根据模板生成任务
case "$TEMPLATE" in
    feature)
        TITLE="${TITLE:-新功能开发}"
        DESCRIPTION="${DESCRIPTION:-开发新功能或特性}"
        TAGS="${TAGS:-feature,development}"
        SUBTASKS='[
            {"id": "sub_001", "title": "需求分析和设计", "done": false},
            {"id": "sub_002", "title": "实现核心功能", "done": false},
            {"id": "sub_003", "title": "编写单元测试", "done": false},
            {"id": "sub_004", "title": "代码审查和优化", "done": false},
            {"id": "sub_005", "title": "更新文档", "done": false}
        ]'
        DOD="功能完成标准：\n- [ ] 功能实现完成\n- [ ] 单元测试通过\n- [ ] 代码审查通过\n- [ ] 文档已更新"
        ;;
        
    bugfix)
        TITLE="${TITLE:-Bug修复}"
        DESCRIPTION="${DESCRIPTION:-修复已知的bug或问题}"
        PRIORITY="high"
        TAGS="${TAGS:-bugfix,urgent}"
        SUBTASKS='[
            {"id": "sub_001", "title": "复现和定位问题", "done": false},
            {"id": "sub_002", "title": "修复Bug", "done": false},
            {"id": "sub_003", "title": "编写测试用例", "done": false},
            {"id": "sub_004", "title": "验证修复", "done": false}
        ]'
        DOD="Bug修复完成标准：\n- [ ] 问题已修复\n- [ ] 测试用例通过\n- [ ] 没有回归"
        ;;
        
    learning)
        TITLE="${TITLE:-学习任务}"
        DESCRIPTION="${DESCRIPTION:-学习新技术或工具}"
        PRIORITY="medium"
        TAGS="${TAGS:-learning,growth}"
        SUBTASKS='[
            {"id": "sub_001", "title": "阅读官方文档", "done": false},
            {"id": "sub_002", "title": "实践基础示例", "done": false},
            {"id": "sub_003", "title": "构建小项目", "done": false},
            {"id": "sub_004", "title": "总结和分享", "done": false}
        ]'
        DOD="学习完成标准：\n- [ ] 理解基本概念\n- [ ] 能够独立使用\n- [ ] 完成实践项目"
        ;;
        
    review)
        TITLE="${TITLE:-代码审查}"
        DESCRIPTION="${DESCRIPTION:-审查代码或文档}"
        PRIORITY="medium"
        TAGS="${TAGS:-review,quality}"
        SUBTASKS='[
            {"id": "sub_001", "title": "阅读代码或文档", "done": false},
            {"id": "sub_002", "title": "记录问题和建议", "done": false},
            {"id": "sub_003", "title": "提供反馈", "done": false}
        ]'
        DOD="审查完成标准：\n- [ ] 已完整审查\n- [ ] 提供详细反馈"
        ;;
        
    maintenance)
        TITLE="${TITLE:-维护任务}"
        DESCRIPTION="${DESCRIPTION:-系统维护或优化}"
        PRIORITY="low"
        TAGS="${TAGS:-maintenance,optimization}"
        SUBTASKS='[
            {"id": "sub_001", "title": "分析现状", "done": false},
            {"id": "sub_002", "title": "制定优化方案", "done": false},
            {"id": "sub_003", "title": "实施优化", "done": false},
            {"id": "sub_004", "title": "验证效果", "done": false}
        ]'
        DOD="维护完成标准：\n- [ ] 问题已解决\n- [ ] 性能有提升\n- [ ] 文档已更新"
        ;;
        
    custom)
        if [[ -z "$TITLE" ]]; then
            echo "❌ 自定义任务需要 --title 参数"
            exit 1
        fi
        DESCRIPTION="${DESCRIPTION:-自定义任务描述}"
        TAGS="${TAGS:-custom}"
        SUBTASKS='[
            {"id": "sub_001", "title": "步骤1", "done": false},
            {"id": "sub_002", "title": "步骤2", "done": false},
            {"id": "sub_003", "title": "步骤3", "done": false}
        ]'
        DOD="完成标准：\n- [ ] 所有步骤完成"
        ;;
        
    *)
        echo "❌ 未知模板: $TEMPLATE"
        echo ""
        show_help
        exit 1
        ;;
esac

# 创建任务
python3 << PYTHON
import json
from datetime import datetime

tasks_file = '$TASKS_FILE'

title = '$TITLE'
description = '$DESCRIPTION'
priority = '$PRIORITY'
project = '$PROJECT'
tags = '$TAGS'.split(',')
subtasks = json.loads('''$SUBTASKS''')
dod = '$DOD'

with open(tasks_file, 'r', encoding='utf-8') as f:
    data = json.load(f)

# 生成任务ID
task_id = f"task_{datetime.now().strftime('%Y%m%d%H%M%S')}"

new_task = {
    'id': task_id,
    'title': title,
    'description': description,
    'status': 'backlog',
    'priority': priority,
    'project': project,
    'tags': tags,
    'subtasks': subtasks,
    'dod': dod,
    'comments': [],
    'createdAt': datetime.now().isoformat() + 'Z'
}

data['tasks'].append(new_task)

with open(tasks_file, 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

print(f"✅ 任务已创建: {task_id}")
print(f"  标题: {title}")
print(f"  状态: backlog")
print(f"  优先级: {priority}")
print(f"  Subtasks: {len(subtasks)}个")
print(f"  标签: {', '.join(tags)}")

PYTHON

# 推送到GitHub
cd "$WORKSPACE"
git add data/tasks.json
git commit -m "feat: create task from template '$TEMPLATE'"
git push origin master

echo ""
echo "✅ 任务已创建并推送到GitHub"
echo "📝 查看任务详情: ~/mc-task.sh show $task_id"

