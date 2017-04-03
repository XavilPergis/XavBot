ESCAPE = '\x1b['

color-dict =
  bold:          <[ 1m 22m ]>
  italic:        <[ 3m 23m ]>
  underline:     <[ 4m 24m ]>
  inverse:       <[ 7m 27m ]>
  strikethrough: <[ 9m 29m ]>

  black:         <[ 30m 39m ]>
  red:           <[ 31m 39m ]>
  green:         <[ 32m 39m ]>
  yellow:        <[ 33m 39m ]>
  blue:          <[ 34m 39m ]>
  magenta:       <[ 35m 39m ]>
  cyan:          <[ 36m 39m ]>
  white:         <[ 37m 39m ]>

color = (names, str) -->
  map (color-dict.), names
    |> map (map (ESCAPE +))
    |> fold ((a, b) -> b[0] + a + b[1]), str

module.exports =
  color-dict: color-dict
  color: color
