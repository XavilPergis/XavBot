request = require \request
{exec} = require \child_process
util = require '../util'
Command = require '../command'

# Give this one a context param because we want to be able to access the bot
# when we eval code
exec-js = (ctx, code) ->
  wrappedCode = "(function(){#code})();"
  util.info "Evaluating:\n #wrappedCode"
  try
    # Some util functions for eval
    log = (...e) -> msg.channel.send-message e.join ' '
    {inspect} = require 'util'

    return "```js\n#{eval wrappedCode}```"
  catch error
    return "```Error: #{error}```"

exec-bash = (code) ->
  child = exec "bash -c '#{code.replace(/'/g, "\\'")}'", (err, stdout, stderr) ->
    msg.channel.sendMessage "```#{stdout}```"

  timer-handle = (flip set-timeout) 3000, ->
    child.kill!
    msg.channel.send-message 'Command took too long to execute!'

  child.on 'exit', (code) ->
    clear-interval timer-handle

module.exports = new Command 'eval', (ctx) ->
  matches = (//```([^\n`]*)\n([^`]*)```//.exec args.join ' ')

  [_, lang, code] = matches

  switch
    | lang in <[ js javascript ]> => exec-js ctx, code
    | lang in <[ bash sh ]>       => exec-bash code
