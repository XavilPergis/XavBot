Command = require '../command'

module.exports = new Command 'shutdown', (bot, args, msg) ->
  msg.channel.sendMessage('Bye bye!').then -> bot.client.destroy().then -> process.exit(0)
