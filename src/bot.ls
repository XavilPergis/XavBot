fs = require 'fs'
EventEmitter = require \events
toml = require \toml
Discord = require 'discord.js'

{color} = require './color'
util = require './util'

class XavBot

  (@config-path) ->
    @client = new Discord.Client
    @listeners = {}
    @commands = {}
    @config-cache = void

    @client.on 'ready', (msg) -> util.log <[ green bold ]>, 'Bot is online!'
    @client.on 'message', (msg) ~> @dispatch msg

    util.ALL_EVENTS.for-each (name) ~>
      @listeners[name] = []
      @client.on name, (...args) ~>
        @listeners[name].for-each (fn) ~> fn? this, ...args

  add-command: (cmd) ~>
    # Init command if needed
    cmd.init? this
    @commands[cmd.name] = cmd

  dispatch: (msg) ~>
    [cmd, args] = msg.content.split ' ' |> remove-at 0

    cfg = @config!

    for key, command of @commands
      if "#{cfg.general['command-prefix']}#{key}" == cmd
        user = color [\bold], msg.author.username
        content = color [\italic], msg.content

        is-sfw = (command.is-sfw args, msg) or (msg.channel.name in cfg.general['nsfw-channels'])
        is-permitted = (not command.is-priveleged!) or (msg.author.id == cfg.general['ring-0'])

        util.log <[ green bold ]>, "User #{user} tried executing #{command.name} | #{content}"
        if is-sfw and is-permitted
          try
            command.run this, args, msg
          catch err
            util.error err

  attach-listener: (listen-for, listener) ~~>
    @listeners[listen-for].push listener

  load-config: ~> toml.parse fs.read-file-sync @config-path
  config: ~>
    # What the hell happened to memoize!?
    if not @config-cache => @config-cache = @load-config!
    @config-cache

  run-bot: ~>
    for filename in fs.readdir-sync @config!.general['command-path']
      req-path = "./cmd/#{filename}".replace /\.js$/, ''
      cmd = require req-path

      @add-command cmd
      util.info "Loaded #{color <[ yellow bold ]>, "'#{req-path}'"}"

    # Log in and run the bot!
    @client.login(@config!.general['token']).catch (err) ->
      util.error "Can't log into Discord Gateway! | #{err}"

module.exports = XavBot
