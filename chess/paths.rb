module Paths
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