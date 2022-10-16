# frozen_string_literal: true

# binary search tree node
class Node
  include Comparable

  def initialize(data = nil, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end

  attr_accessor :data, :left, :right

  def <=>(other)
    data <=> other.data
  end
end

# balanced binary search tree
class Tree
  def initialize(array)
    @root = build_tree(clean_array(array))
  end

  attr_reader :root

  def build_tree(array, first = 0, last = array.size - 1)
    return nil if first > last

    mid = (first + last) / 2
    root = Node.new(array[mid])
    root.left = build_tree(array, first, mid - 1)
    root.right = build_tree(array, mid + 1, last)
    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(data, current_node = @root)
    return insert_node(data, current_node) if current_node.left.nil? || current_node.right.nil?

    insert(data, current_node.left) if data < current_node.data
    insert(data, current_node.right) if data > current_node.data
  end

  def delete(data, current_node = @root, prev_node = nil)
    return delete(data, current_node.left, current_node) if data < current_node.data

    return delete(data, current_node.right, current_node) if data > current_node.data

    delete_node(current_node, prev_node) if data == current_node.data
  end

  private

  def insert_node(data, current_node)
    new_node = Node.new(data)
    current_node.left = new_node if data < current_node.data
    current_node.right = new_node if data > current_node.data
    new_node
  end

  def delete_node(current_node, prev_node)
    if current_node.left.nil? && current_node.right.nil?
      delete_node_zero_children(current_node, prev_node)
    elsif current_node.left.nil? ^ current_node.right.nil?
      delete_node_one_child(current_node)
    else
      delete_node_two_children(current_node)
    end
  end

  def delete_node_zero_children(current_node, prev_node)
    current_node < prev_node ? prev_node.left = nil : prev_node.right = nil
  end

  def delete_node_one_child(current_node)
    current_node.data = current_node.left.data if current_node.right.nil?
    current_node.data = current_node.right.data if current_node.left.nil?
    current_node.left = nil
    current_node.right = nil
  end

  def delete_node_two_children(current_node)
    successor_node = get_minimum_data_node(current_node.data, current_node.right, current_node)
    current_node.data = successor_node[0].data
    delete_node(successor_node[0], successor_node[1])
  end

  def get_minimum_data_node(data, current_node, prev_node)
    return [current_node, prev_node] if current_node.left.nil?

    get_minimum_data_node(data, current_node.left, current_node)
  end

  def clean_array(array)
    array.sort.uniq
  end
end

arr = [1, 7, 4, 23, 8, 9, 4, 3]
p arr.sort.uniq
tree = Tree.new(arr)
tree.insert(10)
tree.insert(2)
tree.insert(0)
tree.pretty_print
tree.delete(23)
tree.delete(7)
tree.pretty_print
