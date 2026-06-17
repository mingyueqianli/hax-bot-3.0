#!/bin/bash

set -e

APP=/opt/hax-bot-7.5

echo "🚀 HAX BOT 7.5 终极闭环安装启动..."

# =========================
# 1. 环境
# =========================
apt update -y
apt install -y python3 python3-pip python3-venv git curl

# =========================
# 2. 清理旧进程（关键）
# =========================
pkill -f app.bot.main || true
pkill -f app.collector.runner || true

# =========================
# 3. 安装目录
# =========================
rm -rf $APP
git clone https://github.com/mingyueqianli/hax-bot-7.5.git $APP

cd $APP

echo "📂 当前目录: $(pwd)"

# =========================
# 4. Python环境
# =========================
python3 -m venv venv
source venv/bin/activate

pip install -r requirements.txt

mkdir -p data logs

# =========================
# 5. 🔥 关键：自动初始化（解决你所有问题）
# =========================

# TOKEN
if [ ! -f token.txt ]; then
    echo "⚠️ 未检测到token，进入输入模式"
    exec < /dev/tty
    read -p "🔑 请输入 TOKEN: " TOKEN
else
    TOKEN=$(cat token.txt)
fi

# INTERVAL
if [ ! -f interval.txt ]; then
    read -p "⏱ 请输入采集时间(默认30): " INTERVAL
    INTERVAL=${INTERVAL:-30}
else
    INTERVAL=$(cat interval.txt)
fi

# 写入配置
echo $TOKEN > token.txt
echo $INTERVAL > interval.txt

# =========================
# 6. 自动启动（闭环核心）
# =========================

echo "🚀 启动系统..."

nohup python -m app.collector.runner > logs/collector.log 2>&1 &
nohup python -m app.bot.main > logs/bot.log 2>&1 &

# =========================
# 7. 状态输出
# =========================

echo "================================"
echo "✅ HAX BOT 7.5 安装完成"
echo "🔑 TOKEN: 已配置"
echo "⏱ INTERVAL: $INTERVAL"
echo "📊 BOT + COLLECTOR 已运行"
echo "================================"
