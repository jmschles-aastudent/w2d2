require "./board.rb"

class Game
  include Marshal
  attr_reader :board
  def initialize
    @board = Board.new
    @player1 = Player.new("white")
    @player2 = Player.new("black")
  end

  def parse_position(arr)
    row = arr.first.ord - 97
    col = 8 - arr.last.to_i
    [row, col]
  end

  def take_turn(player)
    @board.print_board
    move = player.get_move
    start, finish = parse_position(move[0]), parse_position(move[1])

    if @board.valid_move?(start, finish, player.color)

      future_board = Marshal::load(Marshal.dump(@board))

      future_board.execute_move(start, finish, player.color)
      puts "This is FUTURE BOARD!"
      future_board.print_board
      other_color = player.color == "white" ? "black" : "white"
      if future_board.check?(player.color)
        puts "future board is in check"
        take_turn(player)
      end
    else
      take_turn(player)
    end
    puts "executing!"
    @board.execute_move(start, finish, player.color)
  end

  def run
    while true
      take_turn(@player1)
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
    gets.chomp.split("")
  end

  def get_target_pos
    puts "Enter the target location: "
    gets.chomp.split("")
  end

end

game = Game.new
p game.run




