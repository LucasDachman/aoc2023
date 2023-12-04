#!/usr/bin/env ruby

require 'pry'
require 'pry-nav'

Dir.chdir(File.dirname(__FILE__))
schematic = File.read('input.txt').split("\n")

MAX_X = schematic.size - 1
MAX_Y = schematic[0].size - 1

class AdjacentCoord

  def self.top_left(x, y)
    return nil if x == 0 || y == 0
    return [x - 1, y - 1]
  end

  def self.top(x, y)
    return nil if x == 0
    return [x - 1, y]
  end

  def self.top_right(x, y)
    return nil if y == MAX_Y || x == 0
    return [x - 1, y + 1]
  end

  def self.right(x, y)
    return nil if y == MAX_Y
    return [x, y + 1]
  end

  def self.bottom_right(x, y)
    return nil if x == MAX_X || y == MAX_Y
    return [x + 1, y + 1]
  end

  def self.bottom(x, y)
    return nil if x == MAX_X
    return [x + 1, y]
  end

  def self.bottom_left(x, y)
    return nil if x == MAX_X || y == 0
    return [x + 1, y - 1]
  end

  def self.left(x, y)
    return nil if y == 0
    return [x, y - 1]
  end
end

def adjCoords(x, y)
  AdjacentCoord.singleton_methods(false).map do |meth|
    AdjacentCoord.send(meth, x, y)
  end.compact.uniq
end

class Locatable
  attr_accessor :x, :y, :schematic

  def initialize(x, y, schematic)
    @x = x
    @y = y
    @schematic = schematic
  end

  def gear?
    coords = adjCoords(@x, @y)
    values = coords.map {|coord| @schematic[coords[0]][coords[1]]}
    numVals = values.filter {|v| v.match /^[0-9]$/}
    numVals.size == 2
  end
end

# class Gear < Locatable
#   attr_accessor :num1, :num2

#   def initialize(x:, y:, num1:, num2:)
#     super(x, y)
#     @num1 = num1
#     @num2 = num2
#   end
# end

class Number < Locatable
  def initialize(x:, y:, schematic:)
    super(x, y, schematic)
  end

  def star_pos
    size = num_value.to_s.size

    (@y...@y+size).map do |y|
      coords = adjCoords(@x, y)
      coords.filter do |coord|
        @schematic[coord[0]][coord[1]] == "*"
      end
    end.flatten(1).uniq
  end

  def num_value
    ptr = @y
    ptr -= 1 until @schematic[@x][ptr - 1].match(/[0-9]/) == nil || ptr == 0
    number = @schematic[@x][ptr..-1].match(/[0-9]+/)[0]
    number.to_i
  end

  def coords
    [@x, @y]
  end
end

nums = []
star_to_number = {}

schematic.each_with_index do |row, x|
  numPositions = row.enum_for(:scan, /[0-9]+/).map { Regexp.last_match.begin(0) }
  nums = nums + numPositions.map {|pos| Number.new(x: x, y: pos, schematic: schematic)}
end

nums.each do |num|
  p num.num_value
  num.star_pos.each do |star_pos|
    p star_pos
    key = star_pos#star_pos[0].to_s+star_pos[1].to_s
    star_to_number[key] = [] if !star_to_number[key]
    star_to_number[key] << num.num_value
  end
end

p nums.map &:coords
p star_to_number

answer = star_to_number.values.reduce(0) do |sum, nums|
  next(sum) if nums.size != 2
  next sum + nums.reduce(:*)
end

p answer

# 69108545

# gear_nums = nums.filter do |num|
#   num.star_pos(schematic).each do |star_pos|
#     match = nums.find do |n|
#       n.star_pos(schematic).includes star_pos
#     end
#   end
# end

# p gear_nums
