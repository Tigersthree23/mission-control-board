#!/bin/bash
# Airtable 项目管理工具
# 支持：项目 → 任务 → 子任务，并记录对话内容

set -e

# 配置
MATON_API_KEY="${MATON_API_KEY:-}"
BASE_ID="${AIRTABLE_BASE_ID:-}"
GATEWAY_URL="https://gateway.maton.ai/airtable/v0"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() { echo -e "${BLUE}ℹ${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }

# 检查配置
check_config() {
    if [[ -z "$MATON_API_KEY" ]]; then
        print_error "MATON_API_KEY 未设置"
        echo "请设置环境变量：export MATON_API_KEY='your-api-key'"
        exit 1
    fi
    
    if [[ -z "$BASE_ID" ]]; then
        print_error "AIRTABLE_BASE_ID 未设置"
        echo "请设置环境变量：export AIRTABLE_BASE_ID='appXXXXX'"
        exit 1
    fi
}

# API请求
airtable_request() {
    local method="$1"
    local endpoint="$2"
    local data="$3"
    
    if [[ -n "$data" ]]; then
        curl -s -X "$method" \
            -H "Authorization: Bearer $MATON_API_KEY" \
            -H "Content-Type: application/json" \
            -d "$data" \
            "$GATEWAY_URL/$BASE_ID/$endpoint"
    else
        curl -s -X "$method" \
            -H "Authorization: Bearer $MATON_API_KEY" \
            "$GATEWAY_URL/$BASE_ID/$endpoint"
    fi
}

# 列出所有记录
list_records() {
    local table="$1"
    local filter="$2"
    
    local url="$table?maxRecords=100"
    if [[ -n "$filter" ]]; then
        url="$table?filterByFormula=${filter}"
    fi
    
    airtable_request "GET" "$url" ""
}

# 创建记录
create_record() {
    local table="$1"
    local fields="$2"
    
    local data="{\"records\":[{\"fields\":$fields}]}"
    airtable_request "POST" "$table" "$data"
}

# 更新记录
update_record() {
    local table="$1"
    local record_id="$2"
    local fields="$3"
    
    local data="{\"records\":[{\"id\":\"$record_id\",\"fields\":$fields}]}"
    airtable_request "PATCH" "$table" "$data"
}

# 获取记录
get_record() {
    local table="$1"
    local record_id="$2"
    
    airtable_request "GET" "$table/$record_id" ""
}

# 删除记录
delete_record() {
    local table="$1"
    local record_id="$2"
    
    airtable_request "DELETE" "$table?records[]=$record_id" ""
}

# 显示帮助
show_help() {
    cat << 'HELP'
🧠 Airtable 项目管理工具

用法: airtable-project-manager.sh <command> [args]

命令：
  init                    初始化Airtable表结构
  project                 项目管理
  task                    任务管理
  subtask                 子任务管理
  conversation            对话记录管理
  report                  生成报告
  help                    显示此帮助信息

项目管理：
  list                    列出所有项目
  show <id>               显示项目详情
  create "<名称>" <状态>  创建项目
  update <id> "<字段>"     更新项目

任务管理：
  list                    列出所有任务
  list-by-project <id>    列出项目的所有任务
  create "<标题>" <项目ID> <状态>  创建任务
  update <id> "<字段>"     更新任务

子任务管理：
  list                    列出所有子任务
  list-by-task <id>       列出任务的所有子任务
  create "<标题>" <任务ID> <状态>  创建子任务
  update <id> "<字段>"     更新子任务

对话管理：
  add <记录类型> <记录ID> "<内容>"  添加对话记录
  list <记录类型> <记录ID>  列出对话记录

示例：
  # 初始化表结构
  airtable-project-manager.sh init
  
  # 创建项目
  airtable-project-manager.sh project create "开发新功能" "Planning"
  
  # 创建任务
  airtable-project-manager.sh task create "实现用户登录" <项目ID> "Todo"
  
  # 创建子任务
  airtable-project-manager.sh subtask create "设计数据库" <任务ID> "Todo"
  
  # 添加对话记录
  airtable-project-manager.sh conversation add Task <任务ID> "讨论了登录方案"

HELP
}

# 初始化表结构
init_tables() {
    print_info "初始化Airtable表结构..."
    
    # 注意：这里只显示建议的表结构
    # 实际创建需要在Airtable界面手动完成
    
    cat << 'TABLES'
建议的Airtable表结构：

1. Projects（项目表）
   - Name (Single Line Text) - 项目名称
   - Description (Long Text) - 项目描述
   - Status (Single Select) - Planning, In Progress, Completed, On Hold
   - Priority (Single Select) - High, Medium, Low
   - StartDate (Date) - 开始日期
   - EndDate (Date) - 结束日期
   - Progress (Formula) - 进度百分比
   - Created (Created Time) - 创建时间
   - Modified (Modified Time) - 修改时间

2. Tasks（任务表）
   - Name (Single Line Text) - 任务名称
   - Description (Long Text) - 任务描述
   - Project (Link to Projects) - 所属项目
   - Status (Single Select) - Todo, In Progress, Done, Blocked
   - Priority (Single Select) - High, Medium, Low
   - Assignee (Single Line Text) - 负责人
   - StartDate (Date) - 开始日期
   - DueDate (Date) - 截止日期
   - Progress (Formula) - 进度百分比
   - Created (Created Time) - 创建时间
   - Modified (Modified Time) - 修改时间

3. Subtasks（子任务表）
   - Name (Single Line Text) - 子任务名称
   - Description (Long Text) - 子任务描述
   - Task (Link to Tasks) - 所属任务
   - Status (Single Select) - Todo, In Progress, Done
   - Completed (Checkbox) - 是否完成
   - Created (Created Time) - 创建时间
   - Modified (Modified Time) - 修改时间

4. Conversations（对话记录表）
   - Title (Single Line Text) - 对话标题
   - Content (Long Text) - 对话内容
   - RelatedType (Single Select) - Project, Task, Subtask
   - RelatedID (Single Line Text) - 关联记录ID
   - Speaker (Single Line Text) - 发言者
   - Created (Created Time) - 创建时间

TABLES
    
    print_warning "请在Airtable界面手动创建上述表结构"
}

# 项目管理
manage_projects() {
    local action="$1"
    shift
    
    case "$action" in
        list)
            print_info "列出所有项目..."
            list_records "Projects" | python3 -m json.tool
            ;;
        
        show)
            local project_id="$1"
            print_info "显示项目详情: $project_id"
            get_record "Projects" "$project_id" | python3 -m json.tool
            ;;
        
        create)
            local name="$1"
            local status="${2:-Planning}"
            
            if [[ -z "$name" ]]; then
                print_error "请提供项目名称"
                exit 1
            fi
            
            print_info "创建项目: $name"
            local fields="{\"Name\":\"$name\",\"Status\":\"$status\"}"
            create_record "Projects" "$fields" | python3 -m json.tool
            ;;
        
        update)
            local project_id="$1"
            local fields="$2"
            
            if [[ -z "$project_id" ]] || [[ -z "$fields" ]]; then
                print_error "请提供项目ID和更新字段"
                exit 1
            fi
            
            print_info "更新项目: $project_id"
            update_record "Projects" "$project_id" "$fields" | python3 -m json.tool
            ;;
        
        *)
            print_error "未知的项目操作: $action"
            exit 1
            ;;
    esac
}

