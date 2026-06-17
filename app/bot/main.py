from telegram import Update
from telegram.ext import Application, CommandHandler, ContextTypes

def read():
    try:
        return open('data/test.txt','r',encoding='utf-8').read()
    except:
        return 'no data'

async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text('HAX BOT 6.0 STARTED')

async def stats(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text(read())

def main():
    token = open('token.txt').read().strip()
    app = Application.builder().token(token).build()
    app.add_handler(CommandHandler('start', start))
    app.add_handler(CommandHandler('stats', stats))
    app.run_polling()

if __name__ == '__main__':
    main()
