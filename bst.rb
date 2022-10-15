class Node
  include Comparable

  def initialize(value = nil, left = nil, right = nil)
    @value = value
    @left = left
    @right = right
  end

  attr_accessor :value, :left, :right

  def <=>(other_node)
    value <=> other_node.value
  end
end
