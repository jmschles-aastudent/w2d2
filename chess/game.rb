require "./board.rb"

class Game
  attr_reader :board
  def initialize
    @board = Board.new
    @player1 = Player.new("white")
    @player2 = Player.new("black")
  end

  # def parse_position(arr)
  #   row = arr.first.ord - 97
  #   col = arr.last.to_i - 1
  #   [row, col]
  # end

  def take_turn(player)
    move = player.get_move
    start, finish = move[0], move[1]
    p start
    p finish
    # move = player.get_move
    # start, finish = parse_position(move[0]), parse_position(move[1])
    @board.execute_move(start, finish, player.color)
  end

  def run
    while true
      @board.print_board
      take_turn(@player1)
      @board.print_board
      take_turn(@player2)
    end
  end

end



class Player
  attr_reader :color

  def initialize(color)
    puts "enter your name"
    @name = gets.chomp
    @color = color
  end

  def get_move
    start = get_start_pos
    target = get_target_pos
    [start, target]
  end

  def get_start_pos
    puts "Enter the coordinates of the piece to move: "
    gets.chomp.split("").map(&:to_i)
  end

  def get_target_pos
    puts "Enter the target location: "
    gets.chomp.split("").map(&:to_i)
  end

end

game = Game.new
p game.run




