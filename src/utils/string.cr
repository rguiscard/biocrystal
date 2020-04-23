class String
  # Find the longest common string
  def intersect(str : String)
    return "" if [self, str].any?(&.empty?)

    matrix = Array.new(self.size) { Array.new(str.size) { 0 } }
    intersection_length = 0
    intersection_end    = 0
    self.size.times do |x|
      str.size.times do |y|
        next unless self[x] == str[y]
        matrix[x][y] = 1 + (([x, y].all?(&.zero?)) ? 0 : matrix[x-1][y-1])

        next unless matrix[x][y] > intersection_length
        intersection_length = matrix[x][y]
        intersection_end    = x
      end
    end
    intersection_start = intersection_end - intersection_length + 1

    self[intersection_start..intersection_end]
  end
end