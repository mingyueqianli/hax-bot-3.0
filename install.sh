#!/bin/bash
set -e

APP=/opt/hax-bot

apt update -y
apt install -y python3 python3-pip python3-venv git

rm -rf $APP
mkdir -p $APP
cp -r . $APP
cd $APP

python3 -m venv venv
source venv/bin/activate

pip install -r requirements.txt

mkdir -p data logs

echo "TOKEN:"
read TOKEN
echo $TOKEN > token.txt

echo "INTERVAL:"
read INTERVAL
INTERVAL=${INTERVAL:-30}
echo $INTERVAL > interval.txt

nohup python -m app.collector.runner > logs/collector.log 2>&1 &
nohup python -m app.bot.main > logs/bot.log 2>&1 &
