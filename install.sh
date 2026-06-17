#!/bin/bash

set -e

APP=/opt/hax-bot-6.4

echo "🚀 HAX BOT 6.4 INSTALL (FIXED)"

apt update -y
apt install -y python3 python3-pip python3-venv git

# =========================
# ✔ 正确方式：重新 clone（关键修复）
# =========================
rm -rf $APP

git clone https://github.com/mingyueqianli/hax-bot-6.4.git $APP

cd $APP   # ⭐ 关键：必须进入仓库目录

# =========================
# python环境
# =========================
python3 -m venv venv
source venv/bin/activate

# ⭐ 这里才会找到 requirements.txt
pip install -r requirements.txt

mkdir -p data logs

# =========================
# 输入 TOKEN（强制交互）
# =========================
exec < /dev/tty

echo "===================="
read -p "请输入 TOKEN: " TOKEN
echo $TOKEN > token.txt

echo "===================="
read -p "采集时间(秒默认30): " INTERVAL
INTERVAL=${INTERVAL:-30}
echo $INTERVAL > interval.txt

# =========================
# 启动
# =========================
echo "🚀 启动服务..."

nohup python -m app.collector.runner > logs/collector.log 2>&1 &
nohup python -m app.bot.main > logs/bot.log 2>&1 &

echo "✅ 完成"
