https = require 'https'
stream = require 'stream'
util = require '../util'
Command = require '../command'

class Track
  constructor: (@info, @stream) ->

class AudioPlayerManager

  constructor: ->
    @settings =
      volume: 0.34

    @queue = []
    @playing = undefined
    @voiceConnection = undefined
    @playState = 'NOT_PLAYING'

  joinVoice: (channel, cb) =>
    if not @voiceConnection?
      channel.join().then (connection) =>
        @voiceConnection = connection
        cb()
    else
      cb()

  addToQueue: (track) =>
    @queue.push track

  popQueue: =>
    @queue.shift()

  playNext: (channel) =>
    track = @popQueue()

    if track?
      @playing = {}

      @playing.info = track.info
      @playing.dispatcher = @voiceConnection.playStream track.stream, @settings
      @playing.dispatcher.once 'end', =>
        util.debug 'Dispatcher emitted "End" event'
        @playNext channel

      channel.sendMessage "Now playing: **#{track.info.title}**"
    else
      @playing = undefined

  isPlaying: => @playing?

player = new AudioPlayerManager()

concatReadableBuffer = (buffer, cb) ->
  accum = Buffer.from([]);

  buffer.on 'data', (block) -> accum = Buffer.concat [ accum, block ]
  buffer.on 'end', -> cb accum

getConcat = (url, cb) ->
  https.get url, (buffer) ->
    concatReadableBuffer buffer, (res) -> cb res.toString()

getJson = (url, cb) ->
  getConcat url, (res) -> cb JSON.parse res

cmd = new Command 'sc', (bot, args, msg) ->

  cmd = args[0]
  rest = args[1..]

  switch cmd
    when "search"
      if msg.member.voiceChannel?
        cid = bot.getConfig().soundcloud['client-id']

        msg.channel.startTyping()
        trackInfoUrl = "https://api.soundcloud.com/tracks?client_id=#{cid}&q=#{encodeURIComponent rest.join ' '}"
        util.debug "Fetching track data from '#{trackInfoUrl}'"

        getJson trackInfoUrl, (tracks) ->
          track = tracks[0]

          msg.channel.stopTyping() if tracks.length == 0

          if track?
            util.debug "Attempting to play stream: #{track.stream_url}?client_id=#{cid}"

            # Geat song, add it to the queue, and play it if no other song is already being played
            getJson "#{track.stream_url}?client_id=#{cid}", (loc) ->
              https.get loc.location, (audio) ->
                audioStream = new stream.PassThrough()

                # This is a weird construct...
                # TODO: Why does this work?
                concatReadableBuffer audio, (buf) ->
                  audioStream.end new Buffer buf
                  player.joinVoice msg.member.voiceChannel, ->
                    player.addToQueue new Track track, audioStream

                    msg.channel.sendMessage "Added **#{track.title}** to the queue | \\♥ #{track.likes_count or 0} | ↺ #{track.reposts_count or 0}"
                    msg.channel.stopTyping()

                    if not player.isPlaying() then player.playNext msg.channel
      else
        msg.reply 'You must be in a voice channel to use this command!'

    when "queue"
      if player.isPlaying()
        fm = 'Current Queue:\n'

        fm += "    **Playing:** #{player.playing.info.title}\n\n"

        player.queue.forEach (e, i) ->
          fm += "    **#{i + 1}.** #{e.info.title}\n"

        msg.channel.sendMessage fm
      else
        msg.channel.sendMessage 'Nothing is being played!'

    when "volume"
      vol = parseFloat rest[0]

      player.settings.volume = vol
      player.playing.dispatcher.setVolume vol

    when "skip"
      player.playing.dispatcher.end()

module.exports = cmd
