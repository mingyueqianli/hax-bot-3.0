#!/bin/bash
set -e

APP=/opt/hax-bot

echo "🚀 HAX BOT 一键安装开始..."

# =========================
# 1. 环境依赖
# =========================
apt update -y
apt install -y python3 python3-pip python3-venv git curl

# =========================
# 2. 清理旧版本
# =========================
rm -rf $APP

# =========================
# 3. clone项目
# =========================
git clone https://github.com/YOUR_USERNAME/HAX-BOT.git $APP

cd $APP

# =========================
# 4. Python环境
# =========================
python3 -m venv venv
source venv/bin/activate

pip install -r requirements.txt

# =========================
# 5. 创建目录
# =========================
mkdir -p data logs

# =========================
# 6. 输入配置（关键）
# =========================
exec < /dev/tty

echo "===================="
read -p "🔑 请输入 TOKEN: " TOKEN
echo $TOKEN > token.txt

echo "===================="
read -p "⏱ 采集间隔(秒 默认30): " INTERVAL
INTERVAL=${INTERVAL:-30}
echo $INTERVAL > interval.txt

# =========================
# 7. 自动启动（闭环核心）
# =========================
echo "🚀 启动系统..."

nohup python -m app.bot.main > logs/bot.log 2>&1 &
nohup python -m app.collector.runner > logs/collector.log 2>&1 &

echo "================================"
echo "✅ 安装完成（已自动运行）"
echo "📦 路径: $APP"
echo "📊 BOT + COLLECTOR 已启动"
echo "================================"
