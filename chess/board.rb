require 'pieces.rb'

class Board
  attr_reader :board

  def initialize
    generate_empty_board
    @black_pieces = generate_pieces("black")
    @white_pieces = generate_pieces("white")
  end

  def generate_empty_board
    @board = []
    8.times {@board << []}
    @board.each do |row|
      8.times {row << "_"}
    end
  end

  def generate_pieces(color)

    if color == "white"
      row1, row2 = 7, 6
    else
      row1, row2 = 0, 1
    end

    pieces = []
    8.times do |i|
      pawn = Pawn.new([i, row2], color)
      pieces << pawn
    end

    pieces << Rook.new([0, row1], color)
    pieces << Rook.new([7, row1], color)

    pieces << Knight.new([1, row1], color)
    pieces << Knight.new([6, row1], color)

    pieces << Bishop.new([2, row1], color)
    pieces << Bishop.new([5, row1], color)

    pieces << Queen.new([3, row1], color)
    pieces << King.new([4, row1], color)
  end

  def update_board
    pieces_coords = []

    @white_pieces.each do |piece|
      @board[piece.pos[0]][piece.pos[1]] = piece.sign
      pieces_coords << [piece.pos[0], piece.pos[1]]
    end

    @black_pieces.each do |piece|
      @board[piece.pos[0]][piece.pos[1]] = piece.sign
     pieces_coords << [piece.pos[0], piece.pos[1]]
    end

    @board.each do |row|
      row.each do |col|
        col = '_' unless pieces_coords.include?(col)
      end
    end

    nil
  end

  def print_board
    @board.each {|row| p row}
  end

  def on_board?
    end_square.all? {|coord| coord.between?(0, 7)} ? true : false
  end

  def square_occupied?(color)
    # pieces = color == "black" ? @black_pieces : @white_pieces
    @black_pieces.each do |piece|
      if piece.pos == end_square
        return :friendly if color == "black"
        return :enemy if color == "white"
      end
    end
    @white_pieces.each do |piece|
      if piece.pos == end_square
        return :friendly if color == "white"
        return :enemy if color == "black"
      end
    end
    :unoccupied
  end

  def legal_move?(piece, end_square, color)
    piece.possible_moves.include?(end_square)
  end

  def create_path(start, finish)
    if start[1] == finish[1]
      horizontal_path(start, finish)
    elsif start[0] == finish[0]
      vertical_path(start, finish)
    else
      diagonal_path(start, finish)
    end
  end

  def horizontal_path(start, finish)
    path = []
    total_dx = finish[0] - start[0]
    dx = total_dx / total_dx.abs
    total_dx.abs.times do |i|
      x_step = (i + 1) * dx
      path << [start[0] + x_step, start[1]]
    end
    path
  end

  def vertical_path(start, finish)
    path = []
    total_dy = finish[1] - start[1]
    dy = total_dy / total_dy.abs
    total_dy.abs.times do |i|
      y_step = (i + 1) * dy
      path << [start[0], start[1] + y_step]
    end
    path
  end

  def diagonal_path(start, finish)
    path = []
    dx = (finish[0] - start[0]) / (finish[0] - start[0]).abs
    dy = (finish[1] - start[1]) / (finish[1] - start[1]).abs
    (finish[0] - start[0]).abs.times do |i|
      path << [start[0] + (i + 1) * dx, start[1] + (i + 1) * dy]
    end
    path
  end










end

board = Board.new
board.update_board
p board.create_path([4,0], [0, 4])