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
      (return false) unless yield element
    end
    true
  end

  def my_any?
    for element in self
      (return true) if yield element
    end
    false
  end

  def my_none?
    for element in self
      (return false) if yield element
    end
    true
  end

  def my_count
    arr = []
    return self.size unless block_given?

    for element in self
      arr << element if yield element
    end
    arr.size
  end

  def my_map
    arr = []
    for element in self
      arr << (yield element)
    end
    arr
  end

  def my_inject(initial_value)
    acc = initial_value
    for element in self
      acc = (yield acc, element)
    end
    acc
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
