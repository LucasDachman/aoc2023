#!/usr/bin/env ruby

require 'pry'
require 'pry-nav'

Dir.chdir(File.dirname(__FILE__))
almanac = File.read('input.txt') << "\n"

class Conversion
  def initialize(dest_range_start:, source_range_start:, length:)
    @dest_range_start = dest_range_start
    @source_range_start = source_range_start
    @length = length
  end

  def next(num)
    return nil unless num.between?(@source_range_start, @source_range_start+@length-1)
    diff = @dest_range_start - @source_range_start
    return num + diff
  end

  def self.parse(str)
    nums = str.split(" ")
    Conversion.new(
      dest_range_start: nums[0].to_i,
      source_range_start: nums[1].to_i,
      length: nums[2].to_i
    )
  end
end

class Map
  def initialize(conversions)
    @conversions = conversions
  end

  def next(num)
    con = @conversions.find {|c| c.next(num) != nil}
    con == nil ? num : con.next(num)
  end

  def self.parse(map_str)
    conversion_strs = map_str.split("\n")
    conversions = conversion_strs.map do |str|
      Conversion.parse(str)
    end
    Map.new(conversions)
  end
end

seeds = almanac.match(/(?<=seeds: ).*(?=\n)/)[0].split(" ").map(&:to_i)
p seeds

map_sections = almanac.scan(/(?<=map:\n)[\w\W]*?(?=\n\n)/)

maps = map_sections.map {|section| Map.parse(section)}

results = seeds.map do |seed|
  r = maps.reduce(seed) do |num, map|
    map.next(num)
  end
  puts "seed: #{seed}\tresult: #{r}"
  r
end

p results.min

