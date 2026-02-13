#!/bin/bash
# Mission Control 恢复工具

set -e

BACKUP_DIR="$HOME/mission-control-backups"
WORKSPACE="/home/zf/.openclaw/workspace"

if [ -z "$1" ]; then
    echo "用法: mc-restore.sh <backup-file>"
    echo ""
    echo "可用备份："
    ls -lht "$BACKUP_DIR"/mc-backup-*.tar.gz 2>/dev/null | head -10
    exit 1
fi

BACKUP_FILE="$1"

# 检查备份文件是否存在
if [ ! -f "$BACKUP_FILE" ]; then
    # 尝试相对路径
    if [ -f "$BACKUP_DIR/$BACKUP_FILE" ]; then
        BACKUP_FILE="$BACKUP_DIR/$BACKUP_FILE"
    else
        echo "❌ 备份文件不存在: $BACKUP_FILE"
        exit 1
    fi
fi

echo "🔄 从备份恢复 Mission Control..."
echo "📦 备份文件: $BACKUP_FILE"

# 确认恢复操作
read -p "⚠️  这将覆盖当前的任务数据，确认继续？[y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ 恢复已取消"
    exit 0
fi

# 创建临时目录
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# 解压备份
tar -xzf "$BACKUP_FILE" -C "$TEMP_DIR"

# 复制文件到工作区
cp -v "$TEMP_DIR"/data/tasks.json "$WORKSPACE/data/"
cp -v "$TEMP_DIR"/index.html "$WORKSPACE/" 2>/dev/null || true
cp -v "$TEMP_DIR"/mission-control-*.md "$WORKSPACE/" 2>/dev/null || true
cp -v "$TEMP_DIR"/*.sh "$WORKSPACE/" 2>/dev/null || true

echo ""
echo "✅ 恢复完成"
echo ""
echo "📋 下一步："
echo "  1. 检查任务数据: ~/mc-task.sh stats"
echo "  2. 推送到GitHub: cd ~/.openclaw/workspace && git push origin master"
