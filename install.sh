#!/bin/bash

set -e

APP=/opt/hax-bot-3.0

echo "🚀 Installing HAX BOT 3.0..."

apt update
apt install -y python3 python3-pip python3-venv git

rm -rf $APP
git clone https://github.com/mingyueqianli/hax-bot-3.0.git $APP

cd $APP

python3 -m venv venv
source venv/bin/activate

pip install -r requirements.txt

mkdir -p data logs

echo "📌 Starting services..."

nohup python -m app.collector.runner > logs/collector.log 2>&1 &
nohup python -m app.bot.main > logs/bot.log 2>&1 &

echo "✅ HAX BOT 3.0 INSTALL COMPLETE"
