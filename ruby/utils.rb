class Array
  # replace all instances of x with y and return a new array with the result
  def replace_all(x, y)
    new_arr = map do |elem|
      elem == x ? y : elem
    end
    new_arr
  end

  def sum
    inject( nil ) do |sum,x|
      sum ? sum+x : x
    end
  end

  def mean
    sum.to_f/size
  end
end

# like Dir.glob, except gets all files recursively and skips invisible and symlinked files automatically
def self.files_in(directory)
  raise "#{directory} is not a directory" unless File.directory?(directory)
  Dir[File.join(directory, '**', '*')].sort.select do |path|
    File.file?(path) && File.readable?(path) && !File.symlink?(path) &&
        !path.start_with?('.') && !path.end_with?('~')
  end
end

