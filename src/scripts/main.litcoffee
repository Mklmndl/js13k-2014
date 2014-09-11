Since the game is largely based on the tiles appearing randomly, we're going to
need a few basic functions to help with that.

    random = (min, max) ->
      Math.floor(min + Math.random() * (max - min + 1))

    pick = (choices) ->
      choices[random(0, choices.length - 1)]

Being able to merge objects can also be useful.

    merge = (obj, sources...) ->
      obj[key] = value for own key, value of src for src in sources
      obj

Two helpers to get the column (x) and the row (y) of a tile with its index...

    getColumn = (index, columns) ->
      index % columns

    getRow = (index, columns) ->
      Math.floor(index / columns)

... and their inverse.

    getIndex = (x, y, columns) ->
      y * columns + x

The functions checking for matches will look for matches within the current
column **or** row.
The alogrithm to check for a match is as follow: we count matches until there
aren't anymore or we've encountered the end (or beginning) of the line, and we
do this backwards and forwards the given tile. It will return `true` if we have
three or more same tiles.

    horizontalMatch = (board, index, columns) ->
      sum = 0
      length = board.length
      x = getColumn(index, columns)
      y = getRow(index, columns)

      start = x - 1
      if 0 <= start < columns then for i in [start..0]
        break unless board[y * columns + i] == board[index]
        sum += 1

      start = x + 1
      if 0 <= start < columns then for i in [start...columns]
        break unless y * columns + start < length
        break unless board[y * columns + i] == board[index]
        sum += 1
      sum >= 2

    verticalMatch = (board, index, columns, rows) ->
      sum = 0
      length = board.length
      x = getColumn(index, columns)
      y = getRow(index, columns)

      start = y - 1
      if 0 <= y < rows then for i in [start..0]
        break unless board[i * columns + x] == board[index]
        sum += 1

      start = y + 1
      if 0 <= y < rows then for i in [start...rows]
        break unless start * columns + x < length
        break unless board[i * columns + x] == board[index]
        sum += 1
      sum >= 2

    match = (board, index, columns, rows) ->
      horizontal = horizontalMatch(board, index, columns)
      vertical = verticalMatch(board, index, columns, rows)
      horizontal or vertical

It would also be useful to check if a tile is adjacent to another, for example
to make sure that we aren't trying to switch a tile from the first row and one
from the last.
Also, the tricky part here is that we don't want diagonal matches.

    areAdjacents = (tile1, tile2, columns) ->
      x1 = getColumn(tile1, columns)
      y1 = getRow(tile1, columns)
      x2 = getColumn(tile2, columns)
      y2 = getRow(tile2, columns)

      return false unless x1 in [x2 - 1..x2 + 1]
      return false unless y1 in [y2 - 1..y2 + 1]
      return false if x1 != x2 and y1 != y2
      true

Drawing the board is as simple as iterating through all the tiles contained in
the board array. We just need to take care of drawing it **where** we want to
(offsets) and **how** (tile size) we want to.

    drawBoard = (board, columns, ctx, textures, options) ->
      for i in [0...board.length]
        drawTile(ctx, i, columns, textures[board[i]] ? '#000', options)

    drawTile = (ctx, index, columns, color, options) ->
      {
        borderColor
        borderSize
        offsetX
        offsetY
        tileWidth
        tileHeight
      } = options

      ctx.fillStyle = color
      ctx.fillRect(
        offsetX + getColumn(index, columns) * tileWidth
        offsetY + getRow(index, columns) * tileHeight
        tileWidth, tileHeight
      )
      ctx.lineWidth = borderSize
      ctx.strokeStyle = borderColor
      ctx.strokeRect(
        offsetX + getColumn(index, columns) * tileWidth
        offsetY + getRow(index, columns) * tileHeight
        tileWidth, tileHeight
      )

    drawSelectedTile = (ctx, columns, tile, options) ->
      drawTile(ctx, tile, columns, 'rgba(0,0,0,0.5)', options) if tile?

The constants of the game speak mainly for themselves.
We start by defining the size of the game screen and the targeted FPS.

    RATIO = 2
    WIDTH = 320 * RATIO
    HEIGHT = 480 * RATIO
    FPS = 60

The next ones or more specific to the game. First, the size of the board in
columns and rows, and then the size of the tiles. The offset values are for
positionning the board on the screen.

    ROWS = 10
    COLUMNS = 8
    TILE_WIDTH = 32 * RATIO
    TILE_HEIGHT = 32 * RATIO
    BOARD_OFFSET_X = TILE_WIDTH
    BOARD_OFFSET_Y = TILE_HEIGHT * 4

