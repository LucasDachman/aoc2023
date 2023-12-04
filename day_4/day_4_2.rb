#!/usr/bin/env ruby

require 'pry'
require 'pry-nav'

Dir.chdir(File.dirname(__FILE__))
deck = File.read('input.txt').split("\n")

deck.each.with_index do |card, index|
  card_num = card.match(/\d+(?=:)/)[0].to_i
  p card_num
  winners = card.match(/(?<=: ).*(?= \|)/)[0].split(" ").map(&:to_i)
  picked = card.match(/(?<=\|).*$/)[0].split(" ").map(&:to_i)
  matches = winners & picked
  count = matches.size
  puts "#{card}\t#{count}"
  i = card_num
  while i < card_num + count
    puts "adding #{deck[i]}"
    deck << deck[i]
    i += 1
  end
end

p deck.size
