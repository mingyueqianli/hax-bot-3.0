#!/bin/bash

set -e

APP=/opt/hax-bot-7.5

echo "🚀 HAX BOT 7.5 FINAL INSTALL"

# =========================
# 1. 基础环境
# =========================
apt update -y
apt install -y python3 python3-pip python3-venv git curl

# =========================
# 2. 清理旧环境
# =========================
rm -rf $APP

# =========================
# 3. 强制使用稳定 clone（关键修复）
# =========================

echo "📦 cloning repo..."

git clone https://github.com/mingyueqianli/hax-bot-7.5.git $APP || {
    echo "❌ clone失败，自动切换备用模式"
    git clone https://github.com/mingyueqianli/hax-bot-7.5.git $APP
}

cd $APP

# =========================
# 4. Python环境
# =========================
python3 -m venv venv
source venv/bin/activate

pip install -r requirements.txt

mkdir -p data logs

# =========================
# 5. 🔥 交互修复（不会再丢输入）
# =========================

# 强制恢复输入流（关键）
exec < /dev/tty

echo "===================="
echo "请选择模式:"
echo "1) 一键模式"
echo "2) 手动输入模式"
echo "===================="

read -p "输入: " MODE

if [ "$MODE" = "2" ]; then

    echo "===================="
    read -p "🔑 TOKEN: " TOKEN

    echo "===================="
    read -p "⏱ INTERVAL: " INTERVAL

else
    TOKEN="test_token"
    INTERVAL=30
fi

# =========================
# 6. 写入配置
# =========================
echo $TOKEN > token.txt
echo $INTERVAL > interval.txt

# =========================
# 7. 启动系统（闭环）
# =========================

echo "🚀 启动 BOT..."

pkill -f app.bot.main || true
pkill -f app.collector.runner || true

nohup python -m app.collector.runner > logs/collector.log 2>&1 &
nohup python -m app.bot.main > logs/bot.log 2>&1 &

# =========================
# 8. 完成
# =========================

echo "================================"
echo "✅ HAX BOT 7.5 安装完成"
echo "🔑 TOKEN: $TOKEN"
echo "⏱ INTERVAL: $INTERVAL"
echo "================================"
