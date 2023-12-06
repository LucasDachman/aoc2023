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
    @cache = {}
  end

  def next(num)
    return @cache[num] if @cache[num] != nil
    con = @conversions.find {|c| c.next(num) != nil}
    result = con == nil ? num : con.next(num)
    @cache[num] = result
    result
  end

  def self.parse(map_str)
    conversion_strs = map_str.split("\n")
    conversions = conversion_strs.map do |str|
      Conversion.parse(str)
    end
    Map.new(conversions)
  end
end

seeds_ranges = almanac.match(/(?<=seeds: ).*(?=\n)/)[0].split(" ").map(&:to_i)
p seeds_ranges

map_sections = almanac.scan(/(?<=map:\n)[\w\W]*?(?=\n\n)/)

maps = map_sections.map {|section| Map.parse(section)}

seed_ranges = seeds_ranges.each_slice(2)

# .to_a.map do |tuple|
#   (tuple[0]...tuple[0]+tuple[1]).to_a
# end.flatten

# p seeds
cache = {}
results = seed_ranges.flat_map do |seed_range|
  (seed_range[0]...seed_range[0]+seed_range[1]).map do |seed|
    next(cache[seed]) if cache[seed]
    puts "Mapping seed #{seed}"
    r = maps.reduce(seed) do |num, map|
      p num
      map.next(num)
    end
    puts "seed: #{seed}\tresult: #{r}"
    cache[seed] = r
    r
  end
end

p results.min

