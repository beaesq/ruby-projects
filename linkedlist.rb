class LinkedList

end

class Node
  def initalize(value = nil, next_node = nil)
    @value = value
    @next_node = next_node
  end

  attr_accessor :value
end