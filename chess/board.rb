require './pieces.rb'
require './paths.rb'

class Board
  include Paths

  attr_reader :board

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
        @board[row][col] = '_' unless pieces_coords.include?([row, col])
      end
    end

    nil
  end

  def print_board
    update_board
    @board.transpose.each do |row|
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

  def locate_piece_by_square(square, color)
    pieces = color == "black" ? @black_pieces : @white_pieces
    piece = pieces.select do |x|
      x.pos == square
    end.last
  end

  def pawn_capture_valid?(start, finish, color)
    dx = finish[0] - start[0]
    dy = finish[1] - start[1]
    return true if dx == 0
    if color == "black"
      return false unless [[-1, 1], [1, 1]].include?([dx, dy])
    else
      return false unless [[-1, -1], [1, -1]].include?([dx, dy])
    end

    return false unless square_occupied?(finish, color) == :enemy

    return true
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
      return false unless pawn_capture_valid?(start_square, end_square, color)
      dy = end_square[1] - start_square[1]
      return false if dy.abs > 2 || (dy.abs > 1 && piece.moved)
    else
      return false unless legal_move?(piece, start_square, end_square, color)
    end

    return false unless on_board?(end_square)
    return false if square_occupied?(end_square, color) == :friendly
    path = create_path(start_square, end_square)
    if path.count > 1
      path.each do |square|
        return false if square_occupied?(square, color) == :friendly
      end
    end

    true
  end

  def execute_move(start, finish, color)
    enemy_color = color == "white" ? "black" : "white"
    piece = locate_piece_by_square(start, color)

    if check?(enemy_color)
      puts "Invalid move, you'd be in check"
      return false
    end

    if square_occupied?(finish, color) == :enemy
      capture_piece(finish, color)
    end

    piece.pos = finish if valid_move?(start, finish, color)

    puts "Check!" if check?(color)
    piece.moved = true if piece.is_a?(Pawn)
  end

  def check?(color)
    friend_pieces = color == "black" ? @black_pieces : @white_pieces
    enemy_pieces = color == "white" ? @black_pieces : @white_pieces
    king = enemy_pieces.select {|x| x.is_a?(King)}.last
    puts "king position: #{king.pos}"
    puts "king is color: #{king.color}"

    friend_pieces.each do |piece|
      return true if valid_move?(piece.pos, king.pos, piece.color)
    end
    false
  end
end


