# require 'board.rb'

class Piece
  attr_accessor :pos
  attr_reader :sign, :color

  def initialize(pos, color)
    @pos, @color, = pos, color
    @sign = nil
    @deltas = deltas
  end

  def deltas
    []
  end

  def possible_moves(start_pos)
    x = start_pos[0]
    y = start_pos[1]

    @deltas.map {|delta| [x + delta[0], y + delta[1]]}
  end

end

class Pawn < Piece
  attr_accessor :moved
  def initialize(pos, color)
    super(pos, color)
    @moved = false
    @sign = 'P'
    p pos
  end

  def deltas
    deltas = [[0, 1]]
    deltas << [0, 2] unless @moved
  end

  def possible_moves(start_pos, color)
    moves = []
    if color == "black"
      moves << super(start_pos)
    else
      x = start_pos[0]
      y = start_pos[1]

      moves << @deltas.map { |delta| [x - delta[0], y - delta[1]] }
    end


  end

  alias_method :moved?, :moved
end

class Rook < Piece
  def initialize(pos, color)
    super(pos, color)
    @sign = 'R'
  end

  def deltas
    deltas = []
    8.times do |i|
      next if i == 0
      deltas << [0, i]
      deltas << [i, 0]
      deltas << [0, -i]
      deltas << [-i, 0]
    end
    deltas
  end
end

class Bishop < Piece
  def initialize(pos, color)
    super(pos, color)
    @sign = 'B'
  end

  def deltas
    deltas = []
    8.times do |i|
      next if i == 0
      deltas << [i, i]
      deltas << [i, -i]
      deltas << [-i, i]
      deltas << [-i, -i]
    end
    deltas
  end
end

class Queen < Piece
  def initialize(pos, color)
    super(pos, color)
    @sign = 'Q'
  end

  def deltas
    deltas = []
    8.times do |i|
      next if i == 0
      deltas << [i, i]
      deltas << [i, -i]
      deltas << [-i, i]
      deltas << [-i, -i]
      deltas << [0, i]
      deltas << [i, 0]
      deltas << [0, -i]
      deltas << [-i, 0]
    end
    deltas
  end
end

class King < Piece
  def initialize(pos, color)
    super(pos, color)
    @sign = '$'
  end

  def deltas
    deltas = [[1, -1], [1, 0], [1, 1], [0, -1], [0, 1], [-1, -1], [-1, 0], [-1, 1]]
  end
end

class Knight < Piece

  def initialize(pos, color)
    super(pos, color)
    @sign = 'K'
  end

  def deltas
    deltas = [ [-2, -1],
              [-2,  1],
              [-1, -2],
              [-1,  2],
              [ 1, -2],
              [ 1,  2],
              [ 2, -1],
              [ 2,  1] ]
  end
end