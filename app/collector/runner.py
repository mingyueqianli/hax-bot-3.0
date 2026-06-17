import time
from app.collector.hax import fetch

def run():
    while True:
        data = fetch()
        with open('data/test.txt','w',encoding='utf-8') as f:
            f.writelines(data)
        time.sleep(30)

if __name__ == '__main__':
    run()