Now we define the available types of tiles and their representation (here, as
colors).

    TILES = [AIR, EARTH, FIRE, WATER] = [0...4]
    TEXTURES = ['#ddd', '#855', '#f55', '#69f']

The game is displayed on a `Canvas Element` of the width and height specified by
the constants defined earlier. We also need to attach it to the document to make
it visible.

    canvas = document.createElement('canvas')
    canvas.width = WIDTH
    canvas.height = HEIGHT

    ctx = canvas.getContext('2d')
    canvasRect = null

    document.body.appendChild(canvas)

Generating the board, we also store how we want to render the board (offsets and
tile size) instead of feeding it each time to the `drawBoard` function as an
object literal.

The board is going to be represented as a one-dimensional array of tiles. The
generation takes care of not putting tiles that match together; it's left to the
player to do that!

    generateBoard = (columns, rows, tiles) ->
      size = columns * rows
      board = []
      for i in [0...size]
        loop
          board[i] = pick(tiles)
          break unless match(board, i, columns, rows)
      board

Switching tiles always involves two tiles.

    tile1 = null
    tile2 = null

    switchTiles = (board, first, second) ->
      [board[first], board[second]] = [board[second], board[first]]

We watch for click events on the canvas to switch tiles. We have be careful not
to switch tiles that shouldn't, so we need to check a few things:
- is the click even on a tile?
- do we have two tiles?
- are the two tiles adjacents?
- do they even match?

    canvas.addEventListener('click', (e) ->
      canvasRect ?= canvas.getBoundingClientRect()
      clickX = e.clientX - canvasRect.left
      clickY = e.clientY - canvasRect.top

      x = Math.floor((clickX - BOARD_OFFSET_X) / TILE_WIDTH)
      y = Math.floor((clickY - BOARD_OFFSET_Y) / TILE_HEIGHT)

      return unless 0 <= x < COLUMNS
      return unless 0 <= y < ROWS
      index = getIndex(x, y, COLUMNS)

      if tile1 is null then tile1 = index
      else tile2 = index

      return unless tile1? and tile2?
      if areAdjacents(tile1, tile2, COLUMNS)
        switchTiles(board, tile1, tile2)
        first = match(board, tile1, COLUMNS, ROWS)
        second = match(board, tile2, COLUMNS, ROWS)

        # We switch back if there are no matches
        switchTiles(board, tile1, tile2) unless first or second
      tile1 = tile2 = null
    )

Tiles that were matched are erased from the board, so we need new tiles to take
their place and that's what this function is about. The check for 'matched'
tiles is from bottom to top, and we make the tiles from the top come down, like
a waterfall would.

    bringDown = (board, columns, rows, tiles) ->
      for i in [board.length - 1..0]
        continue unless board[i] is null

        x = getColumn(i, columns)
        y = getRow(i, columns)
        next = (y - 1) * columns + x
        if 0 <= next < board.length
          switchTiles(board, i, next)
      for i in [0...board.length]
        if board[i] is null
          board[i] = pick(tiles)

Let's generate the board and store a few values for the rendering.

    board = generateBoard(COLUMNS, ROWS, TILES)
    renderOptions =
      borderColor: '#fff'
      borderSize: 3
      offsetX: BOARD_OFFSET_X
      offsetY: BOARD_OFFSET_Y
      tileWidth: TILE_WIDTH
      tileHeight: TILE_HEIGHT

    update = (dt) ->
      matches = []
      for i in [0...board.length]
        matches.push i if match(board, i, COLUMNS, ROWS)
      board[i] = null for i in matches

      bringDown(board, COLUMNS, ROWS, TILES)

    render = ->
      drawBoard(board, COLUMNS, ctx, TEXTURES, renderOptions)
      drawSelectedTile(ctx, COLUMNS, tile1, renderOptions)

The main loop of the game.

    step = 1 / FPS
    modifier = 1
    mStep = step * modifier
    dt = 0
    previousTime = new Date()

    requestAnimationFrame tick = ->
      currentTime = new Date()
      dt += Math.min(1, (currentTime - previousTime) / 1000)
      previousTime = currentTime

      while dt > mStep
        update(step)
        dt -= mStep
      render()

      requestAnimationFrame tick
