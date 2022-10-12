module Enumerable
  # Your code goes here
  def my_each_with_index
    i = 0
    for element in self
      yield element, i
      i += 1
    end
  end

  def my_select
    arr = []
    for element in self
      arr << element if yield element
    end
    arr
  end

  def my_all?
    for element in self
      if (yield element) == false
        return false
      end
    end
    true
  end


end

# You will first have to define my_each
# on the Array class. Methods defined in
# your enumerable module will have access
# to this method
class Array
  # Define my_each here
  def my_each
    for element in self
      yield element
    end
  end
end


# test = [1, 1, 2, 3, 5, 8, 13, 21, 34]

# p test.my_each_with_index