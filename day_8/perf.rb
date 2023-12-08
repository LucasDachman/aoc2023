#!/usr/bin/env ruby

require './day_8_2.rb'
require 'benchmark/ips'

p2 = Part2.new("example_3")
Benchmark.ips do |x|
  x.report('Brute') { |n| n.times do p2.brute end}
  x.report('Opt') { |n| n.times do p2.opt end}
  x.compare!
end
