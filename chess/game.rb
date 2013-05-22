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
    other_color = player.color == "black" ? "white" : "black"
    @board.print_board

    puts "Check!" if @board.check?(other_color)

    if @board.check?(player.color)
      puts "Check!"
      abort("check mate") if @board.mate?(player.color)
    end

    puts "#{player.name}'s turn"

    move = player.get_move
    start, finish = parse_position(move[0]), parse_position(move[1])

    if @board.valid_move?(start, finish, player.color)
      future_board = Marshal::load(Marshal.dump(@board))

      future_board.execute_move(start, finish, player.color)

      if future_board.check?(player.color)
        take_turn(player)
      end
    else
      take_turn(player)
      return false
    end

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
  attr_reader :color, :name

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




