#!/bin/bash
# Mission Control 快速启动脚本

case "$1" in
  open|o)
    echo "🚀 打开Mission Control Dashboard..."
    if command -v xdg-open &> /dev/null; then
      xdg-open http://127.0.0.1:8080/ 2>/dev/null || \
      xdg-open /home/zf/.openclaw/workspace/mission-control-local.html
    else
      echo "📱 请在浏览器中打开以下URL之一："
      echo ""
      echo "  GitHub Pages（推荐）:"
      echo "  https://tigersthree23.github.io/mission-control-board/"
      echo ""
      echo "  本地服务器:"
      echo "  http://127.0.0.1:8080/"
      echo ""
      echo "  本地文件:"
      echo "  file:///home/zf/.openclaw/workspace/mission-control-local.html"
    fi
    ;;
  
  status|s)
    echo "📊 Mission Control 状态："
    echo ""
    echo "Dashboard服务:"
    systemctl --user status mission-control-dashboard.service --no-pager
    echo ""
    echo "GitHub Pages:"
    echo "  URL: https://tigersthree23.github.io/mission-control-board/"
    echo ""
    echo "本地服务器:"
    echo "  URL: http://127.0.0.1:8080/"
    echo "  状态: $(curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8080/)"
    ;;
  
  restart|r)
    echo "🔄 重启Mission Control Dashboard..."
    systemctl --user restart mission-control-dashboard.service
    echo "✅ Dashboard已重启"
    ~/.openclaw/workspace/mission-control.sh status
    ;;
  
  stop)
    echo "⏹️  停止Mission Control Dashboard..."
    systemctl --user stop mission-control-dashboard.service
    echo "✅ Dashboard已停止"
    ;;
  
  start)
    echo "▶️  启动Mission Control Dashboard..."
    systemctl --user start mission-control-dashboard.service
    echo "✅ Dashboard已启动"
    ~/.openclaw/workspace/mission-control.sh status
    ;;
  
  logs|log|l)
    echo "📋 Dashboard日志（Ctrl+C退出）："
    journalctl --user -u mission-control-dashboard -f
    ;;
  
  update|u)
    echo "🔄 更新Dashboard..."
    cd /home/zf/.openclaw/workspace
    git add index.html data/tasks.json
    git commit -m "chore: update Mission Control dashboard"
    git push origin master
    echo "✅ Dashboard已更新到GitHub"
    ;;
  
  help|h|*)
    echo "🎛️  Mission Control - 任务管理系统"
    echo ""
    echo "用法: mission-control.sh [命令]"
    echo ""
    echo "命令:"
    echo "  open, o    打开Dashboard（在浏览器中）"
    echo "  status, s  显示Dashboard状态"
    echo "  restart, r 重启Dashboard服务"
    echo "  start      启动Dashboard服务"
    echo "  stop       停止Dashboard服务"
    echo "  logs, l    查看Dashboard日志"
    echo "  update, u  更新Dashboard到GitHub"
    echo "  help, h    显示此帮助信息"
    echo ""
    echo "访问方式:"
    echo "  GitHub Pages: https://tigersthree23.github.io/mission-control-board/"
    echo "  本地服务器: http://127.0.0.1:8080/"
    echo "  本地文件: file:///home/zf/.openclaw/workspace/mission-control-local.html"
    ;;
esac