# 任务管理
manage_tasks() {
    local action="$1"
    shift
    
    case "$action" in
        list)
            print_info "列出所有任务..."
            list_records "Tasks" | python3 -m json.tool
            ;;
        
        list-by-project)
            local project_id="$1"
            print_info "列出项目 $project_id 的所有任务..."
            list_records "Tasks" "{Project}='$project_id'" | python3 -m json.tool
            ;;
        
        create)
            local title="$1"
            local project_id="$2"
            local status="${3:-Todo}"
            
            if [[ -z "$title" ]] || [[ -z "$project_id" ]]; then
                print_error "请提供任务标题和项目ID"
                exit 1
            fi
            
            print_info "创建任务: $title"
            local fields="{\"Name\":\"$title\",\"Project\":[\"$project_id\"],\"Status\":\"$status\"}"
            create_record "Tasks" "$fields" | python3 -m json.tool
            ;;
        
        update)
            local task_id="$1"
            local fields="$2"
            
            if [[ -z "$task_id" ]] || [[ -z "$fields" ]]; then
                print_error "请提供任务ID和更新字段"
                exit 1
            fi
            
            print_info "更新任务: $task_id"
            update_record "Tasks" "$task_id" "$fields" | python3 -m json.tool
            ;;
        
        *)
            print_error "未知的任务操作: $action"
            exit 1
            ;;
    esac
}

