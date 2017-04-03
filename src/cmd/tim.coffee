Command = require '../command'

module.exports = new Command 'tim', (bot, args, msg) ->
  timMsgs = bot.getConfig().general['tim-messages']

  idx = Math.floor Math.random() * timMsgs.length
  msg.channel.sendMessage "**Shower Tim:** #{timMsgs[idx]}"
