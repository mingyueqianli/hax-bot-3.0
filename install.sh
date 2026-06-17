#!/bin/bash
APP=/opt/hax-bot-6.0

apt update -y
apt install -y python3 python3-pip python3-venv git

rm -rf $APP
git clone https://github.com/your/hax-bot-6.0.git $APP

cd $APP
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

mkdir -p data logs

echo 'READY'
