class LinkedList
  def initialize
    @head = nil
    @tail = nil
  end

  attr_accessor :name

  def append(value)
    new_node = Node.new(value, nil)
    if @head.nil?
      @head = new_node
    else
      @tail.next_node = new_node
    end
    @tail = new_node
  end

  def prepend(value)
    new_node = Node.new(value)
    if @head.nil?
      @head = new_node
      @tail = new_node
    else
      new_node.next_node = @head
      @head = new_node
    end
  end
end

class Node
  def initialize(value = nil, next_node = nil)
    @value = value
    @next_node = next_node
  end

  attr_accessor :value, :next_node
end

p list = LinkedList.new
list.append('dog')
list.append('cat')
pp list
list.prepend('rock')
pp list