class Command
  (@name, @run-fn) ->

  addAlias: (alias) ~>
    @aliases.push ...(if Array.is-array alias then alias else [alias])

  run: (bot, args, msg) ~~> @run-fn bot: bot, args: args, msg: msg

  is-sfw: -> true
  is-priveleged: -> false

module.exports = Command
