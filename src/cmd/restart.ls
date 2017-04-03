Command = require '../command'

cmd = new Command 'restart', (ctx) ->
  ctx.msg.channel.send-message('Restarting...').then -> process.exit(127)

cmd.is-priveleged = -> true

module.exports = cmd
