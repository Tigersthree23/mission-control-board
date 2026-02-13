#!/bin/bash
# Airtable诊断工具

echo "🔍 Airtable连接诊断"
echo "=================="
echo ""

# 显示当前配置
echo "📋 当前配置："
echo "API Key: ${AIRTABLE_API_KEY:0:20}..."
echo "Base ID: ${AIRTABLE_BASE_ID:-未设置}"
echo ""

# 检查API Key
if [[ -z "$AIRTABLE_API_KEY" ]]; then
    echo "❌ AIRTABLE_API_KEY 未设置"
    echo ""
    echo "请设置环境变量："
    echo "export AIRTABLE_API_KEY='你的API密钥'"
    echo ""
    echo "获取API Key："
    echo "1. 访问 https://airtable.com/create/tokens"
    echo "2. 点击 'Create token'"
    echo "3. 命名token"
    echo "4. 选择权限: Read and write"
    echo "5. 选择范围: All current and future bases in all current and future workspaces"
    exit 1
else
    echo "✅ AIRTABLE_API_KEY 已设置"
fi
echo ""

# 检查Base ID
if [[ -z "$AIRTABLE_BASE_ID" ]]; then
    echo "❌ AIRTABLE_BASE_ID 未设置"
    echo ""
    echo "请设置环境变量："
    echo "export AIRTABLE_BASE_ID='你的Base ID'"
    echo ""
    echo "获取Base ID："
    echo "1. 访问 https://airtable.com"
    echo "2. 选择你的Base"
    echo "3. 从URL中复制Base ID（app开头的部分）"
    echo ""
    echo "示例："
    echo "URL: https://airtable.com/app4YQJd7k0GMqmzE/..."
    echo "Base ID: app4YQJd7k0GMqmzE"
    exit 1
else
    echo "✅ AIRTABLE_BASE_ID 已设置: $AIRTABLE_BASE_ID"
    echo ""
    
    # 验证Base ID格式
    if [[ ! "$AIRTABLE_BASE_ID" =~ ^app[a-zA-Z0-9]+$ ]]; then
        echo "⚠️  警告：Base ID格式可能不正确"
        echo "   期望格式：app后跟字母数字"
        echo "   当前值：$AIRTABLE_BASE_ID"
        echo ""
    fi
fi
echo ""

# 测试连接
echo "🔌 测试Airtable连接..."
echo ""

# 使用curl测试（直接连接Airtable API）
BASE_URL="https://api.airtable.com/v0/$AIRTABLE_BASE_ID"

echo "测试URL: $BASE_URL"
echo ""

# 测试1: 获取Base信息
echo "测试1: 获取Base信息..."
response=$(curl -s -w "\n%{http_code}" -X GET \
  -H "Authorization: Bearer $AIRTABLE_API_KEY" \
  "$BASE_URL" 2>&1)

http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | head -n -1)

if [ "$http_code" = "200" ]; then
    echo "✅ Base存在！"
    echo "$body" | python3 -m json.tool 2>/dev/null || echo "$body"
elif [ "$http_code" = "404" ]; then
    echo "❌ Base不存在或Base ID不正确 (HTTP 404)"
    echo ""
    echo "请检查："
    echo "1. Base ID是否正确: $AIRTABLE_BASE_ID"
    echo "2. 是否在Airtable中创建了这个Base"
    echo "3. 是否有访问权限"
    echo ""
    echo "下一步："
    echo "1. 访问 https://airtable.com"
    echo "2. 创建或选择你的Base"
    echo "3. 从URL中复制正确的Base ID"
    echo "4. 更新环境变量: export AIRTABLE_BASE_ID='正确的Base ID'"
    exit 1
elif [ "$http_code" = "401" ]; then
    echo "❌ API Key无效或权限不足 (HTTP 401)"
    echo ""
    echo "请检查："
    echo "1. API Key是否正确"
    echo "2. 是否有足够的权限"
    exit 1
else
    echo "⚠️  意外的HTTP响应: $http_code"
    echo "响应: $body"
    exit 1
fi
echo ""

# 测试2: 列出所有表
echo "测试2: 列出所有表..."
tables_response=$(curl -s -w "\n%{http_code}" -X GET \
  -H "Authorization: Bearer $AIRTABLE_API_KEY" \
  "$BASE_URL/tables" 2>&1)

tables_http_code=$(echo "$tables_response" | tail -n1)
tables_body=$(echo "$tables_response" | head -n -1)

if [ "$tables_http_code" = "200" ]; then
    echo "✅ 成功获取表列表！"
    echo ""
    table_count=$(echo "$tables_body" | python3 -c "import sys, json; data=json.load(sys.stdin); print(len(data.get('tables', [])))" 2>/dev/null || echo "?")
    echo "找到 $table_count 个表："
    echo ""
    echo "$tables_body" | python3 -m json.tool 2>/dev/null | head -50 || echo "$tables_body" | head -50
    echo ""
    echo "📊 总结："
    echo "- Base ID: $AIRTABLE_BASE_ID"
    echo "- 表数量: $table_count"
    echo ""
    echo "✅ Airtable连接成功！"
    echo ""
    echo "下一步："
    echo "1. 在Airtable中创建表结构"
    echo "2. 参考: cat ~/AIRTABLE-PROJECT-SYSTEM.md"
    echo "3. 或访问: https://airtable.com/app$AIRTABLE_BASE_ID"
else
    echo "❌ 获取表列表失败 (HTTP $tables_http_code)"
    echo "响应: $tables_body"
    exit 1
fi
