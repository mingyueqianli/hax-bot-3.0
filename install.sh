cat > install.sh << 'EOF'
#!/bin/bash

set -e

APP=/opt/hax-bot-6.0

echo "🚀 Installing HAX BOT 6.0..."

apt update -y
apt install -y python3 python3-pip python3-venv git

# ❌ 不再clone（因为你已经有代码）

cd $APP

python3 -m venv venv
source venv/bin/activate

pip install -r requirements.txt

mkdir -p data logs

echo "======================="
read -p "请输入 Bot Token: " TOKEN
echo $TOKEN > token.txt

echo "======================="
read -p "采集间隔(秒): " INTERVAL
echo $INTERVAL > interval.txt

echo "🚀 启动系统..."

nohup python -m app.collector.runner > logs/collector.log 2>&1 &
nohup python -m app.bot.main > logs/bot.log 2>&1 &

echo "✅ HAX BOT 6.0 已启动"
EOF