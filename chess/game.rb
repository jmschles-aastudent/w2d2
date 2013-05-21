class Player
  def initialize(name)
    @name
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