# 子任务管理
manage_subtasks() {
    local action="$1"
    shift
    
    case "$action" in
        list)
            print_info "列出所有子任务..."
            list_records "Subtasks" | python3 -m json.tool
            ;;
        
        list-by-task)
            local task_id="$1"
            print_info "列出任务 $task_id 的所有子任务..."
            list_records "Subtasks" "{Task}='$task_id'" | python3 -m json.tool
            ;;
        
        create)
            local title="$1"
            local task_id="$2"
            local status="${3:-Todo}"
            
            if [[ -z "$title" ]] || [[ -z "$task_id" ]]; then
                print_error "请提供子任务标题和任务ID"
                exit 1
            fi
            
            print_info "创建子任务: $title"
            local fields="{\"Name\":\"$title\",\"Task\":[\"$task_id\"],\"Status\":\"$status\"}"
            create_record "Subtasks" "$fields" | python3 -m json.tool
            ;;
        
        update)
            local subtask_id="$1"
            local fields="$2"
            
            if [[ -z "$subtask_id" ]] || [[ -z "$fields" ]]; then
                print_error "请提供子任务ID和更新字段"
                exit 1
            fi
            
            print_info "更新子任务: $subtask_id"
            update_record "Subtasks" "$subtask_id" "$fields" | python3 -m json.tool
            ;;
        
        *)
            print_error "未知的子任务操作: $action"
            exit 1
            ;;
    esac
}

# 对话管理
manage_conversations() {
    local action="$1"
    shift
    
    case "$action" in
        add)
            local related_type="$1"
            local related_id="$2"
            local content="$3"
            local speaker="${4:-User}"
            
            if [[ -z "$related_type" ]] || [[ -z "$related_id" ]] || [[ -z "$content" ]]; then
                print_error "请提供关联类型、关联ID和对话内容"
                exit 1
            fi
            
            print_info "添加对话记录..."
            local title="关于${related_type}的讨论"
            local fields="{\"Title\":\"$title\",\"Content\":\"$content\",\"RelatedType\":\"$related_type\",\"RelatedID\":\"$related_id\",\"Speaker\":\"$speaker\"}"
            create_record "Conversations" "$fields" | python3 -m json.tool
            ;;
        
        list)
            local related_type="$1"
            local related_id="$2"
            
            if [[ -z "$related_type" ]] || [[ -z "$related_id" ]]; then
                print_error "请提供关联类型和关联ID"
                exit 1
            fi
            
            print_info "列出对话记录..."
            list_records "Conversations" "AND({RelatedType}='$related_type',{RelatedID}='$related_id')" | python3 -m json.tool
            ;;
        
        *)
            print_error "未知的对话操作: $action"
            exit 1
            ;;
    esac
}

# 生成报告
generate_report() {
    print_info "生成项目报告..."
    
    echo "=== 项目统计 ==="
    echo ""
    
    # 统计项目
    local projects=$(list_records "Projects" "")
    local project_count=$(echo "$projects" | python3 -c "import sys, json; data=json.load(sys.stdin); print(len(data.get('records', [])))")
    echo "项目总数: $project_count"
    
    # 统计任务
    local tasks=$(list_records "Tasks" "")
    local task_count=$(echo "$tasks" | python3 -c "import sys, json; data=json.load(sys.stdin); print(len(data.get('records', [])))")
    echo "任务总数: $task_count"
    
    # 统计子任务
    local subtasks=$(list_records "Subtasks" "")
    local subtask_count=$(echo "$subtasks" | python3 -c "import sys, json; data=json.load(sys.stdin); print(len(data.get('records', [])))")
    echo "子任务总数: $subtask_count"
    
    # 统计对话
    local conversations=$(list_records "Conversations" "")
    local conversation_count=$(echo "$conversations" | python3 -c "import sys, json; data=json.load(sys.stdin); print(len(data.get('records', [])))")
    echo "对话记录总数: $conversation_count"
    
    echo ""
    echo "=== 详细信息 ==="
    echo "使用以下命令查看详细信息："
    echo "  airtable-project-manager.sh project list"
    echo "  airtable-project-manager.sh task list"
    echo "  airtable-project-manager.sh subtask list"
    echo "  airtable-project-manager.sh conversation list <Type> <ID>"
}

# 主程序
main() {
    check_config
    
    local command="$1"
    shift || true
    
    case "$command" in
        init)
            init_tables
            ;;
        
        project)
            manage_projects "$@"
            ;;
        
        task)
            manage_tasks "$@"
            ;;
        
        subtask)
            manage_subtasks "$@"
            ;;
        
        conversation)
            manage_conversations "$@"
            ;;
        
        report)
            generate_report
            ;;
        
        help|--help|-h|"")
            show_help
            ;;
        
        *)
            print_error "未知命令: $command"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

main "$@"

