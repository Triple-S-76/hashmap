require 'pry-byebug'

class Node
  attr_accessor :name, :value, :next_node

  def initialize(name, value)
    @name = name
    @value = value
    @next_node = nil
  end
end

class Hashmap
  attr_reader :hashmap

  def initialize
    clear
  end

  def load_factor
    size = length
    return if size.zero?

    max_load = @hashmap.length * 0.75
    grow_hashmap if max_load <= size
  end

  def keys
    keys_or_values('keys')
  end

  def values
    keys_or_values('values')
  end

  def entries
    keys_or_values('entries')
  end

  def keys_or_values(type)
    array = []
    @hashmap.each do |cell|
      current_cell = cell
      until current_cell.next_node.nil?
        fill_array(type, array, current_cell)
        current_cell = current_cell.next_node
      end
    end
    array
  end

  def clear(number = 16)
    @hashmap = Array.new(number) { Node.new('HEAD NODE', 'Head node') }
  end

  def length
    count = 0
    @hashmap.each do |cell|
      current_cell = cell
      until current_cell.next_node.nil?
        count += 1
        current_cell = current_cell.next_node
      end
    end
    count
  end

  def remove(name_to_remove)
    parent = get(name_to_remove, 'child')
    return nil if parent.nil?

    node_to_remove = parent.next_node
    parent.next_node = node_to_remove.next_node
    node_to_remove.next_node = nil
    node_to_remove
  end

  def key?(name_to_find)
    result = get(name_to_find)
    result.nil? ? false : true
  end

  def get(name_to_find, parent_or_child = 'parent')
    node = nil
    @hashmap.each do |cell|
      current_cell = cell

      node = cell_name_match(name_to_find, current_cell)
      next if node.nil?
      return node if parent_or_child == 'child'

      return node.next_node
    end
    nil
  end

  def set(name, value)
    load_factor
    new_node = Node.new(name, value)
    hashed_name = hash(name)
    bucket_number = modulo(hashed_name)
    @hashmap[bucket_number].nil? ? @hashmap[bucket_number] = new_node : collition(new_node, bucket_number)
  end

  private

  def fill_array(type, array, current_cell)
    case type
    when 'keys'
      array << current_cell.next_node.name
    when 'values'
      array << current_cell.next_node.value
    else
      subarray = []
      subarray << current_cell.next_node.name
      subarray << current_cell.next_node.value
      array << subarray
    end
  end

  def cell_name_match(name_to_find, cell)
    current_cell = cell
    loop do
      break if current_cell.next_node.nil?

      return current_cell if current_cell.next_node.name == name_to_find

      current_cell = current_cell.next_node
    end
    nil
  end

  def collition(new_node, bucket_number)
    current_node = @hashmap[bucket_number]
    until current_node.next_node.nil? || current_node.name == new_node.name
      current_node = current_node.next_node
    end
    return if current_node.name == new_node.name

    current_node.next_node = new_node
  end

  def modulo(number)
    number_of_buckets = @hashmap.length
    number % number_of_buckets
  end

  def hash(name)
    string_to_number(name)
  end

  def string_to_number(string)
    number = 0
    string.each_char { |letter| number += letter.ord }
    number
  end

  def grow_hashmap
    all_entries = entries
    new_hashmap_size = @hashmap.length * 2
    clear(new_hashmap_size)
    all_entries.each do |name, value|
      set(name, value)
    end
  end
end

if $PROGRAM_NAME == __FILE__

  my_hashmap = Hashmap.new
  p my_hashmap.hashmap.length

end
