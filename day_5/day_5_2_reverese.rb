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

  def source_range
    @source_range_start...@source_range_start+@length
  end

  def dest_range
    @dest_range_start...@dest_range_start+@length
  end

  def self.parse(str)
    nums = str.split(" ")
    Conversion.new(
      dest_range_start: nums[1].to_i,
      source_range_start: nums[0].to_i,
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

  def source_ranges
    @conversions.map &:source_range
  end

  def dest_ranges
    @conversions.map &:dest_range
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
seeds_ranges = seeds_ranges.each_slice(2).map {|s| s[0]...s[0]+s[1]}

map_sections = almanac.scan(/(?<=map:\n)[\w\W]*?(?=\n\n)/)

maps = map_sections.map {|section| Map.parse(section)}
# ranges = maps[-1]
# p location_ranges

# .to_a.map do |tuple|
#   (tuple[0]...tuple[0]+tuple[1]).to_a
# end.flatten

loc_range = 0..maps[-1].dest_ranges.max_by(&:end).end

# p seeds
maps.reverse!
results = loc_range.each do |loc|
  puts "Mapping loc #{loc}"
  r = maps.reduce(loc) do |num, map|
    # p num
    map.next(num)
  end
  if seeds_ranges.any? {|range| range.include? r}
    p loc
    return
  end
  puts "loc: #{loc}\tresult: #{r}"
  [loc, r]
end

p 'fail'

# results.filter! {|res| seeds_ranges.any? {|range| range.include? res[1]}}

# binding.pry
# results.map! {|r| r[0]}
# p results.min
# p results.min_by(|r| r[0])[0]



