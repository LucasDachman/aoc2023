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

parts = {}

schematic.each_with_index do |row, x|
  positions = row.enum_for(:scan, /[0-9]+/).map { Regexp.last_match.begin(0) }
  positions.each do |y|
    numStr = row[y..-1].match(/[0-9]+/)[0]
    p numStr
    coords = (y...y+numStr.length).map do |subY|
      AdjacentCoord.singleton_methods(false).map do |meth|
        AdjacentCoord.send(meth, x, subY)
      end
      # p subPos
    end.flatten(1).compact.uniq
    # p cords
    coords.each do |coord|
      match = schematic[coord[0]][coord[1]].match(/[^A-Za-z0-9_\.]/)
      if match
        parts[match[0]] = 0 if !parts[match[0]]
        parts[match[0]] += numStr.to_i
      end
    end
  end
  # p positions
end

p schematic
p parts
p parts.values.reduce :+

# 519187
# 521515
