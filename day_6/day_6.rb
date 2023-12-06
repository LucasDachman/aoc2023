#!/usr/bin/env ruby

require 'pry'
require 'pry-nav'

Dir.chdir(File.dirname(__FILE__))
input = File.read("#{ARGV[0]}.txt").strip

class Race
  def initialize(time, record_dist)
    @time = time
    @record_dist = record_dist
  end

  def find_first
    t_press = 1
    loop do
      remaining = @time - t_press
      dist = remaining * t_press
      break if dist > @record_dist
      t_press += 1
    end
    t_press
  end

  def find_last
    t_press = @time - 1
    loop do
      remaining = @time - t_press
      dist = remaining * t_press
      break if dist > @record_dist
      t_press -= 1
    end
    t_press
  end

  def hold_down_time_range
    (find_first..find_last)
  end

  def self.parse(input)
    time_str, dist_str = *input.split("\n")
    times = time_str.scan(/\d+/).map(&:to_i)
    dists = dist_str.scan(/\d+/).map(&:to_i)
    (0...times.size).map do |i|
      Race.new times[i], dists[i]
    end
  end
end

races = Race.parse(input)
p races

sizes = races.map do |race|
  p race.hold_down_time_range.size
end

result = sizes.reduce :*
p result
