class LinkedList
  def initialize
    @head = nil
    @tail = nil
  end

  attr_accessor :name
  attr_reader :head, :tail

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

  def size
    count = 0
    current_node = @head
    return count if @head.nil? && @tail.nil?
    until current_node.nil?
      count += 1
      current_node = current_node.next_node
    end
    count
  end

  def at(index)
    return nil if index >= size || index < 0

    current_node = @head
    index.times do 
      current_node = current_node.next_node
    end
    current_node
  end

  def pop
    old_tail = @tail
    @tail = at(size - 2)
    @tail.next_node = nil
    old_tail
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
# p "head: #{list.head} tail: #{list.tail}"
list.append('dog')
list.append('cat')
list.prepend('rock')
pp list
p "0: #{list.at(0).value}"
p "1: #{list.at(1).value}"
p "2: #{list.at(2).value}"
p list.size
p list.pop
pp list
p list.size