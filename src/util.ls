color = require('./color').color

log = (col, text) -->
  console.log "#{color col, timestamp!} #{text}"

error = log <[ red bold ]>
info  = log <[ blue bold ]>
debug = log <[ magenta bold ]>
warn  = log <[ yellow bold ]>

lpad = (amt, char, msg) -->
  return (char.repeat(amt - msg.toString().length) + msg if msg.toString().length < amt) or msg

timestamp = ->
  date = new Date!

  pad-zero = lpad 2, '0'

  hrs  = pad-zero date.get-hours!
  mins = pad-zero date.get-minutes!
  secs = pad-zero date.get-seconds!

  "[#{hrs}:#{mins}:#{secs}]"

module.exports =
  error: error
  log: log
  info: info
  warn: warn
  debug: debug
  lpad: lpad
  timestamp: timestamp

  ALL_EVENTS: <[
    channelCreate channelDelete channelPinsUpdate channelUpdate debug disconnect
    error guildBanAdd guildBanRemove guildCreate guildDelete guildEmojiCreate
    guildEmojiDelete guildEmojiUpdate guildMemberAdd guildMemberAvailable
    guildMemberRemove guildMembersChunk guildMemberSpeaking guildMemberUpdate
    guildUnavailable guildUpdate message messageDelete messageDeleteBulk
    messageUpdate presenceUpdate ready reconnecting roleCreate roleDelete
    roleUpdate typingStart typingStop userUpdate voiceStateUpdate warn
  ]>

  DEFAULT_EVENTS: <[
    message error ready
  ]>
