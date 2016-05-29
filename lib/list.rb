#!/usr/bin/env ruby

# Extend array class with a to_l method.
class Array
  def to_l
    List.new(self)
  end
end

# Double Linked Node
class Node
  include Enumerable

  attr_accessor :data, :prev, :next

  def initialize(data = nil)
    @data = data
    @prev = @next = nil
    self
  end

  def insert(data, direction)
    other_direction = direction == 'next' ? 'prev' : 'next'

    node = Node.new(data)
    node.public_send(other_direction + '=', self)
    node.public_send(direction + '=', public_send(direction))

    unless public_send(direction).nil?
      public_send(direction).public_send(other_direction + '=', node)
    end

    public_send(direction + '=', node)
  end

  def insert_before(data)
    insert(data, 'prev')
  end

  def insert_after(data)
    insert(data, 'next')
  end

  def remove
    @prev.next = @next unless @prev.nil?
    @next.prev = @prev unless @next.nil?
  end

  def each
    return enum_for(:each) unless block_given?
    node = self
    until node.nil?
      yield node
      node = node.next
    end
  end

  def reverse_each
    return enum_for(:reverse_each) unless block_given?
    node = self
    until node.nil?
      yield node
      node = node.prev
    end
  end
end

# Doubly Linked List
class List
  include Enumerable

  attr_reader :length

  def initialize(data = nil)
    @length = 0

    if data.nil?
      @head = nil
      @tail = nil
    elsif data.class == Array
      data.each { |e| append e }
    else
      add_first_node(data)
    end

    self
  end

  private

  def validate_index(index)
    if index >= @length || index < -@length
      raise IndexError,
            "index #{index} outside of list bounds: " +
            (empty? ? 'list is empty' : "#{-@length}..#{@length - 1}")
    elsif index > @length / 2
      index -= @length
    elsif index < -@length / 2
      index += @length
    end

    index
  end

  def get_node(index)
    index = validate_index(index)

    if index < 0
      index = index.abs - 1
      node = @tail.reverse_each
    else
      node = @head.each
    end

    node.next while (index -= 1) >= 0

    node.peek
  end

  def add_first_node(data)
    @head = Node.new(data)
    @tail = @head
    @length = 1
  end

  public

  def prepend(data)
    if empty?
      add_first_node(data)
    else
      @head = @head.insert_before(data)
      @length += 1
    end

    self
  end

  def insert(index, data)
    if index == 0
      prepend(data)
    elsif index < @length
      get_node(index).insert_before(data)
      @length += 1
    else
      append(nil) while index > @length
      append(data)
    end

    self
  end

  def append(data)
    if empty?
      add_first_node(data)
    else
      @tail = @tail.insert_after(data)
      @length += 1
    end

    self
  end

  def first
    get(0)
  end

  def get(index)
    get_node(index).data
  end
  alias [] get

  def last
    get(-1)
  end

  def set(index, data)
    get_node(index).data = data
  end
  alias []= set

  def delete(index)
    node = get_node(index)

    node.remove

    @head = @head.next if node == @head
    @tail = @tail.prev if node == @tail

    @length -= 1

    node.data
  end

  def empty?
    @length == 0
  end

  def each
    return enum_for(:each) unless block_given?
    @head.each { |node| yield node.data }
  end

  def reverse_each
    return enum_for(:reverse_each) unless block_given?
    @tail.reverse_each { |node| yield node.data }
  end

  def inspect
    output = '['
    each.with_index do |data, i|
      output.concat(i == 0 ? data.inspect : ', ' << data.inspect)
    end
    output.concat(']')
  end
  alias to_s inspect
end
