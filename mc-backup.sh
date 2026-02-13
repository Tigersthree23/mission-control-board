#!/bin/bash
# Mission Control 备份工具

set -e

WORKSPACE="/home/zf/.openclaw/workspace"
BACKUP_DIR="$HOME/mission-control-backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/mc-backup-$TIMESTAMP.tar.gz"

# 创建备份目录
mkdir -p "$BACKUP_DIR"

echo "🔄 开始备份 Mission Control..."

# 创建备份
tar -czf "$BACKUP_FILE" \
    -C "$WORKSPACE" \
    data/tasks.json \
    index.html \
    mission-control-*.md \
    mission-control.sh \
    mc-task.sh \
    mc-priority.sh \
    mc-search.sh \
    mc-restore.sh \
    mc-check.sh \
    mc-init.sh \
    mc-backup.sh \
    2>/dev/null || true

# 检查备份是否成功
if [ -f "$BACKUP_FILE" ]; then
    SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo "✅ 备份成功: $BACKUP_FILE ($SIZE)"
    
    # 列出所有备份
    echo ""
    echo "📦 现有备份："
    ls -lht "$BACKUP_DIR"/mc-backup-*.tar.gz 2>/dev/null | head -5
    
    # 删除30天前的备份
    find "$BACKUP_DIR" -name "mc-backup-*.tar.gz" -mtime +30 -delete 2>/dev/null
    echo ""
    echo "💡 超过30天的备份已自动清理"
else
    echo "❌ 备份失败"
    exit 1
fi
