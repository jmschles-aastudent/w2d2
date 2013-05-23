require './pieces.rb'
require './paths.rb'
require 'colorize'

class Board
  include Paths
  include Marshal

  attr_reader :board, :black_pieces

  def initialize
    generate_empty_board
    @black_pieces = generate_pieces("black")
    @white_pieces = generate_pieces("white")
    update_board
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

    8.times do |row|
      8.times do |col|
        @board[row][col] = ' ' unless pieces_coords.include?([row, col])
      end
    end

    nil
  end

  def print_board
    update_board
    alternator = 0
    @board.transpose.each do |row|
      row.each do |col|
        if alternator % 2 == 0
          print ("#{col} ").colorize( :background => :red )
        else
          print ("#{col} ").colorize( :background => :blue )
        end
        alternator += 1
      end
      alternator += 1
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

  def locate_piece_by_square(square, color)
    pieces = color == "black" ? @black_pieces : @white_pieces
    piece = pieces.select do |x|
      x.pos == square
    end.last
  end

  def capture_piece(end_square, color)
    enemy_color = color == "black" ? "white" : "black"
    enemy_pieces = color == "black" ? @white_pieces : @black_pieces
    captured_piece = locate_piece_by_square(end_square, enemy_color)
    enemy_pieces.delete(captured_piece)
  end

  def valid_move?(start_square, end_square, color)
    piece = locate_piece_by_square(start_square, color)

    if piece.is_a?(Pawn)
      dx = end_square[0] - start_square[0]
      dy = end_square[1] - start_square[1]
      if [dx.abs, dy.abs] == [1, 1]
        return false unless square_occupied?(end_square, color) == :enemy
      end
      if (dx == 0 || dy == 0) && square_occupied?(end_square, color) == :enemy
        return false
      end
    end

    return false unless legal_move?(piece, start_square, end_square, color)
    return false unless on_board?(end_square)
    return false if square_occupied?(end_square, color) == :friendly
    path = create_path(start_square, end_square)
    if path.count > 1
      path.each_with_index do |square, i|
        return false if square_occupied?(square, color) == :friendly
        unless i == path.count - 1
          return false if square_occupied?(square, color) == :enemy
        end
      end
    end

    true
  end

  def execute_move(start, finish, color)
    enemy_color = color == "white" ? "black" : "white"
    piece = locate_piece_by_square(start, color)
    if square_occupied?(finish, color) == :enemy
      capture_piece(finish, color)
    end

    piece.pos = finish

    #puts "Check!" if check?(enemy_color)
    if piece.is_a?(Pawn)
      piece.deltas -= piece.color == "black" ? [[0, 2]] : [[0, -2]]
    end
    true
  end

  def check?(color)
    friend_pieces = color == "black" ? @black_pieces : @white_pieces
    enemy_pieces = color == "white" ? @black_pieces : @white_pieces
    king = friend_pieces.select {|x| x.is_a?(King)}.last


    enemy_pieces.each do |piece|
      if valid_move?(piece.pos, king.pos, piece.color)
        return true
      end
    end
    false
  end

  def mate?(color)
    pieces = color == "black" ? @black_pieces : @white_pieces
    pieces.each do |piece|

      piece.possible_moves(piece.pos).each do |move|
        next unless valid_move?(piece.pos, move, color)
        future_board = Marshal::load(Marshal.dump(self))
        future_board.execute_move(piece.pos, move, color)
        return false if !future_board.check?(color)
      end
    end
    true
  end


end

