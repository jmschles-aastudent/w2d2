require './pieces.rb'
require './paths.rb'

class Board
  include Paths

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
    @board.each do |row|
      row.each do |col|
        print "#{col} "
      end
      print "\n"
    end
  end

  def on_board?(end_square)
    end_square.all? {|coord| coord.between?(0, 7)} ? true : false
  end

  def square_occupied?(square, color)
    # pieces = color == "black" ? @black_pieces : @white_pieces
    @black_pieces.each do |piece|
      if piece.pos == square
        return :friendly if color == "black"
        return :enemy if color == "white"
      end
    end
    @white_pieces.each do |piece|
      if piece.pos == square
        return :friendly if color == "white"
        return :enemy if color == "black"
      end
    end
    :unoccupied
  end

  def legal_move?(piece, start_square, end_square, color)
    piece.possible_moves(start_square).include?(end_square)
  end

  def check_move(start_square, end_square, color)
    pieces = color == "black" ? @black_pieces : @white_pieces
    piece = pieces.select do |x|
      x.pos == start_square
    end.last

    return false unless legal_move?(piece, start_square, end_square, color)
    return false unless on_board?(end_square)
    return false if square_occupied?(end_square, color) == :friendly

    path = create_path(start_square, end_square)
    if path.count > 1
      path.each do |square|
        return false if square_occupied?(color) == :friendly
        return false unless legal_move?(piece, end_square, color)
      end
    end
    true
  end
end

board = Board.new
board.update_board
p board.check_move([6,0], [4, 1], "black")
board.print_board