#!/bin/bash
# Airtable项目管理工具 - 本地版本
# 使用前请设置环境变量或直接在脚本中配置

# ==================== 配置区域 ====================
# 方式1：使用环境变量
AIRTABLE_API_KEY="${AIRTABLE_API_KEY:-}"
AIRTABLE_BASE_ID="${AIRTABLE_BASE_ID:-}"

# 方式2：直接配置（如果环境变量未设置）
if [[ -z "$AIRTABLE_API_KEY" ]]; then
    # 请在此处填入你的API Key
    AIRTABLE_API_KEY="pat8qKKvbkPwT20l.8b98f28e72ea6545346b69977d9035e2b5ba07ac31e3e81d40f2f9d7fb42a76373e84b"
fi

if [[ -z "$AIRTABLE_BASE_ID" ]]; then
    # 请在此处填入你的Base ID
    AIRTABLE_BASE_ID="app4YQJd7k0GMqmzE"
fi

# ==================== 工具函数 ====================

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
    print_info "检查Airtable配置..."
    echo ""
    echo "API Key: ${AIRTABLE_API_KEY:0:25}..."
    echo "Base ID: $AIRTABLE_BASE_ID"
    echo ""
    
    if [[ -z "$AIRTABLE_API_KEY" ]]; then
        print_error "AIRTABLE_API_KEY 未设置"
        echo "请设置：export AIRTABLE_API_KEY='your-api-key'"
        exit 1
    fi
    
    if [[ -z "$AIRTABLE_BASE_ID" ]]; then
        print_error "AIRTABLE_BASE_ID 未设置"
        echo "请设置：export AIRTABLE_BASE_ID='appXXXXX'"
        exit 1
    fi
    
    print_success "配置检查通过"
}

# 测试连接（使用Python requests）
test_connection() {
    print_info "测试Airtable连接..."
    
    python3 << PYTHON
import sys
try:
    import requests
except ImportError:
    print("❌ requests库未安装，正在安装...")
    import subprocess
    subprocess.run([sys.executable, "-m", "pip", "install", "requests"], check=True)
    import requests

api_key = "$AIRTABLE_API_KEY"
base_id = "$AIRTABLE_BASE_ID"

# 测试获取表列表
url = f"https://api.airtable.com/v0/meta/bases/{base_id}/tables"
headers = {
    "Authorization": f"Bearer {api_key}"
}

try:
    response = requests.get(url, headers=headers, timeout=10)
    
    if response.status_code == 200:
        data = response.json()
        tables = data.get("tables", [])
        print(f"✅ 连接成功！找到 {len(tables)} 个表")
        print("")
        print("现有表：")
        for table in tables:
            table_type = table.get("type", "base")
            name = table.get("name", "未命名")
            print(f"  - {name} (类型: {table_type})")
    else:
        print(f"❌ 连接失败 (HTTP {response.status_code})")
        print(response.text)
        sys.exit(1)
        
except requests.exceptions.SSLError as e:
    print(f"❌ SSL错误：{e}")
    print("")
    print("可能的解决方案：")
    print("1. 更新Python: sudo apt update && sudo apt install python3")
    print("2. 安装SSL证书: sudo apt install ca-certificates")
    print("3. 升级pip: python3 -m pip install --upgrade pip")
    sys.exit(1)
except Exception as e:
    print(f"❌ 连接错误：{e}")
    sys.exit(1)

PYTHON
}

# 显示帮助
show_help() {
    cat << 'HELP'
🧠 Airtable项目管理工具

用法: ./airtable-manager.sh <command> [args]

命令：
  config                    显示当前配置
  test                      测试Airtable连接
  init                      初始化表结构（显示建议）
  projects                 项目管理
  tasks                      任务管理
  subtasks                 子任务管理
  conversations        对话记录管理
  report                    生成报告
  help                      显示此帮助信息

项目管理：
  list                      列出所有项目
  show <id>                显示项目详情
  create "<名称>" <状态>  创建项目
  update <id> "<字段>"     更新项目

任务管理：
  list                      列出所有任务
  list-by-project <id>    列出项目的所有任务
  create "<标题>" <项目ID> <状态>  创建任务
  update <id> "<字段>"     更新任务

子任务管理：
  list                      列出所有子任务
  list-by-task <id>       列出任务的所有子任务
  create "<标题>" <任务ID> <状态>  创建子任务
  update <id> "<字段>"     更新子任务

对话记录管理：
  add <类型> <记录ID> "<内容>"  添加对话记录
  list <类型> <记录ID>  列出对话记录

环境变量：
  AIRTABLE_API_KEY          Airtable API密钥
  AIRTABLE_BASE_ID          Airtable Base ID

示例：
  # 显示配置
  ./airtable-manager.sh config
  
  # 测试连接
  ./airtable-manager.sh test
  
  # 创建项目
  ./airtable-manager.sh projects create "开发新功能" "Planning"
  
  # 创建任务
  ./airtable-manager.sh tasks create "设计数据库" <项目ID> "Todo"

HELP
}

# 显示配置
show_config() {
    echo "Airtable配置："
    echo ""
    echo "API Key: ${AIRTABLE_API_KEY:0:25}..."
    echo "Base ID: $AIRTABLE_BASE_ID"
    echo ""
    echo "环境变量："
    echo "  export AIRTABLE_API_KEY='$AIRTABLE_API_KEY'"
    echo "  export AIRTABLE_BASE_ID='$AIRTABLE_BASE_ID'"
}

# 主程序
main() {
    local command="$1"
    shift || true
    
    case "$command" in
        config)
            show_config
            ;;
        
        test)
            check_config
            test_connection
            ;;
        
        init)
            print_info "初始化Airtable表结构..."
            echo ""
            cat << 'TABLES'

建议的Airtable表结构：

1. Projects（项目表）
   字段：
   - Name (Single Line Text) - 项目名称
   - Description (Long Text) - 项目描述
   - Status (Single Select: Planning, In Progress, Completed, On Hold)
   - Priority (Single Select: High, Medium, Low)
   - StartDate (Date)
   - EndDate (Date)
   - Tasks (Count to Tasks table)
   - Created (Created Time)
   - Modified (Modified Time)

2. Tasks（任务表）
   字段：
   - Name (Single Line Text) - 任务名称
   - Description (Long Text) - 任务描述
   - Project (Link to Projects table) - 所属项目
   - Status (Single Select: Todo, In Progress, Done, Blocked)
   - Priority (Single Select: High, Medium, Low)
   - Assignee (Single Line Text)
   - StartDate (Date)
   - DueDate (Date)
   - Subtasks (Count to Subtasks table)
   - Created (Created Time)
   - Modified (Modified Time)

3. Subtasks（子任务表）
   字段：
   - Name (Single Line Text) - 子任务名称
   - Description (Long Text) - 子任务描述
   - Task (Link to Tasks table) - 所属任务
   - Status (Single Select: Todo, In Progress, Done)
   - Completed (Checkbox)
   - Order (Number)
   - Created (Created Time)
   - Modified (Modified Time)

4. Conversations（对话记录表）
   字段：
   - Title (Single Line Text) - 对话标题
   - Content (Long Text) - 对话内容
   - RelatedType (Single Select: Project, Task, Subtask)
   - RelatedID (Single Line Text)
   - Speaker (Single Select: User, AI)
   - Created (Created Time)

TABLES
            print_warning "请在Airtable界面手动创建上述表结构"
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

# 如果没有参数，显示帮助
if [[ $# -eq 0 ]]; then
    show_help
else
    main "$@"
fi

