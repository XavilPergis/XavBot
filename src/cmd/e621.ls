request = require \request
util = require '../util'
Command = require '../command'

class Api

  (@default-order, @default-headers) ->

  fetch: (tags, sfw, cb) ->
    tags.push 'rating:safe' if sfw
    console.log tags
    opts =
      url: "https://e621.net/post/index.json?tags=order:#{@default-order}+#{tags.join '+'}"
      headers: @default-headers

    request opts, (err, body) ->
      if err?
        util.error 'Error while fetching post info'
      else
        cb JSON.parse body.body

api = new Api 'random', { 'User-Agent': "Xavil-YiffBot/#{process.version}" }

cmd = new Command 'e621', (ctx) ->

  ctx.msg.channel.start-typing 1
  res <- api.fetch (tail ctx.args), (head ctx.args) == \safe

  # Number of tags to display with post info
  const num-tags = 7
  const amt = 1

  # How many posts are actually going to be shown
  post-number = Math.min res.length, (amt - 1)


  posts = res.slice post-number
  final-message = ""

  for post in posts
    # Format the tags nicely
    tags = post.tags.split ' ' |> slice 0, num-tags |> join ', '

    file-type = switch last post.file_url.split('.') |> (.to-lower-case!)
      | <[ swf ]>              => 'Flash'
      | <[ png gif jpg jpeg ]> => 'Image'
      | <[ webm gifv mp4 ]>    => 'Video'
      | _                      => 'Unknown'

    artist-string = if post.artist.length == 0 then 'Unknown' else post.artist.join ', '

    final-message += """─── **[  #{fileType}  ]** ───────────────────────────────────────
    ↑ #{post.score} | \\♥ #{post.fav_count}
    **Artist:** #{artist-string}
    **Page:** <https://e621.net/post/show/#{post.id}>
    **Tags:** `#{tags}`
    **Post:** #{post.file_url}\n
    """

  ctx.msg.channel.send-message final-message
  ctx.msg.channel.stop-typing!

cmd.is-sfw = (args, msg) -> (head args) == \safe

module.exports = cmd
