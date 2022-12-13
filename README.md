Fred's Bowl-O-Rama
==================
Hi there! This is a simple (unfinished) Rails project, a score-keeping app for
a bowling alley, Fred's Bowl-O-Rama. When you've finished, this app must accept
POST requests to `/scores`, containing JSON-formatted bowling frames (each
player fills a frame each turn), and respond with a scoreboard containing each
player's name, their score, and the name of the winner of the game.

Some things to keep in mind for the coding challenge:

  * Feel free to write any tests for your code you find necessary. The RSpec
    tests provided are provided for your reference.
  * We provide a couple of tests in `spec/`; read them to get an idea of what
    inputs your endpoint should accept.
  * Make sure to handle not only happy paths but also invalid requests,
    requests with improperly formatted data, etc. Your service should return a
    400 status for any malformed input, a 422 response for any input that is
    well-formed but cannot be processed (i.e. if someone scores 31 in a single
    frame).
  * Use the same route and controller endpoint and API specified here, so that
    the test suite will still pass.
  * Comment your code more liberally than you normally would, so we can learn
    more about your thought process and decisions you made writing the code.
  * We say this should take 1-2 hours because we don't want to take up more of
    your time than that, but feel free to spend as much time on it as you need.
  * If you need to, add additional libraries to the Gemfile or more files to
    the project. All dependencies must install with `bundle install` and all
    tests must run with `rake spec`.
  * Remember that the tests provided here aren't the only tests that might get
    run against your code.

## Scoring rules

For each frame of the game, each player takes a turn bowling. If they knock
over 10 pins on their first throw of the frame (a strike), their score for
that frame includes those 10 points and additionally any points scored on
the next two throws--whether or not those occur within the same frame.

If their two throws in a single frame knock over all the pins (a spare), their
score for that frame includes the 10 points from those two throws, and
additionally any points scored on the next throw--again, whether or not that
throw occurs within the same frame.

If the player fails to knock down all ten pins with two throws, only the total
number of pins they knocked down that frame are recorded. Note that if a player
gets a strike on the first throw of a frame, that is the only throw allowed for
that frame, except if it's the last frame.

To score the last frame, as many as three throws are recorded depending on what
happens. If, in the last frame, the player throws a strike the first throw,
they can bowl two more times for that frame, so that there are two throws
scored after the strike. In this way, the last frame can be as many as 30 points.

See these links for more information on bowling scoring:

  * [Wikipedia](https://en.wikipedia.org/wiki/Ten-pin_bowling#Traditional_scoring)
  * [Bowling Genius](https://www.bowlinggenius.com/), an interactive scorecard you can use

## Input format

The JSON format for scoring requests can include any number of players and up
to ten frames per player. Each frame is an array of integers representing the
numbers of pins knocked down for each throw. According to the rules of 10-pin
bowling, a frame can contain 1, 2, or 3 throws. Here is an example payload:

```json
{
  "Ralf Hütter": [
    [1, 3],
    [10]
  ],
  "Florian Schneider": [
    [7, 3],
    [0, 0]
  ]
}
```

In this partial game of only two frames so far, Ralf took a turn and bowled 1
and 3 pins over, then Florian took a turn and bowled 7 and 3 pins over (a
spare), then Ralf bowled a strike, then finally Florian threw his ball
immediately into the gutter twice.

For a scoring request to be valid, in addition to following the format above,
the following conditions must also be true:

  * All players must have bowled the same number of frames
  * No player may bowl too many throws (i.e., more than 2, more than 3 on the
    final frame, bowling a strike then throwing again)
  * Except in the final (10th) frame, no player may knock over more than 10
    pins in a single frame (though a player may score more points than 10 in a
    frame, if they bowl a strike or spare).

## Output format

The response body should also be JSON-encoded, as an object with two keys:
`scores`, and `winner`. `scores` should be an object with player names as
keys and their _total_ score from all frames as values; `winner` should just be
a string, the winning player's name.

```json
{
  "scores": {
    "Hannibal Smith": 300,
    "B. A. Baracus": 276,
    "Templeton Peck": 190,
    "H. M. Murdock": 110
  },
  "winner": "Hannibal Smith"
}
```

If there are two or more winning players with the same score, `winner` should be
concatenated:

```json
{
  "scores": {
    "Reed Richards": 276,
    "Susan Storm": 276,
    "Johnny Storm": 190,
    "Ben Grimm": 110
  },
  "winner": "Reed Richards & Susan Storm"
}
```

_Note: the players do not have to be listed in any particular order._
