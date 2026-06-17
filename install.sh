#!/bin/bash

set -e

APP=/opt/hax-bot-7.1

echo "🚀 HAX BOT 7.1 INSTALL START"

apt update -y
apt install -y python3 python3-pip python3-venv git curl

rm -rf $APP
git clone https://github.com/mingyueqianli/hax-bot-7.1.git $APP

cd $APP

python3 -m venv venv
source venv/bin/activate

pip install -r requirements.txt

mkdir -p data logs

# =========================
# 🔥 关键修复（必须有）
# =========================
exec < /dev/tty

echo "===================="
read -p "🔑 请输入 TOKEN: " TOKEN

echo "===================="
read -p "⏱ 请输入采集时间(秒): " INTERVAL

# 默认值保护
INTERVAL=${INTERVAL:-30}

echo $TOKEN > token.txt
echo $INTERVAL > interval.txt

# =========================
# 启动服务
# =========================
echo "🚀 启动系统..."

nohup python -m app.collector.runner > logs/collector.log 2>&1 &
nohup python -m app.bot.main > logs/bot.log 2>&1 &

echo "===================="
echo "✅ HAX BOT 7.1 安装完成"
echo "🔑 TOKEN: 已设置"
echo "⏱ INTERVAL: $INTERVAL"
echo "===================="
