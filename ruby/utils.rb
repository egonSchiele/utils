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

