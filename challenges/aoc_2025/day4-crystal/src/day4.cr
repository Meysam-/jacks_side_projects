file = File.new("day4.txt")
content = file.gets_to_end
file.close

grid = content.lines()
count = Day4.count_accessible(grid)
puts "#{count} accessible paper rolls"

total = 0
count = 100

while count > 0
  new_stuff = Day4.count_and_remove(grid)
  grid = new_stuff[0]
  total += new_stuff[1]
  count = new_stuff[1]
end

puts "#{total} removed"


module Day4
  extend self

  def is_paper(grid, idx, jdx)
    return grid[idx][jdx] == '@'
  end

  def is_accessible(grid, idx, jdx)
    count = 0
    (-1..1).each do |i|
      (-1..1).each do |j|
        row = idx + i
        col = jdx + j
        if row < 0 || row >= grid[0].size || col < 0 || col >= grid.size
          next
        end

        if is_paper(grid, row, col)
          count += 1
        end
      end
    end


    return count <= 4
  end

  def count_accessible(grid)
    count = 0
    (0...grid.size).each do |idx|
      (0...grid[0].size).each do |jdx|
        next if !Day4.is_paper(grid, idx, jdx)

        if is_accessible(grid, idx, jdx)
          count += 1
        end
      end
    end
    return count
  end


  def count_and_remove(grid)
    new_grid = [] of String
    count = 0
    (0...grid.size).each do |idx|
      new_grid.push(String.new())
      (0...grid[0].size).each do |jdx|
        if !Day4.is_paper(grid, idx, jdx)
          new_grid[idx] = new_grid[idx] + '.'
        elsif is_accessible(grid, idx, jdx)
          new_grid[idx] = new_grid[idx] + '.'
          count += 1
        else
          new_grid[idx] = new_grid[idx] + '@'
        end
      end
    end
    return {new_grid, count}
  end
end
