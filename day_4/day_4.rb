#!/usr/bin/env ruby

require 'pry'
require 'pry-nav'

Dir.chdir(File.dirname(__FILE__))
deck = File.read('input.txt').split("\n")

points = deck.reduce(0) do |sum, card|
  winners = card.match(/(?<=: ).*(?= \|)/)[0].split(" ").map(&:to_i)
  picked = card.match(/(?<=\|).*$/)[0].split(" ").map(&:to_i)
  matches = winners & picked
  p winners
  p picked
  p matches
  result = sum + ((0..matches.size).reduce {|i| i == 0 ? 1 : i * 2} || 0)
  p result
  result
end

p points
