{keys, each} = require \prelude-ls

# Import all the functions from the passed object into Node's `global` object
const load-exports = (P) ->
  keys P |> each (-> global[it] = P[it])

load-exports require \prelude-ls
load-exports require './prelude-ext'

const EventEmitter = require \events
const XavBot = require './bot'
const util = require './util'
{color} = require './color'

bot = new XavBot './config.toml'

# Logger
bot.attach-listener 'message', (bot, msg) ->
  botIndicator = color [\yellow], if msg.author.id == bot.client.user.id then '[$]' else '[ ]'

  guild   = color [\blue], msg.guild.name
  channel = color [\green], '#' + msg.channel.name
  author  = color [\bold], msg.author.username

  util.info "#{botIndicator} #{guild} -> #{channel} #{author} #{msg.content}"

# owo what's this?
bot.attach-listener 'message', (bot, msg) ->
  if msg.content.to-lower-case! `contains` \owo
    msg.channel.send-message '*What\'s this?*'

bot.run-bot!
