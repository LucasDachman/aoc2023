#!/usr/bin/env ruby

require 'pry'
require 'pry-nav'

class Report
  def initialize(values)
    @values = values
  end

  def run
    diffs = [@values]
    i = 0
    loop do
      values = diffs[i]
      diffs[i + 1] = values.each_with_index.reduce([]) do |acc, (curr, j)|
        next(acc) if j >= values.length - 1
        acc << (values[j + 1] - curr)
      end
      i += 1
      break if diffs[-1].all? {|d| d == 0}
    end
    p diffs

    diffs.reverse_each.with_index do |diff_arr, i|
      i = diffs.size - 1 - i
      if i == diffs.size - 1
        diff_arr << 0
        next
      end
      # end
      diff = diffs[i + 1][-1]
      diff_arr << diff_arr[-1] + diff

      # beginning
      diff = diffs[i + 1][0]
      diff_arr.prepend(diff_arr[0] - diff)
    end

    diffs
  end

  def self.parse(line)
    values = line.split(" ").map(&:to_i)
    Report.new(values)
  end
end

class Part1
  def initialize(filename)
    Dir.chdir(File.dirname(__FILE__))
    @input = File.read("#{filename}.txt").strip
  end

  def run
    predictions = @input.split("\n").map do |line|
      Report.parse(line).run[0][-1]
    end
    predictions.reduce :+
  end
end

class Part2 < Part1
  def run
    predictions = @input.split("\n").map do |line|
      Report.parse(line).run[0][0]
    end
    predictions.reduce :+
  end
end


p Part2.new(ARGV[0] || "example").run
