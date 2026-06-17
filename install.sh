#!/bin/bash

set -e

APP=/opt/hax-bot-7.1

echo "🚀 HAX BOT 7.1 终极交互稳定版"

# =========================
# 1. 环境
# =========================
apt update -y
apt install -y python3 python3-pip python3-venv git curl

# =========================
# 2. 清理旧版本
# =========================
rm -rf $APP

# =========================
# 3. clone
# =========================
git clone https://github.com/mingyueqianli/hax-bot-6.6.git $APP

cd $APP

# =========================
# 4. python环境
# =========================
python3 -m venv venv
source venv/bin/activate

pip install -r requirements.txt

mkdir -p data logs

# =========================
# 🔥 关键修复（强制交互输入）
# =========================

# 防止 curl | bash 吞掉输入
exec < /dev/tty

echo "================================"
echo "请选择安装模式"
echo "1) 一键模式（默认）"
echo "2) 交互模式（输入TOKEN）"
echo "================================"

read -p "请输入选项(1/2): " MODE

if [ "$MODE" = "2" ]; then

    echo "===================="
    read -p "🔑 请输入 TOKEN: " TOKEN

    echo "===================="
    read -p "⏱ 请输入采集时间(秒): " INTERVAL

else
    echo "使用默认配置"
    TOKEN="test_token"
    INTERVAL=30
fi

# =========================
# 5. 写入配置
# =========================
echo $TOKEN > token.txt
echo $INTERVAL > interval.txt

# =========================
# 6. 启动系统
# =========================
echo "🚀 启动 BOT + COLLECTOR..."

nohup python -m app.collector.runner > logs/collector.log 2>&1 &
nohup python -m app.bot.main > logs/bot.log 2>&1 &

echo "================================"
echo "✅ HAX BOT 7.1 安装完成"
echo "🔑 TOKEN: $TOKEN"
echo "⏱ INTERVAL: $INTERVAL"
echo "================================"
