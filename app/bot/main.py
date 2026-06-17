from telegram import Update
from telegram.ext import Application, CommandHandler, MessageHandler, ContextTypes, filters

COMMAND_MAP = {
    "1": "start",
    "2": "info",
    "3": "new",
    "4": "rename",
    "5": "delmachine",
    "6": "monitor",
    "7": "setinterval",
    "8": "stats",
    "9": "cancel"
}

WELCOME = """HAX BOT 6.4 企业版

机器管理:
/new
/info
/rename
/delmachine

监控:
/monitor
/alert

系统:
/status
/stats
/version
/help

控制:
/setinterval
"""

async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text(WELCOME)

async def help_cmd(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text(WELCOME)

async def router(update: Update, context: ContextTypes.DEFAULT_TYPE):
    text = update.message.text.strip()
    if text in COMMAND_MAP:
        await update.message.reply_text("/" + COMMAND_MAP[text])

async def setinterval(update: Update, context: ContextTypes.DEFAULT_TYPE):
    try:
        sec = int(context.args[0])
        if sec < 5:
            await update.message.reply_text("min 5 sec")
            return
        with open("interval.txt","w") as f:
            f.write(str(sec))
        await update.message.reply_text(f"interval set: {sec}s")
    except:
        await update.message.reply_text("usage: /setinterval 30")

def main():
    token = open("token.txt").read().strip()
    app = Application.builder().token(token).build()

    app.add_handler(CommandHandler("start", start))
    app.add_handler(CommandHandler("help", help_cmd))
    app.add_handler(CommandHandler("setinterval", setinterval))
    app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, router))

    app.run_polling()

if __name__ == "__main__":
    main()
